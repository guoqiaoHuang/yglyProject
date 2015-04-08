//
//  MapViewShowLinesView.h
//  yglyProject
//
//  Created by 枫 on 15-1-14.
//  Copyright (c) 2015年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "MapView.h"

@interface MapViewShowLinesView : BackTitleUIImageView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,assign)NSInteger type;//1-步行 0-公交
@property(nonatomic,assign)AMapRoute *route;
@property(nonatomic,assign)MapView* mapView;
@end
