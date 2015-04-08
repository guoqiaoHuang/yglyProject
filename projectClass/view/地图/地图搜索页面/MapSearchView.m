//
//  SearchView.m
//  yglyProject
//
//  Created by 枫 on 14-10-30.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "MapSearchView.h"
#import "LhLocationModel.h"
#import "MainViewController.h"
#import "MapButton.h"

@interface MapSearchView ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

static NSString *cellIndentifier = @"searchCell";
@implementation MapSearchView

- (void)dealloc{
    [super dealloc];
}
- (void)showView{
    
    [super showView];
    
    if (_type == 0) {
        [self showUISearchBarList:@"BaseUISearchBar" index:0];
        lhSearchBar = (UISearchBar *)[self viewWithTag:611];
        lhSearchBar.delegate = self;
        //searchBar的裁剪，请保证searchBar的默认宽度 44
        [Utility AddRoundedCorners:lhSearchBar rect:[self getSearchFieldFrame] size:15 type:UIRectCornerAllCorners];
        [lhSearchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    }
    [self initResultTableView];
}
#pragma mark -获取searchBar textField的frame
- (CGRect)getSearchFieldFrame{
    CGFloat width = CGRectGetWidth(lhSearchBar.frame);
    CGFloat heigh = CGRectGetHeight(lhSearchBar.frame);
    CGRect rect = lhSearchBar.frame;
    rect.origin.x = 8;
    rect.origin.y = 7;
    rect.size.width = width - 16;
    rect.size.height = heigh - 14;
    
    return rect;
}
#pragma mark 初始化一个用来显示搜索结果的tableView
- (void)initResultTableView{
    
    _tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 17, self.size.width, self.size.height-15) style:UITableViewStyleGrouped]autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self insertSubview:_tableView belowSubview:self.naviView];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_type == 0) {//起始点搜索
        if (_delegate) {
            return [_delegate.tips count];
        }
    }else if(_type == 1){
        if (_delegate) {
            return [_delegate.btnArray count];
        }
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
    }
    if (_type == 1) {
        MapButton *btn = [_delegate.btnArray objectAtIndex:indexPath.row];
        cell.textLabel.text = btn.title;
    }else if (_type == 0){
        
        AMapTip *tip = [_delegate.tips objectAtIndex:indexPath.row];
        cell.textLabel.text = tip.name;
    }
    return cell;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == 1) {
        
        UILabel *tmpLabel = (UILabel *)[_delegate viewWithTag:227];
        MapButton *btn = [_delegate.btnArray objectAtIndex:indexPath.row];
        tmpLabel.text = btn.title;
        _delegate.selectEndBtnIndex = indexPath.row;
        [ObserversNotice TellViewNotice:YGLYNoticeTypeMapStartOrEndLocationDidChange];
    }else if (_type == 0){
    
        UILabel *tmpLabel = (UILabel *)[_delegate viewWithTag:226];
        AMapTip *tip = [_delegate.tips objectAtIndex:indexPath.row];
        _delegate.curSelectTip = tip;
        tmpLabel.text = tip.name;
    }
   
  //  [ObserversNotice TellViewNotice:YGLYNoticeTypeMapStartOrEndLocationDidChange];
    [self backClicked:nil];
}

#pragma mark  监测到改变
-(void)receiveNotifications:(NSInteger)type{
    
    if (type == YGLYNoticeTypeMapTipSearchDidComplete && _type == 0) {
        
        [_tableView reloadData];
    }
}

#pragma mark- searchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (_delegate) {
        [_delegate searchTipsWithKey:searchBar.text];
    }
}

#pragma mark push popo
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.35 Type:kCATransitionFade Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionFade Subtype:kCATransitionFromBottom];
}

@end
