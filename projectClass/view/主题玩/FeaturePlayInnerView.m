//
//  FeaturePlayInnerView.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "FeaturePlayInnerView.h"
#import "CZYGCell.h"
#import "SenceImageView.h"
#import "SenceHeadView.h"
#import "ActivityFlowLayout.h"
#import "ActivityCell.h"
#import "TableHeaderView.h"
#import "MainViewController.h"
#import "GlobalModel.h"
#import "HBJScrollView+Extenstion.h"
#import "TakePlayInsidePages.h"
#import "LoginView.h"
@interface FeaturePlayInnerView ()
{
    TableHeaderView *_headerView;
    UIWebView *webView;
}
@end

@implementation FeaturePlayInnerView

#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    if ([apiKey isEqualToString:app_zhuti_yxtype_add]) {
        if ([dict intValue:@"xh_type"] == 1) {
            self.flagXiangQu = YES;
            UILabel*lab = (UILabel*)[self viewWithTag:90412];
            lab.text = [NSString stringWithFormat:@"想去: %@",[dict objectForKey:@"xh_num"]];
            
        }
        if ([dict intValue:@"xh_type"] == 2){
            UILabel*lab = (UILabel*)[self viewWithTag:90411];
            lab.text = [NSString stringWithFormat:@"去过: %@",[dict objectForKey:@"xh_num"]];
            self.flagQuGuo = YES;
        }
    }else{
        [self loadView:dict];
        [[MainViewController sharedViewController] endLoad];
    }
    
    
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    if ([apiKey isEqualToString:app_zhuti_yxtype_add]) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"失败"];
    }else{
        [[MainViewController sharedViewController] endLoad];
        [[LhNoticeMsg sharedInstance]ShowMsg:@"数据加载失败"];
    }
    
    
}

-(void)dealloc{
    if (_headerView) {
        [_headerView release];_headerView = nil;
    }
    [super dealloc];
}
-(void)loadView:(NSDictionary*)allDict{
    NSDictionary*info = [allDict objectForKey:@"info"];
    NSMutableDictionary*tmpDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [tmpDict setObject:@"640x250默认图片.png" forKey:@"defaultSence"];
    [tmpDict setObject:[info objectForKey:@"mobile_img"] forKey:@"senceUrl"];
    [tmpDict setObject:@"景色图黑底衬.png" forKey:@"belloImageName"];
    [tmpDict setObject:[info objectForKey:@"mobile_title"] forKey:@"bellowTitle"];
    [tmpDict setObject:@"1" forKey:@"bellowLabelStyle"];
    [self addSenceImageViewWithDic:tmpDict bSpace:0 eSpace:0];
//    _headerView = [[TableHeaderView alloc] init];
//    [_headerView stretchHeaderForTableView:self.scrollView withView:self.scrollView.subviews.lastObject];
    
    [self showUIViewList:@"UIView" index:0 uiview:self.scrollView];
    [self showButtonList:@"Buttons" index:0 uiview:self.scrollView];
    [self showUILabelList:@"UILabel" index:0 uiview:self.scrollView];
    UIView *view = [self viewWithTag:611];//用来判断是去过 还是想去
    [view addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotap:)] autorelease]];
    
    UILabel*lab = (UILabel*)[self viewWithTag:90412];
    lab.text = [NSString stringWithFormat:@"想去: %@",[info objectForKey:@"xq"]];
    lab = (UILabel*)[self viewWithTag:90411];
    lab.text = [NSString stringWithFormat:@"去过: %@",[info objectForKey:@"qu"]];
    if ([info intValue:@"xq_type"] == 1) {
        self.flagXiangQu = YES;
        
    }
    if ([info intValue:@"qu_type"] == 1){
        self.flagQuGuo = YES;
    }
    
    
    //设置scrollView的contentSize
    view = [self viewWithTag:611];
    
    //添加头部view
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(view.frame))] autorelease];
    
   __block UIView *stretchView ;//标记被拉伸view
    //将view移到和headerView上
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[SenceImageView class]]) {
            stretchView = obj;
        }
        [headerView addSubview:obj];
    }];
    //初始化一个webView
    webView = [[[UIWebView alloc] initWithFrame:self.scrollView.bounds] autorelease];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:[info strValue:@"jianjie_url" default:@""]];
   // NSURL *url = [NSURL URLWithString: @"http://sz.user.qzone.qq.com/363280316/infocenter?qz_referer=qqtips&msg_id=107805&ptsig=5UC-uknjG*5*pAzzCBszqCQvlNc6b*k-NKO6xVYOgx0_"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.scrollView addSubview:webView];
    [webView.scrollView addHeadView:headerView];
    NSLog(@"url==>%@",url);
    
    
    
    //设置被拉伸的view
    _headerView = [[TableHeaderView alloc] init];
    [_headerView stretchHeaderForTableView:webView.scrollView  withView:stretchView];
    
    //添加尾部视图
     UIView *footerView = [[[UIView alloc] init] autorelease];
    footerView.backgroundColor = [UIColor whiteColor];
    self.xl_tuijian = [allDict objectForKey:@"xl_tuijian"];
        if (self.xl_tuijian.count > 0) {
            NSDictionary *headDic = [NSDictionary dictionaryWithObjects:@[@"#a5c8ec",
                                                            @"线路推荐",
                                                            @""]
    
                                                  forKeys:@[  @"bgColor",
                                                              @"labelText",
                                                              @"imageName"]];
            SenceHeadView *senceHeaderView = [SenceHeadView createSenceHeadViewWithDict:headDic frame:CGRectMake(0, 10, 125, 24.5)];
            [footerView addSubview:senceHeaderView];
        }
        [tmpDict removeAllObjects];
    
        [tmpDict setObject:@"routeBtnClicked:" forKey:@"method"];
        int i = 0;
        for (NSDictionary*dict in self.xl_tuijian) {
            [tmpDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"tag"];
            [tmpDict setObject:[dict strValue:@"mobile_title" default:@""] forKey:@"routeLine"];
            [tmpDict setObject:[dict strValue:@"price" default:@""] forKey:@"routePrice"];
            RouteRecommendationView *routeModel = [self addRouteRecommendationViewWithDic:tmpDict bSpace:0 eSpace:0];
            CGRect rect =  routeModel.frame;
            rect.origin.y = CGRectGetHeight(rect)*i+24.5+20;
            routeModel.frame = rect;
            [self.viewArray removeObject:routeModel];
            [footerView addSubview:routeModel];
            i++;
            
            rect = CGRectMake(0, 0, 320, CGRectGetMaxY(rect));
            footerView.frame = rect;
        }
    
    [webView.scrollView addFootView:footerView];
    
    /*
//    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(view.frame) + YGLY_VIEW_FLOAT(20));
//    
//    NSDictionary *headDic = [NSDictionary dictionaryWithObjects:@[@"#e19bb6",
//                                                                  @"行程攻略",
//                                                                  @""]
//                             
//                                                        forKeys:@[  @"bgColor",
//                                                                    @"labelText",
//                                                                    @"imageName"]];
//    [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:0];
//    [tmpDict removeAllObjects];
//    [tmpDict setObject:[info strValueDeleteReturn:@"jianjie"] forKey:@"text"];
//    [tmpDict setObject:[info objectForKey:@"mobile_img"] forKey:@"imgUrl"];
//    [tmpDict setObject:@"640x250默认图片.png" forKey:@"defaultImage"];
//    
//    [self addTextAndPhotoViewWithDic:tmpDict bgColor:[Utility hexStringToColor:@"#ececec"] bSpace:20 eSpace:20];
//    
//    NSDictionary *leftImageDict = @{@"3450":@"推荐景点.png",
//                                    @"3451":@"食物.png",
//                                    @"3452":@"住宿.png",
//                                    @"3453":@"交通工具.png",
//                                    @"3454":@"购物.png"};
//    info = [[allDict objectForKey:@"xingcheng"]objectForKey:@"xcxq"];
//    [tmpDict removeAllObjects];
//    for (NSDictionary*dict in info) {
//        [tmpDict setObject:leftImageDict[dict[@"parentid"]] forKey:@"leftTopImage"];
//        
//        [tmpDict setObject:@{[dict objectForKey:@"name"]:[dict objectForKey:@"content"]}forKey:@"bodyDict"];
//        [self addCZYGCellWithDic:tmpDict bSpace:0 eSpace:0];
//    }
//    
//    self.xl_tuijian = [allDict objectForKey:@"xl_tuijian"];
//    if (self.xl_tuijian.count > 0) {
//        headDic = [NSDictionary dictionaryWithObjects:@[@"#a5c8ec",
//                                                        @"线路推荐",
//                                                        @""]
//                   
//                                              forKeys:@[  @"bgColor",
//                                                          @"labelText",
//                                                          @"imageName"]];
//        [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
//    }
//    [tmpDict removeAllObjects];
//    
//    [tmpDict setObject:@"routeBtnClicked:" forKey:@"method"];
//    int i = 0;
//    for (NSDictionary*dict in self.xl_tuijian) {
//        [tmpDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"tag"];
//        [tmpDict setObject:[dict strValue:@"mobile_title" default:@""] forKey:@"routeLine"];
//        [tmpDict setObject:[dict strValue:@"price" default:@""] forKey:@"routePrice"];
//        [self addRouteRecommendationViewWithDic:tmpDict bSpace:0 eSpace:0];
//        i++;
//    }
//    
//    self.flagQuGuo = [[allDict objectForKey:@"info"]intValue:@"qu_type"];
//    self.flagXiangQu = [[allDict objectForKey:@"info"]intValue:@"xq_type"];
   */
}

-(void)setFlagQuGuo:(BOOL)tflagQuGuo{
    _flagQuGuo = tflagQuGuo;
    if (tflagQuGuo) {
        UIButton*t = (UIButton*)[self viewWithTag:60711];
 
        t.userInteractionEnabled = NO;
        UIImage *image = [Utility getImageByName:@"去过按下.png"];
        [t setImage:image forState:UIControlStateNormal];
    }
}

-(void)setFlagXiangQu:(BOOL)tflagXiangQu{
    _flagXiangQu = tflagXiangQu;
    if (tflagXiangQu) {
        UIButton*t = (UIButton*)[self viewWithTag:60712];
        t.userInteractionEnabled = NO;
        UIImage *image = [Utility getImageByName:@"想去按下.png"];
        [t setImage:image forState:UIControlStateNormal];
    }
}
-(void)showView{
    [super showView];
    [self initScrollViewWithBottomHeight:0];
    [[VIewDadaGet sharedGameModel]ZhuTiInfo:self.tag catid:self.selfCatid delegate:self];
    [[MainViewController sharedViewController] showLoad:self];
}




#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}

#pragma mark 特色推荐
-(void)routeBtnClicked:(UIButton*)sender{
    
    EBLog(@"特色推荐:%zi",sender.tag);
    NSDictionary *dict = self.xl_tuijian[sender.tag];
    TakePlayInsidePages*t = (TakePlayInsidePages*)[Utility getViewToId:@"TakePlayInsidePages" tag:[dict intValue:@"id" default:0] rect:self.bounds];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}

#pragma mark-去过
-(void)beenBtnClicked:(id)sender{
    
    if ([GlobalModel isLogin]) {
        if (!self.flagQuGuo) {
            [[VIewDadaGet sharedGameModel]ZhuTiYxtypeAdd:self.tag catid:self.selfCatid yxtype:2 delegate:self];
            [[LhNoticeMsg sharedInstance] ShowMsg:@"与服务器通信中..."];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [t.controller push:t atindex:6];
    }
}
#pragma mark-想去
-(void)wantGoBtnClicked:(id)sender{
    if ([GlobalModel isLogin]) {
        if (!self.flagXiangQu) {
            [[VIewDadaGet sharedGameModel]ZhuTiYxtypeAdd:self.tag catid:self.selfCatid yxtype:1 delegate:self];
            [[LhNoticeMsg sharedInstance] ShowMsg:@"与服务器通信中..."];
        }
    }else{
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

    
    
    
}
//#pragma mark- 判断点击的区域 让 去过和想去 按钮的点击范围扩大
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    
//    CGPoint scrolPoint = [webView convertPoint:point fromView:self];
//    scrolPoint.y += (webView.scrollView.contentInset.top + webView.scrollView.contentOffset.y);
//    UIView *view = [self.scrollView viewWithTag:611];
//    UIButton *btnL = (UIButton *)[self.scrollView viewWithTag:60711];
//    CGRect btnLRect = (CGRect){{0,CGRectGetMidY(view.frame)},{160,CGRectGetHeight(view.frame)}};
//    UIButton *btnR = (UIButton *)[self.scrollView viewWithTag:60712];
//    CGRect btnRRect = (CGRect){{160,CGRectGetMidY(view.frame)},{160,CGRectGetHeight(view.frame)}};
//    if (CGRectContainsPoint(btnLRect, scrolPoint)) {
//        return btnL;
//    }else if (CGRectContainsPoint(btnRRect, scrolPoint)) {
//        return btnR;
//    }
//    return [super hitTest:point withEvent:event];
//};
#pragma mark- 判断点击的区域 让 去过和想去 按钮的点击范围扩大
-(void)dotap:(UITapGestureRecognizer *)aTap{
    
    if ([aTap locationInView:aTap.view].x <= CGRectGetWidth(aTap.view.frame)/2.0) {
        
        [self beenBtnClicked:nil];
    }else{
        [self wantGoBtnClicked:nil];
    }
}
@end
