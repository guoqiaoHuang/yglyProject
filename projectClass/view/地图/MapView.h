//
//  MapView.h
//  yglyProject
//
//  Created by 枫 on 14-9-28.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackTitleUIImageView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MapButton.h"
#import "GeocodeAnnotation.h"

@interface MapView : BackTitleUIImageView

@property (nonatomic,retain) NSArray *btnArray;
@property (nonatomic,retain) MAPointAnnotation *currentPointAnnotation;
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) AMapSearchAPI *search;
@property (nonatomic,retain) NSMutableArray *tips;//存放的是 AMapTip数组
@property (nonatomic, assign) AMapTip *curSelectTip;//存放当前被选择的 起始点（AMapTip）
@property (nonatomic, assign) GeocodeAnnotation *curGeoCodeAnnotation;//存放当前被选的的 起始点的地理位置信息
@property (nonatomic, assign) NSInteger selectEndBtnIndex;//存放选中的目的地的索引值
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
@property (nonatomic,assign)BOOL isFromShowLinesView;//是否是来自MapViewShowLinesView（主要用于）

- (void)searchTipsWithKey:(NSString *)key;
/* 展示当前路线方案. */
- (void)presentCurrentCourse;
/* 清空地图上的overlay. */
- (void)clear;

@end
