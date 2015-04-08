//
//  OrderDetailsView.m
//  yglyProject
//
//  Created by 枫 on 14-11-14.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "OrderDetailsView.h"
#import "MainViewController.h"
#import "OrderHeaderView.h"
#import "MapButton.h"
#import "TakePlayInsidePages.h"
#import "VIewDadaGet.h"
#import "MainViewController.h"
#import "LhNoticeMsg.h"
#import "LhNSDictionary.h"
#import "YuDingMa.h"

@interface OrderDetailsView ()<OrderHeaderViewDelegate,VIewDadaGetDelegate,YuDingMaDelegate>
{
    NSString *order_sn;//订单编号
}

@end
@implementation OrderDetailsView

-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_dingdan_yonghu_detail]) {
        
        [[MainViewController sharedViewController] endLoad];
        [self loadVieWithDict:dict];
    }else if ([apiKey isEqualToString:app_dingdan_yonghu_yanzheng]){
        
        NSArray *erWeiMaArray = dict[@"info"];
        for (id obj in self.scrollView.subviews) {
            
            if ([obj isKindOfClass:[YuDingMa class]]) {
                
                for (NSDictionary *dict in erWeiMaArray) {
                    
                     YuDingMa *tmp = obj;
                    NSMutableString *aStr = [NSMutableString stringWithString:tmp.passwordLabel.text];
                    [aStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, aStr.length)];
                    NSString *tmpStr = nil;
                    if (aStr.length > 3) {
                         tmpStr = [aStr substringFromIndex:3];
                    }
                    if ([dict[@"status"] intValue] == 1 &&
                        [dict[@"verification_code"] isEqualToString:tmpStr]) {
                       
                        [tmp handleTap];
                        tmp.stateLabel.text = @"已验证";
                        tmp.erWeiMaButton.enabled = NO;
                        tmp.userInteractionEnabled = NO;
                    }
                }
            }
        }
        
    }
    
    //更新订单状态
    [self performSelector:@selector(updateAction) withObject:nil afterDelay:5.0];
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    if ([apiKey isEqualToString:app_dingdan_yonghu_detail]) {
        
        [[MainViewController sharedViewController] endLoad];
        [[LhNoticeMsg sharedInstance] ShowMsg:@"数据加载失败"];
    }else if ([apiKey isEqualToString:app_dingdan_yonghu_yanzheng]){
        
        [self performSelector:@selector(updateAction) withObject:nil afterDelay:5.0];
    }
}

-(void)dealloc{
    
    self.orderId = nil;
    self.productId = nil;
    self.catId = nil;
    [super dealloc];
}
#pragma mark - 用来给页面加载已经获取到的数据
-(void)loadVieWithDict:(NSDictionary *)dict{
    
    [self initScrollViewWithBottomHeight:0];
    
    OrderHeaderView *headView = [[[OrderHeaderView alloc] initWithFrame:(CGRect){{0,0},{self.size.width,YGLY_VIEW_FLOAT(250)}}] autorelease];
    headView.delegate = self;
    [headView setDict:@{@"photo":dict[@"touimg"],
                        @"defaultImageName":@"带你玩默认图片.png",
                        @"title":dict[@"mobile_title"],
                        @"price":dict[@"price"],
                        @"originalPrice":dict[@"prices"]}];
    [self.scrollView addSubview:headView];
    [self showUIViewList:@"UIView" index:0 uiview:self.scrollView];
    [self showUILabelList:@"UILabel" index:0 uiview:self.scrollView];
    
    //-----动态显示集结地－－－－－－－feng--------------------------------
   // NSArray *jiHeDiArray
    UIView *view = [self viewWithTag:611];
    UILabel *label = (UILabel *)[self.scrollView viewWithTag:411];
    CGSize contentSize = [Utility getSizeFormString:label.text maxW:70 font:label.font];
    CGRect lableRect = label.frame;
    lableRect.size.width = contentSize.width;
    label.frame = lableRect;
    
    id jiHeDiArray = dict[@"jihedi"];
    if (jiHeDiArray && [jiHeDiArray isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *mapArray = [NSMutableArray array];
        for (NSDictionary *tmpDict in jiHeDiArray) {
            
            NSMutableDictionary *mapDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mapDict setObject:tmpDict[@"address"] forKey:@"title"];
            [mapDict setObject:@"地图进入默认.png" forKey:@"imageName"];
            [mapDict setObject:@"地图进入按下.png" forKey:@"selectedImageName"];
            [mapDict setObject:tmpDict[@"content"] forKey:@"content"];
            [mapArray addObject:mapDict];
        }
        
        CGFloat viewH = view.size.height;
        CGFloat pointY;
        int LineNumber = 0;
        CGFloat pointX = CGRectGetMaxX(label.frame);
        CGFloat tmpMaxX = pointX;
        for (int j = 0; j <  [mapArray count]; j++) {
            
            CGFloat pointX = CGRectGetMaxX(label.frame);
            MapButton *mapBtn = [MapButton createMapButtonWithDict:mapArray[j] point:CGPointMake(0,0)];
            
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
                tmpMaxX = pointX+2;
                j--;
            }
        }
    }
  //-----动态显示集结地－－－－－－－feng--------------------------------
    [self showUIViewList:@"UIView" index:1 uiview:self.scrollView];
    [self showUILabelList:@"UILabel" index:1 uiview:[self viewWithTag:621]];
    [[self.scrollView viewWithTag:621] addSubview:[self.scrollView viewWithTag:622]];
    [[self.scrollView viewWithTag:621] addSubview:[self.scrollView viewWithTag:623]];
    [self viewWithTag:621].point = CGPointMake(0, CGRectGetMaxY(view.frame));
   //--------
    [self showUIViewList:@"UIView" index:2 uiview:self.scrollView];
    [self viewWithTag:631].point = CGPointMake(0, CGRectGetMaxY([self viewWithTag:621].frame));
    [self showUILabelList:@"UILabel" index:2 uiview:[self.scrollView viewWithTag:631]];
    self.scrollView.contentSize = CGSizeMake(self.size.width, CGRectGetMaxY([self viewWithTag:631].frame));
    
    label = (UILabel *)[[self viewWithTag:621] viewWithTag:422];
    NSString *tmpStr = dict[@"youwan_date"];
    if (tmpStr && [tmpStr isKindOfClass:[NSString class]]) {
        tmpStr = [[tmpStr componentsSeparatedByString:@"-"] componentsJoinedByString:@"/"];
    }
    label.text = tmpStr;
    
    label = (UILabel *)[self.scrollView viewWithTag:432];
  /*  tmpStr = dict[@"youxiao_date"];
    if (tmpStr && [tmpStr isKindOfClass:[NSString class]]) {
        tmpStr = [[tmpStr componentsSeparatedByString:@"-"] componentsJoinedByString:@"/"];
    }*/
    label.text = nil;
    
    
    id yanZhengArray = dict[@"yanzheng"];
    if (yanZhengArray && [yanZhengArray isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *tmpDict in yanZhengArray) {
            
            NSMutableDictionary *yanZhengDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [yanZhengDict setObject:tmpDict[@"verification_code"] forKey:@"password"];
            [yanZhengDict setObject:tmpDict[@"status"] forKey:@"state"];
            [yanZhengDict setObject:tmpDict[@"is_sure"] forKey:@"isSure"];
            
            [self addYuDingMaViewWithDict:yanZhengDict bSpace:0 eSpace:20 delegate:self];
        }
    }
   
    [self addSenceHeadViewWithDic:[self.dictionary valueForKey:@"headviewDict"][0] bSpace:0 eSpace:20];
    order_sn = dict[@"order_sn"];
    NSMutableDictionary *orderDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [orderDict setObject:dict[@"order_sn"] forKey:@"订单号"];
    NSString *dateStr = [Utility getDateBytims:[dict[@"add_time"] doubleValue] key:@"yyyy-MM-dd HH:mm:ss" style:NSDateFormatterMediumStyle];
    [orderDict setObject:dateStr forKey:@"下单时间"];
    [orderDict setObject:[dict[@"mobile_tel"] isKindOfClass:[NSString class]]?dict[@"mobile_tel"]:@"" forKey:@"预定手机号"];
    [orderDict setObject:dict[@"quantity"] forKey:@"数量"];

    [self addBodyViewWithDic:orderDict style:0 bSpace:0 eSpace:0];
    [self addSenceHeadViewWithDic:[self.dictionary valueForKey:@"headviewDict"][1] bSpace:0 eSpace:20];
    [self addBodyViewWithDic:[dict[@"yuding"] dictValueDeleteReturn] style:0 bSpace:0 eSpace:0];
}

#pragma mark -
-(void)showView{
    
    [super showView];
    [[VIewDadaGet sharedGameModel] DingDanDetailForYongHu:_orderId delegate:self];
    [[MainViewController sharedViewController] showLoad:self];
}

#pragma mark - orderHeaderViewDelegate
-(void)orderHeaderViewhadTap{
    
    TakePlayInsidePages*t = (TakePlayInsidePages*)[Utility getViewToId:@"TakePlayInsidePages" tag:[self.productId intValue] rect:self.bounds];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}

#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}
#pragma mark- property-catID
-(NSString *)catId{
    if (_catId == nil) {
        self.catId = @"76";
    }
    return _catId;
}

#pragma mark- 获取订单是否验证的状态
-(void)updateAction{
    
    //向服务器请求数据
    [[VIewDadaGet sharedGameModel] DingDanYanZhengForYongHu:order_sn delegate:self];
}

#pragma mark- 移除视图
-(void)removeFromSuperview{
    
    [super removeFromSuperview];
}

//#pragma mark- 预定码代理
//-(void)erWeiMaDidShow:(YuDingMa *)yuDingMa{
//    
//    //二维码出现
//    [self performSelector:@selector(updateAction) withObject:nil afterDelay:8.0];
//}

@end
