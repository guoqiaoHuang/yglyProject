//
//  MapView.m
//  yglyProject
//
//  Created by 枫 on 14-9-28.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "MapView.h"
#import "LhLocationModel.h"
#import "GatherAnnotationView.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "UtilityExt.h"
#import "RouteDetailViewController.h"
#import "HBJUIImage.h"
#import "MapSearchView.h"
#import "MapViewShowLinesView.h"

#define defaultCity @"陕西省"
//34.2226694111,108.9467158763 小寨
//34.2700847438,108.9551404490 体育场
//34.2343828961,108.8761229168 西辛庄

@interface MapView ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    MAPolyline *gatherPolyline;//保存连接集结点的覆盖物（直线）
    UIButton *_btn[3];
    UIPanGestureRecognizer *_pan;
    BOOL overFlage;//overView是否滑动至顶端；
}
@property(nonatomic,assign)UIView *overView;
@property(nonatomic,retain)NSMutableArray *gatherPointArray;

@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, retain) AMapRoute *route;

/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@end

@implementation MapView

-(void)dealloc{
    
     self.currentPointAnnotation = nil;
    [self clearSearch];
    [self clearMapView];
    self.search = nil;
    self.mapView = nil;
    self.overView = nil;
    self.gatherPointArray = nil;
    self.btnArray = nil;
    gatherPolyline = nil;
    self.route = nil;
    self.tips = nil;
    
    [super dealloc];
}

#pragma mark - Utility

/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    if (self.currentCourse > 0) {
        
        _btn[0].userInteractionEnabled = YES;
        _btn[0].enabled = YES;
    }else{
        
        _btn[0].userInteractionEnabled = NO;
        _btn[0].enabled = NO;
    }
    
    /* 下一个. */
    if (self.currentCourse < self.totalCourse - 1) {
        
        _btn[1].userInteractionEnabled = YES;
        _btn[1].enabled = YES;
    }else{
        
        _btn[1].userInteractionEnabled = NO;
        _btn[1].enabled = NO;
    }
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    if (self.route) {
        
        _btn[2].userInteractionEnabled = YES;
        _btn[2].enabled = YES;
    }else{
        
        _btn[2].userInteractionEnabled = NO;
        _btn[2].enabled = NO;
    }
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.searchType)
        {
            case AMapSearchType_NaviDrive   :
            case AMapSearchType_NaviWalking : total = self.route.paths.count;    break;
            case AMapSearchType_NaviBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.currentCourse]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    MAMapRect mapRect = [CommonUtility mapRectForOverlays:polylines];
    mapRect = [_mapView mapRectThatFits:mapRect edgePadding:UIEdgeInsetsMake(CGRectGetMaxY(_overView.frame)+50, 0, 0, 0)];
}

/* 清空地图上的overlay. */
- (void)clear
{
    [self.mapView removeOverlays:self.mapView.overlays];
}
/* 进入详情页面. */
- (void)gotoDetailForRoute:(AMapRoute *)route type:(AMapSearchType)type
{
    RouteDetailViewController *routeDetailViewController = [[[RouteDetailViewController alloc] init] autorelease];
    routeDetailViewController.route      = route;
    routeDetailViewController.searchType = type;
    [self.controller.navigationController pushViewController:routeDetailViewController animated:YES];
}


- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    _mapView.delegate = nil;
}

- (void)clearSearch
{
    _search.delegate = nil;
}

-(void)showView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self initMapView];
    self.gatherPointArray = [NSMutableArray array];
    [super showView];
    [self initSearch];
    [self initOverView];
    [self addAction];
    
    [self showButtonList:@"Buttons" index:0];
   
    
    UIView *view = [self viewWithTag:111];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-3, -3, view.size.width + 6, view.size.height + 6) cornerRadius:1];
    view.clipsToBounds = NO;
    view.layer.shadowPath =bezier.CGPath;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
   
    [self showUIViewList:@"UIViews" index:2];
    view = [self viewWithTag:731];
    view.clipsToBounds = YES;
    CGFloat width = view.width/3.0;
    CGFloat height = view.height;
    NSArray *titleArray = @[@"上一个",@"下一个",@"详情"];
    UIImage *bgImage= [UIImage imageFromColor:[[UIColor grayColor] colorWithAlphaComponent:0.7] size:CGSizeMake(width, height)];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){{i*width,0},{width,height}};
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(segBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        button.enabled = NO;
        [view addSubview:button];
        _btn[i] = button;
    }
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-3, -3, view.size.width + 6, view.size.height + 6) cornerRadius:1];
    view.clipsToBounds = NO;
    view.layer.shadowPath =bezier.CGPath;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.hidden = YES;
    
    _isFromShowLinesView = NO;
    overFlage = YES;
    self.tips = [[[NSMutableArray alloc] init] autorelease];
}

#pragma mark - 视图已经出现
-(void)viewdidShow{
    
    if (overFlage && !_isFromShowLinesView) {
        self.overView.userInteractionEnabled = NO;
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.overView.point = CGPointMake(0, _overView.point.y+170);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.overView.point = CGPointMake(0, _overView.point.y-170);
            } completion:^(BOOL finished) {
                self.overView.userInteractionEnabled = YES;
            }];
        }];
        _isFromShowLinesView = YES;
    }
}

#pragma mark - 地图初始化
- (void)initMapView
{
    self.mapView  = [[[MAMapView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 50)]autorelease];
    self.mapView.delegate = self;
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    
    _pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideOverView:)] autorelease];
    _pan.delegate = self;
    [_mapView addGestureRecognizer:_pan];
    
    [self addSubview:self.mapView];
    
}
#pragma mark gestuerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize{
    
    return YES;
}

- (void)initSearch
{
    self.search =  [[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil]autorelease];
    self.search.timeOut = 5.0f;
    self.search.delegate = self;
}

-(void)initOverView{
    
    [self showUIViewList:@"UIViews" index:0];
    self.overView = [self viewWithTag:998801];
    [_overView makeInsetShadowWithRadius:3 Color:[UIColor groupTableViewBackgroundColor] Directions:[NSArray arrayWithObject:@"bottom"]];
    
    [self showUIViewList:@"UIViews" index:1 uiview:_overView];
    
    [self showUILabelList:@"UILabel" index:1 uiview:_overView];
    
    [self showButtonList:@"Buttons" index:1 uiview:_overView];
    
    [self showUILabelList:@"UIimageview" index:1 uiview:_overView];
    
    [[_overView viewWithTag:722] addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transport:)] autorelease]];
  //  [self showUITextFieldList:@"TextField" index:1 uiview:_overView];
   // [self showColorButtonList:@"ColorButtons" index:1 uiview:_overView];
//    UITextField *textF = (UITextField *)[self viewWithTag:621];
//    textF.delegate = self;
//    textF = (UITextField *)[self viewWithTag:622];
//    textF.delegate = self;
    
    [self showOverView];
    
    UISwipeGestureRecognizer *swipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)]autorelease];
    [swipe setNumberOfTouchesRequired:1];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.overView addGestureRecognizer:swipe];
    
    
    swipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)]autorelease];
    [swipe setNumberOfTouchesRequired:1];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.overView addGestureRecognizer:swipe];
    
}

#pragma mark- 选择交通工具
-(void)transport:(UITapGestureRecognizer *)tap{
    
    CGPoint tapPoint = [tap locationInView:tap.view];
    if(tapPoint.x < self.width/2){
        
        [self byBus:nil];
    }else{
        
        [self byFoot:nil];
    }
}
#pragma mark - 收回覆盖的视图
-(void)hideOverView:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        [self handleSwipe:_overView.gestureRecognizers[0]];
    }
}
/* 识别滑动手势 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = self.overView.point;
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        location.y -= 170;
        [self textFieldResignFirstResponder];
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        location.y += 170;
    }
    
    if (location.y == -120 || location.y == 50) {
        [UIView animateWithDuration:0.5 animations:^{
            self.overView.point = location;
        }];
    }
    
}

#pragma mark 显示overView
-(void)showOverView{
    
    [self insertSubview:_overView belowSubview:[self viewWithTag:511]];
    CGPoint location = self.overView.point;
    location.y -= 170;
    _overView.point = location;
}
- (void)textFieldResignFirstResponder{
    
    UITextField *textF = (UITextField *)[self viewWithTag:621];
    [textF resignFirstResponder];
    textF = (UITextField *)[self viewWithTag:622];
    [textF resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.mapView.scrollEnabled = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.mapView.scrollEnabled = YES;
}

#pragma mark- 定位按钮按下

-(void)locationBtnClicked:(UIButton *)sender{
    
    CLLocationCoordinate2D location = [LhLocationModel shareLocationModel].curUserLocation;
    if (CLLocationCoordinate2DIsValid(location)) {
        
        [_mapView setCenterCoordinate:location animated:YES];
    }
}
-(void)segBtnClicked:(UIButton *)sender{
    
    if ([sender isEqual:_btn[0]]) {
        
        if ([self decreaseCurrentCourse]) {
            
            [self clear];
            [self updateCourseUI];
            [self presentCurrentCourse];
        }
    }else if ([sender isEqual:_btn[1]]){
        
        if ([self increaseCurrentCourse]) {
            
            [self clear];
            [self updateCourseUI];
            [self presentCurrentCourse];
        };
    }else{
        
        [self gotoDetailForRoute:_route type:_searchType];
    }
    
}
#pragma mark- 进入搜索页面
-(void)btnClicked:(UIButton *)sender{
    
    overFlage = NO;
    MapSearchView *t = [MapSearchView alloc];
    if (sender.tag == 121) {
        //地图按钮按下
        t.type = 0;
    }else if (sender.tag == 122){
        //集结点按钮按下
        t.type = 1;
    }
    t.delegate = self;
    [[t initWithFrame:self.bounds] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}

- (void)byBus:(UIButton *)button{
    
   // [self performSelector:@selector(ChangeHioghLight:) withObject:button afterDelay:0.0];
    //公交路线
    [self searchNavi:AMapSearchType_NaviBus];
    
}
- (void)byFoot:(UIButton *)button{
    
   // [self performSelector:@selector(ChangeHioghLight:) withObject:button afterDelay:0.0];
    //步行路线
    [self searchNavi:AMapSearchType_NaviWalking];
}
#pragma mark- 乘车 或者 公交 状态切换
-(void)ChangeHioghLight:(UIButton*)s{
    
    s.highlighted = YES;
    s.userInteractionEnabled = NO;
    for (int i = 123 ; i <= 124; i++) {
        UIButton*t = (UIButton*)[self viewWithTag:i];
        if (![t isEqual:s]) {
            t.highlighted = NO;
            t.enabled = YES;
            t.userInteractionEnabled = YES;
        }
    }
}

#pragma mark- 地图上添加标注点
- (void)addAction
{
    //34.2226694111,108.9467158763 小寨
    //34.2700847438,108.9551404490 体育场
    //34.2343828961,108.8761229168 西辛庄
    UILabel *label;
    NSInteger flage = 0;
    for (id obj in _btnArray) {
        
        if ([obj isKindOfClass:[MapButton class]]) {
            
            MapButton *btn = obj;
            NSArray *tmpArray = [btn.address componentsSeparatedByString:@"|"];
            if (tmpArray && tmpArray.count >= 2) {
                
                MAPointAnnotation *annotation = [[[MAPointAnnotation alloc] init] autorelease];
                annotation.coordinate = CLLocationCoordinate2DMake([tmpArray[1] floatValue],[tmpArray[0] floatValue]);
                annotation.title    = btn.title;
                [_gatherPointArray addObject:annotation];
            }
            if (flage == 0) {
                label = (UILabel *)[_overView viewWithTag:227];
                label.text = btn.title;
            }
            flage++;
        }else if([obj isKindOfClass:[UIButton class]]){
            
            UIButton *btn = obj;
            NSArray *tmpArray = [btn.titleLabel.text componentsSeparatedByString:@"|"];
            if (tmpArray && tmpArray.count >= 3) {
                
                MAPointAnnotation *annotation = [[[MAPointAnnotation alloc] init] autorelease];
                annotation.coordinate = CLLocationCoordinate2DMake([tmpArray[2] floatValue],[tmpArray[1] floatValue]);
                annotation.title    = tmpArray[0];
                [_gatherPointArray addObject:annotation];
            }
            if (flage == 0) {
                label = (UILabel *)[_overView viewWithTag:227];
                label.text = tmpArray[0];
                UIButton *btn = (UIButton *)[_overView viewWithTag:122];
                btn.userInteractionEnabled = NO;
            }
            flage++;
        }
    }
    
    self.currentPointAnnotation = _gatherPointArray[0];
    [self.mapView addAnnotations:_gatherPointArray];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        NSString *customReuseIndetifier = @"gatherAnnotation";
        GatherAnnotationView *annotationView = (GatherAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[[GatherAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier] autorelease];
            // must set to NO, so we can show the custom callout view.
        }
        
        annotationView.draggable = YES;
        annotationView.calloutOffset = CGPointMake(0, -5);
        annotationView.canShowCallout = YES;
        
        annotationView.titleLabel.backgroundColor = [Utility hexStringToColor:@"#797979"];
        if (annotation.coordinate.latitude == ((MAPointAnnotation *)_gatherPointArray[0]).coordinate.latitude &&
            annotation.coordinate.longitude == ((MAPointAnnotation *)_gatherPointArray[0]).coordinate.longitude) {
            
            annotationView.titleLabel.backgroundColor = [Utility hexStringToColor:@"#118bfe"];
            
        }
        
        return annotationView;
    }else if([annotation isKindOfClass:[GeocodeAnnotation class]]){
        
        NSString *customReuseIndetifier = @"geocodeAnnotation";
        MAAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier] autorelease];
            annotationView.image = [Utility getImageByName:@"startPoint.png"];
        }
        annotationView.canShowCallout = YES;
        
        return annotationView;

    }
    
    return nil;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline] autorelease];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor orangeColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[[MAPolylineRenderer alloc] initWithPolyline:overlay] autorelease];
        
        polylineRenderer.lineWidth   = 4.f;
        
        if ([overlay isEqual:gatherPolyline]) {
            
            polylineRenderer.strokeColor = [Utility hexStringToColor:@"#1665af"];
        }else{
            polylineRenderer.strokeColor = [UIColor purpleColor];
        }
        
        return polylineRenderer;
    }
    
    return nil;
}
#pragma mark- mapViewDelegate
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
   // [self handleSwipe:_overView.gestureRecognizers[0]];
}


#pragma mark - Initialization

- (void)initOverlays
{
    
    CLLocationCoordinate2D polylineCoords[100];//最多一百个点儿
    int flage = 0;
    for (MAPointAnnotation *annotation in _gatherPointArray) {
        
        polylineCoords[flage++] = annotation.coordinate;
    }
    
    gatherPolyline = [MAPolyline polylineWithCoordinates:polylineCoords count:_gatherPointArray.count];
    [self.mapView addOverlay:gatherPolyline];
}

#pragma mark 导航搜索
- (void)searchNavi:(AMapSearchType)searchType{
    
    [self showLoadMsg:@"正在搜索相关线路..."];
    //清除搜索所生成的覆盖物
    for (id<MAOverlay> overlay in self.mapView.overlays) {
        
        if (![overlay isEqual:gatherPolyline]) {
            [self.mapView removeOverlay:overlay];
        }
    }
    
    AMapNavigationSearchRequest *naviRequest = [[[AMapNavigationSearchRequest alloc] init] autorelease];
    naviRequest.searchType = searchType;
    self.searchType = searchType;
    naviRequest.requireExtension = YES;
    if (_curGeoCodeAnnotation == nil) {
         naviRequest.origin =  [AMapGeoPoint locationWithLatitude:[LhLocationModel shareLocationModel].curUserLocation.latitude longitude:[LhLocationModel shareLocationModel].curUserLocation.longitude];
    }else{
         naviRequest.origin =  [AMapGeoPoint locationWithLatitude:_curGeoCodeAnnotation.coordinate.latitude longitude:_curGeoCodeAnnotation.coordinate.longitude];
    }
   
    
//    __block MAPointAnnotation *nearAnnoation;//离用户最近的集结点
//    __block CGFloat distance = MAXFLOAT;
//    CGPoint userPoint = [_mapView convertCoordinate:[LhLocationModel shareLocationModel].curUserLocation toPointToView:self];
//    [_gatherPointArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        MAPointAnnotation *annotation = obj;
//        CGPoint tmpPoint = [_mapView convertCoordinate:annotation.coordinate toPointToView:self];
//        //一个数的平方 powf 开放 sqrt
//        CGFloat tmpDistance = sqrtf((powf((tmpPoint.x-userPoint.x), 2)  + powf((tmpPoint.y-userPoint.y), 2)));
//        if (distance > tmpDistance) {
//            nearAnnoation = annotation;
//            distance = tmpDistance;
//        }
//    }];
//    MAPointAnnotation *annotation = nearAnnoation;
    self.currentPointAnnotation = _gatherPointArray[_selectEndBtnIndex];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:_currentPointAnnotation.coordinate.latitude longitude:_currentPointAnnotation.coordinate.longitude];
    
#warning navi的city属性不能为空，否则会crash
    NSString *city = defaultCity;
    if ([LhLocationModel shareLocationModel].city != nil) {
        city = [LhLocationModel shareLocationModel].city;
    }
    if (searchType != AMapSearchType_NaviWalking) {
        naviRequest.city = city;
    }
    [self.search AMapNavigationSearch: naviRequest];
}
#pragma mark - AMapSearchDelegate

/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil || response.count == 0)
    {
        [self dismissLoadMsgWithError:@"未能找到相关的线路"];
//        [Utility delay:1.0 action:^{
//            for (int i = 123 ; i <= 124; i++) {//按钮状态恢复正常
//                UIButton*t = (UIButton*)[self viewWithTag:i];
//                t.userInteractionEnabled = YES;
//                t.highlighted = NO;
//            }
//        }];
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    [self presentCurrentCourse];
    [self dismissLoadMsg];
    MapViewShowLinesView *t = [[[MapViewShowLinesView alloc] initWithFrame:self.bounds] autorelease];
    t.controller = self.controller;
    t.type = self.searchType == AMapSearchType_NaviWalking ? 1:0;
    t.mapView = self;
    t.route = self.route;
    [self.controller push:t atindex:6];
}


// 通知查询成功或失败的回调函数
#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
    [self dismissLoadMsgWithError:@"搜索失败"];
//    [Utility delay:1.0 action:^{
//        for (int i = 123 ; i <= 124; i++) {//按钮状态恢复正常
//            UIButton*t = (UIButton*)[self viewWithTag:i];
//            t.userInteractionEnabled = YES;
//            t.highlighted = NO;
//        }
//    }];
    
}

#pragma mark- 搜索提示
/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key{
    
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[[AMapInputTipsSearchRequest alloc] init] autorelease];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}
#pragma mark- 搜索提示回调
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    [self.tips removeAllObjects];
    AMapTip *tip = [AMapTip tipWithName:@"我的位置" adcode:nil district:nil];//用来表示定位位置
    [self.tips addObject:tip];
    [self.tips addObjectsFromArray:response.tips];
    [ObserversNotice TellViewNotice:YGLYNoticeTypeMapTipSearchDidComplete];
}

#pragma mark  监测到改变
-(void)receiveNotifications:(NSInteger)type{
    
    if (type == YGLYNoticeTypeMapStartOrEndLocationDidChange) {
        
//        UIButton *button = (UIButton *)[self viewWithTag:123];//公交
//        UIButton *button1 = (UIButton *)[self viewWithTag:124];//步行
//        if (button.highlighted) {
//            //
//            [self byBus:button];
//        }else if (button1.highlighted){
//            //
//            [self byFoot:button1];
//        }
    }
}

#pragma mark 重新设置curAMapTip的set方法
-(void)setCurSelectTip:(AMapTip *)curSelectTip{
    
    if (curSelectTip.adcode) {//表示是当前未定位位置，需要地理位置解析
        
        AMapGeocodeSearchRequest *searchRequest = [[[AMapGeocodeSearchRequest alloc] init] autorelease];
            searchRequest.searchType = AMapSearchType_Geocode;
        searchRequest.address = [NSString stringWithFormat:@"%@%@",curSelectTip.district,curSelectTip.name];
        searchRequest.city = @[curSelectTip.adcode];
        [self.search AMapGeocodeSearch:searchRequest];
    }else{
        
        [_mapView removeAnnotation:_curGeoCodeAnnotation];
        self.curGeoCodeAnnotation = nil;
    }
    _curSelectTip = curSelectTip;
}

#pragma mark- 地理编码搜索成功回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if (_curSelectTip.adcode == request.city[0] && response.count > 0) {
        
        self.curGeoCodeAnnotation = [[[GeocodeAnnotation alloc] initWithGeocode:response.geocodes[0]] autorelease];
    }
}

#pragma mark 重新设置curGeoCode的set方法
- (void)setCurGeoCodeAnnotation:(GeocodeAnnotation *)curGeoCodeAnnotation{
    
    [_mapView removeAnnotation:_curGeoCodeAnnotation];
    _curGeoCodeAnnotation = curGeoCodeAnnotation;
    
    //添加标注
    [_mapView addAnnotation:curGeoCodeAnnotation];
    
    [self receiveNotifications:YGLYNoticeTypeMapStartOrEndLocationDidChange];
}

#pragma mark mapViewDelegate
-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    EBLog(@"%@",[error description]);
}

#pragma mark- touchs end
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint selfPoint = [touch locationInView:self];
    CGPoint point = [_overView convertPoint:selfPoint fromView:self];
    if (CGRectContainsPoint([_overView viewWithTag:226].frame, point)) {
        
        UIButton *button = (UIButton *)[_overView viewWithTag:121];
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else if (CGRectContainsPoint([_overView viewWithTag:227].frame, point)) {
        
        UIButton *button = (UIButton *)[_overView viewWithTag:122];
        if (button.userInteractionEnabled) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark- pop动画
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}

@end
