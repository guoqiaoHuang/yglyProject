//
//  MapViewShowLinesView.m
//  yglyProject
//
//  Created by 枫 on 15-1-14.
//  Copyright (c) 2015年 雷海. All rights reserved.
//

#import "MapViewShowLinesView.h"

@implementation MapViewShowLinesView


-(void)showView{
    
    [super showView];
    
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, self.naviView.height, 320,  self.height-self.naviView.height) style:UITableViewStylePlain] autorelease];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LineCell"];
    [self insertSubview:_tableView atIndex:0];
}

#pragma mark- tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_type == 0) {
        return [_route.transits count];
    }
    return [_route.paths count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_type == 0) {
        
        AMapTransit *transit = _route.transits[section];
        return [transit.segments count]-1;
    }
    AMapPath *step = _route.paths[section];
    return [step.steps count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LineCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 1;
    
    if (_type == 0) {
        
        AMapTransit *transit = _route.transits[indexPath.section];
        AMapBusLine *busline = ((AMapSegment *)transit.segments[indexPath.row]).busline;
        
        if (busline != nil)
        {
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [NSString stringWithFormat:@"%@-->%@\r\n%@", busline.departureStop.name, busline.arrivalStop.name,busline.name];
        }
        else
        {
            cell.textLabel.text = @"步行";
        }
    }else{
        AMapPath *step = _route.paths[indexPath.section];
        cell.textLabel.text = ((AMapStep*)step.steps[indexPath.row]).instruction;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"方案 %zi",section+1];
}
#pragma mark- tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type == 0) {//公交
        
        [self backClicked:nil];
        [Utility delay:0.6 action:^{
            _mapView.currentCourse = indexPath.row;
            [_mapView clear];
            [_mapView presentCurrentCourse];
        }];
    }
}


#pragma mark- propertyList
-(void)setRoute:(AMapRoute *)route{
    _route = route;
    [_tableView reloadData];
}
#pragma mark 获取push特效
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionFade Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionFade Subtype:kCATransitionFromBottom];
}
@end
