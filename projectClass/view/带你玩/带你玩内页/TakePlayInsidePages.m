//
//  PreferentialInsidePages.m
//  yglyProject
//
//  Created by 枫 on 14-10-15.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "TakePlayInsidePages.h"
#import "LeaderAndFriendCell.h"
#import "LeaderAndFriendFlowLayout.h"
#import "HBJUILabel.h"
#import "MapButton.h"
#import "MapView.h"
#import "MainViewController.h"
#import "LineFeaturesView.h"
#import "TraveDetaillView.h"
#import "BookingDetailView.h"
#import "TableHeaderView.h"
#import "LhNoticeMsg.h"
#import "GlobalModel.h"
#import "LoginView.h"

@interface TakePlayInsidePages ()<UICollectionViewDelegateFlowLayout>
{
    TableHeaderView *_headerView;
}
@property(nonatomic,retain)NSString *jianJieUrl;//路线特色点进去后的网页链接
@property(nonatomic,assign)UICollectionView *togetherCollectionView;
@end

@implementation TakePlayInsidePages

-(void)loadView:(NSDictionary*)allDict{
    
    [self initScrollViewWithBottomHeight:0];
    
  
    NSDictionary* lhdict= [allDict objectForKey:@"xianlu"];
    self.tell = [lhdict objectForKey:@"tel"];
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:10];
   [dic setObject:[lhdict objectForKey:@"imgurl"] forKey:@"senceUrl"];
    [dic setObject:@"640x250默认图片.png" forKey:@"defaultSence"];
    
    [dic setObject:[lhdict objectForKey:@"tuijian_name"] forKey:@"leftTopText"];
    [dic setObject:[lhdict objectForKey:@"tuijian_color"] forKey:@"leftTopColor"];
    
    [dic setObject:@"景色图黑底衬.png" forKey:@"belloImageName"];
    [self addSenceImageViewWithDic:dic bSpace:0 eSpace:0];
  
    _headerView = [[TableHeaderView alloc] init];
    [_headerView stretchHeaderForTableView:self.scrollView withView:self.scrollView.subviews.lastObject];
    
    [self showUIViewList:@"UIView" index:0 uiview:self.scrollView];
    [self showUILabelList:@"UILabel" index:0 uiview:self.scrollView];
  
    UILabel*t = (UILabel*)[self viewWithTag:411];
    t.text = [lhdict strValue:@"mobile_title" default:@""];
   // CGSize contentSize = [Utility getSizeFormString:t.text maxW:t.width font:t.font];
    
    t = (UILabel*)[self viewWithTag:412];
    t.text = [NSString stringWithFormat:@"￥ %@元/人",[lhdict strValue:@"price" default:@""]];
    
    [self showStrikeThroughLabelList:@"StrikeThroughLabel" index:0 uiview:self.scrollView];
    StrikeThroughLabel*tlab = (StrikeThroughLabel*)[self viewWithTag:911];
    tlab.text = [NSString stringWithFormat:@"￥%@元/人",[lhdict strValue:@"prices" default:@""]];
    
    [self showButtonList:@"Buttons" index:0 uiview:self.scrollView];
    [self showColorButtonList:@"ColorButtons" index:0 uiview:self.scrollView];
    //设置colorbutton的textLabel
    UIButton *button = (UIButton *)[self viewWithTag:211];
    
    NSInteger baoming_type = [lhdict intValue:@"baoming_type" default:3];
    if (baoming_type == 2) {//名额已完
        [button setTitle:@"名额已完" forState:UIControlStateNormal];
        [(ACPButton*)button setFlatStyle:[Utility hexStringToColor:@"#9c9c9c"] andHighlightedColor:[Utility hexStringToColor:@"#9c9c9c"]];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.userInteractionEnabled = NO;
    }else if (baoming_type == 3){//
        [button setTitle:@"已经过期" forState:UIControlStateNormal];
        [(ACPButton*)button setFlatStyle:[Utility hexStringToColor:@"#9c9c9c"] andHighlightedColor:[Utility hexStringToColor:@"#9c9c9c"]];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.userInteractionEnabled = NO;
    }
    
    CGSize size = [button.titleLabel splitToLine:2];
    CGFloat top = (button.size.height - size.height) / 2.0;
    CGFloat left = (button.size.width - size.width) / 2.0;
    button.titleEdgeInsets = UIEdgeInsetsMake(top, left-5, top, left-5);
    button.titleLabel.frame = button.bounds;
    button.titleLabel.numberOfLines = 2;
    
    UIView *view;
    //-----动态显示集结地－－－－－－－feng--------------------------------
    [self showUIViewList:@"UIView" index:1 uiview:self.scrollView];
    view = [self.scrollView viewWithTag:621];
    [self showUILabelList:@"UILabel" index:1 uiview:view];
    UILabel *label = (UILabel *)[view viewWithTag:421];
    CGSize contentSize = [Utility getSizeFormString:label.text maxW:70 font:label.font];
    CGRect lableRect = label.frame;
    lableRect.size.width = contentSize.width;
    label.frame = lableRect;
    
    CGFloat viewH = view.size.height;
    CGFloat pointY;
    int LineNumber = 0;
    CGFloat pointX = CGRectGetMaxX(label.frame);
    CGFloat tmpMaxX = pointX;
    NSArray*jhd = [lhdict objectForKey:@"jhd"];
    for (int j = 0; j <  jhd.count;j++) {
        
        NSDictionary * dict = @{@"imageName":@"地图进入默认.png",@"selectedImageName":@"地图进入按下.png",@"title":[jhd[j] objectForKey:@"address"],@"content":[jhd[j] objectForKey:@"content"]};
        MapButton *mapBtn = [MapButton createMapButtonWithDict:dict point:CGPointMake(0,0)];
        
        tmpMaxX += mapBtn.size.width + YGLY_VIEW_FLOAT(10);
        if (tmpMaxX < self.size.width) {
            
            pointY = (viewH - mapBtn.size.height)/2.0 + viewH * LineNumber;
            mapBtn.point = CGPointMake(tmpMaxX - (mapBtn.size.width + YGLY_VIEW_FLOAT(10)), pointY);
            [view addSubview:mapBtn];
            [mapBtn addTarget:self action:@selector(gotoMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            LineNumber++;
            CGSize size = view.size;
            size.height += viewH;
            view.size = size;
            tmpMaxX = pointX-2;
            j--;
        }
        
    }
    //-----动态显示集结地－－－－－－－feng--------------------------------
    CGPoint point = CGPointMake(0, CGRectGetMaxY(view.frame));
    [self showUIViewList:@"UIView" index:2 uiview:self.scrollView];
    view = [self.scrollView viewWithTag:631];
    view.point = point;
    [view addSubview:[self.scrollView viewWithTag:632]];
    [view addSubview:[self.scrollView viewWithTag:633]];
    [view addSubview:[self.scrollView viewWithTag:634]];
    [self showUILabelList:@"UILabel" index:2 uiview:view];
  
    t = (UILabel*)[self viewWithTag:431];
    NSArray*mdd = [lhdict objectForKey:@"mdd"];
    if (mdd && mdd.count) {
        t.text = [NSString stringWithFormat:@"目的地: %@",[mdd[0] strValue:@"address" default:@""]];
    }
    
    t = (UILabel*)[self viewWithTag:432];
    if (mdd && mdd.count) {
        t.text = [NSString stringWithFormat:@"集结时间: %@",[Utility getDateBytims:[lhdict intValue:@"time"] key:@"MM-dd HH:mm" style:NSDateFormatterNoStyle]];
    }
    
    //设置scrollView的contentSize
    view = [self viewWithTag:631];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(view.frame));
    //路线特色
    NSDictionary *headDic = [NSDictionary dictionaryWithObjects:@[@"#d85525",
                                                                  @"路线特色",
                                                                  @"jiantou.png"]
                             
                                                        forKeys:@[  @"bgColor",
                                                                    @"labelText",
                                                                    @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:30 eSpace:20];
    [dic removeAllObjects];
    [dic setObject:[lhdict strValueDeleteReturn:@"jianjie"] forKey:@"text"];
    [dic setObject:[lhdict strValue:@"imgurl" default:@""] forKey:@"imgUrl"];
    [dic setObject:@"600x250默认图片.png" forKey:@"defaultImage"];
    self.jianJieUrl = [lhdict strValue:@"jianjie_url" default:@""];
    [self addTextAndPhotoViewWithDic:dic bSpace:0 eSpace:20 addGesture:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLineFeaturesView)] autorelease]];
  
    NSDictionary*daysDic = [allDict objectForKey:@"xingcheng"];
    if (daysDic.allKeys.count > 0 && ![daysDic.allKeys containsObject:@"jj"]) {
        //行程说明
        headDic = [NSDictionary dictionaryWithObjects:@[@"#30629a",
                                                        @"行程说明",
                                                        @"交通.png"]
                   
                                              forKeys:@[  @"bgColor",
                                                          @"labelText",
                                                          @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:10 eSpace:20];
    }
    dayNum = 0;
    for (int i = 1; i <= 3; i++) {
        
        if ([daysDic objectForKey:[NSString stringWithFormat:@"%d",i]]) {
            NSDictionary*day1 = [daysDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            ;
            [dic removeAllObjects];
            [dic setObject:[NSString stringWithFormat:@"D%d.png",i] forKey:@"leftImage"];
            if ([day1 objectForKey:@"shuoming"]) {
                [dic setObject:[[day1 objectForKey:@"shuoming"]strValueDeleteReturn:@"content"] forKey:@"headText"];
            
            }
            
            
            NSMutableDictionary *deta =  [NSMutableDictionary dictionaryWithCapacity:10];
            NSArray *keys = [day1 allKeys];
            for (NSString*key in keys) {
                if (![key isEqual:@"shuoming"]) {
                    [deta setObject:[[day1 objectForKey:key]strValueDeleteReturn:@"content"] forKey:key];
                }
            }
            [dic setObject:deta forKey:@"bodyDict"];
            [self addTravelingViewWithDic:dic bSpace:0 eSpace:0];
            dayNum++;
        }
        
    }

    [dic removeAllObjects];
    NSDictionary *yudingDict = [lhdict objectForKey:@"yuding"];
    NSArray *keys = [yudingDict allKeys];
    if (keys.count > 0) {
        //预订须知
        headDic = [NSDictionary dictionaryWithObjects:@[@"#e19bb6",
                                                        @"预订须知",
                                                        @"预定须知.png"]
                   
                                              forKeys:@[  @"bgColor",
                                                          @"labelText",
                                                          @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:10 eSpace:20];
    }
    for (NSString*key in keys) {
        [dic setObject:[yudingDict strValueDeleteReturn:key] forKey:key];
    }
    
    [self addBodyViewWithDic:dic style:1 bSpace:0 eSpace:20];

    if(self.playArray.count){
        headDic = [NSDictionary dictionaryWithObjects:@[@"#a5c8ec",@"一起玩",@"一起玩.png"]forKeys:@[ @"bgColor",@"labelText",@"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
        
        self.togetherCollectionView = [self addCollectionViewWithReuseIdentifier:@"FriendsCell" collectionViewFlowLayout:[[[LeaderAndFriendFlowLayout alloc] init] autorelease] collectionViewCellClass:[LeaderAndFriendCell class] bSpace:0 eSpace:20];
        _togetherCollectionView.scrollEnabled = NO;
        [Utility delay:0.02 action:^{
            [self setCollectionViewCenter:_togetherCollectionView];
        }];

    }
  
    self.xl_tuijian = [allDict objectForKey:@"xl_tuijian"];
    if (_xl_tuijian.count > 0) {
       headDic = [NSDictionary dictionaryWithObjects:@[@"#d85525",
                                                        @"路线推荐",
                                                        @""]
                   
                                              forKeys:@[  @"bgColor",
                                                          @"labelText",
                                                          @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
    }
    for (int i = 0 ; i < _xl_tuijian.count; i++) {
        [dic removeAllObjects];
        [dic setObject:[_xl_tuijian[i] strValue:@"price" default:@""] forKey:@"routePrice"];
        [dic setObject:[_xl_tuijian[i] strValue:@"title" default:@""] forKey:@"routeLine"];
        [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"tag"];
        [dic setObject:@"routeBtnClicked:" forKey:@"method"];
        [self addRouteRecommendationViewWithDic:dic bSpace:0 eSpace:0];
    }
    
}


-(void)showView{
    [super showView];
    [[MainViewController sharedViewController] showLoad:self];
    [[VIewDadaGet sharedGameModel] TakePlayDataInf:self.tag  delegate:self];
}
#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    self.playArray = [[dict objectForKey:@"yiqiwan"]objectForKey:@"yqw"];
    nowPlayNum = [[dict objectForKey:@"yiqiwan"] intValue:@"count"];
    allPlayNum = [[dict objectForKey:@"xianlu"] intValue:@"kucun"];
   
    [self loadView:dict];
    if (self.tell.length > 5) {
        UIView*t = [self viewWithTag:9889801];
        [t fadeIn];
    }
    
    [[MainViewController sharedViewController] endLoad];
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance]ShowMsg:@"数据加载失败"];
}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.playArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LeaderAndFriendCell *cell = nil;
    if ([collectionView isEqual:_togetherCollectionView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCell" forIndexPath:indexPath];
        [cell.button setNewUrl:[[self.playArray objectAtIndex:indexPath.row]objectForKey:@"app_pic"] defauleImage:@"头像默认.png"];
        cell.button.tag = [[self.playArray objectAtIndex:indexPath.row]intValue:@"userid"];
        cell.title = [[self.playArray objectAtIndex:indexPath.row]objectForKey:@"username"];
        [cell.button addTarget:self action:@selector(clickPlayer:) forControlEvents:UIControlEventTouchUpInside];
        //        cell.button.userInteractionEnabled = YES;//按钮点击控制
    }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}
#pragma mark 点击用户
-(void)clickPlayer:(UIButton*)sender{
    EBLog(@"点击用户：%zi",sender.tag);
}
#pragma mark 预定详情
- (void)joinBtnClicked:(id)sender{
    
    if (![GlobalModel isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        [alert release];
        return;
    }
    
    if ([[GlobalModel sharedGameModel].selfUserProfile intValue:@"usertype"] == 1) {//用户
        
        BookingDetailView*t = (BookingDetailView*)[Utility getViewToId:@"BookingDetailView" tag:self.tag rect:self.bounds];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }else{
        [Utility alertMsg:@"提醒" msg:@"商户不可操作此项！"];
    }
}
#pragma mark-alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t1 = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t1.controller = self.controller;
        [t1.controller push:t1 atindex:6];
    }
}
#pragma mark-打电话
- (void)callBtnClicked:(id)sender{
    [Utility callPhone:self.tell];
}

#pragma mark- 地图
- (void)gotoMapview{
    EBLog(@"---mapView----");
}
- (void)mapBtnClicked:(id)sender{
    
    MapView*t = [[[MapView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}

#pragma mark 进入特色详情页
- (void)gotoLineFeaturesView{
    
    
    LineFeaturesView*t = [LineFeaturesView alloc];
    t.urlString = self.jianJieUrl;
    [[t initWithFrame:self.bounds] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}
#pragma mark 进入行程详情页
-(void)gotoTraveDetail:(id)sender{
    NSInteger day = ((UIButton *)sender).tag/10000;
    TraveDetaillView*t = (TraveDetaillView*)[Utility getViewToId:@"TraveDetaillView" tag:self.tag rect:self.bounds];
    [t setDayNum:dayNum dayIndx:day];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}
#pragma mark 特色推荐
-(void)routeBtnClicked:(UIButton*)sender{
    
    EBLog(@"特色推荐:%zi",sender.tag);
    NSDictionary *dict = self.xl_tuijian[sender.tag];
    TakePlayInsidePages*t = (TakePlayInsidePages*)[Utility getViewToId:@"TakePlayInsidePages" tag:[dict intValue:@"id" default:0] rect:self.bounds];
    t.controller = self.controller;
    [self.controller replace:t atindex:6];
}
#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}
#pragma mark- replace动画
-(CATransition*)getReplace{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionMoveIn Subtype:kCATransitionFromRight];
}
-(void)dealloc{
    self.playArray = nil;
    self.tell = nil;
    self.jianJieUrl = nil;
    self.xl_tuijian = nil;
    if (_headerView) {
        [_headerView release];_headerView = nil;
    }
    [super dealloc];
}
@end
