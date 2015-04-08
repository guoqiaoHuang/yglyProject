//
//  GlobalModel.m
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ObserversNotice.h"
#import "VIewDadaGet.h"
#import "NetDefine.h"
#import "LhLocationModel.h"
#import "GlobalModel.h"
@implementation VIewDadaGet
@synthesize delegates;
static VIewDadaGet *shareGameModel = nil;
+ (VIewDadaGet*)sharedGameModel{
    if (!shareGameModel) {
        shareGameModel = [[VIewDadaGet alloc] init];
        shareGameModel.delegates = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return shareGameModel;
}


- (void)dispatchFailed:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)api {
    dispatch_async(dispatch_get_main_queue(), ^{
        ASIFormDataRequest*tmp = [[VIewDadaGet sharedGameModel].delegates objectForKey:api];
        id<VIewDadaGetDelegate> delegate = nil;
        if (tmp) {
            delegate = [tmp.userInfo objectForKey:@"delegate"];
        }
       
        if(delegate  && [delegate  respondsToSelector:@selector(getErrorFinished:withMsg:forApi:)]){
            [delegate getErrorFinished:errNo withMsg:msg forApi:api];
        }
        [[VIewDadaGet sharedGameModel].delegates removeObjectForKey:api];
    });
    
    
}

#pragma mark 初始化
-(ASIFormDataRequest*)getRequest:(NSString*)key delegate:(id)delegate{
    
    ASIFormDataRequest*request =  [self beginRequest:key];
    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"application_num"];
    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"dosubmit"];
    [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:delegate, key,  nil] forKeys:[NSArray arrayWithObjects:@"delegate", @"api", nil]]];
    if(delegate){
        ASIFormDataRequest*tmp = [[VIewDadaGet sharedGameModel].delegates objectForKey:key];
        if (tmp) {
            [tmp clearDelegatesAndCancel];
            tmp = nil;
        }
        [[VIewDadaGet sharedGameModel].delegates removeObjectForKey:key];
        [[VIewDadaGet sharedGameModel].delegates setObject:request forKey:key];
    }
    return request;
}

#pragma mark 成功回调
- (void)dispatchSuccessed:(NSDictionary*)data forApi:(NSString*)api {
    dispatch_async(dispatch_get_main_queue(), ^{
        ASIFormDataRequest*tmp = [[VIewDadaGet sharedGameModel].delegates objectForKey:api];
        id<VIewDadaGetDelegate> delegate = nil;
        if (tmp) {
            delegate = [tmp.userInfo objectForKey:@"delegate"];
        }
        if(delegate  && [delegate  respondsToSelector:@selector(getSuccesFinished:dict:)]){
            [delegate getSuccesFinished:api dict:data];
        }
        [[VIewDadaGet sharedGameModel].delegates removeObjectForKey:api];
    });

}

#pragma mark 带你玩
-(void)TakePlayData:(NSInteger)daynum  time_order:(NSString*)time_order price_order:(NSString*)price_order  order_first:(NSInteger)order_first page:(NSInteger)page delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_dainiwan_list delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:1] forKey:@"product_typ"];
    [request setPostValue:[NSNumber numberWithInteger:daynum] forKey:@"daynum"];
    [request setPostValue:time_order forKey:@"time_order"];
    [request setPostValue:price_order forKey:@"price_order"];
    [request setPostValue:[NSNumber numberWithInteger:order_first] forKey:@"order_first"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    [self endRequest:request];
    
}
#pragma mark 带你玩内页
-(void)TakePlayDataInf:(NSInteger)infId delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_dainiwan_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:infId] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:76] forKey:@"catid"];//带你玩产品
    [self endRequest:request];
    
}

#pragma mark 带你玩内页 线路特色
-(void)TakeXlteInf:(NSInteger)infId delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_xlte_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:infId] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:76] forKey:@"catid"];//带你玩产品
    [self endRequest:request];
    
}
#pragma mark 带你玩内页 行程详情
-(void)TakeXcxqInfo:(NSInteger)infId daynum:(NSInteger)daynum delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_xcxq_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:infId] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:daynum] forKey:@"daynum"];
    [request setPostValue:[NSNumber numberWithInt:76] forKey:@"catid"];//带你玩产品
    [self endRequest:request];
}

#pragma mark 带你玩内页 预定详情
-(void)TakeYdxqInfo:(NSInteger)infId  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_ydxq_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:infId] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:76] forKey:@"catid"];//带你玩产品
    [self endRequest:request];
}





#pragma mark 主题玩列表
-(void)ZhuTiList:(NSInteger)type page:(NSInteger)page delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_list delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [request setPostValue:[NSNumber numberWithInteger:type] forKey:@"zhuti_type"];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    [self endRequest:request];
}

#pragma mark 主题详情
-(void)ZhuTiInfo:(NSInteger)zhutid  catid:(NSInteger)catid  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:catid] forKey:@"catid"];
    [request setPostValue:[NSNumber numberWithInteger:zhutid] forKey:@"id"];
    [self endRequest:request];
}

#pragma mark 喜欢 去过  想去
-(void)ZhuTiYxtypeAdd:(NSInteger)zhutid  catid:(NSInteger)catid  yxtype:(NSInteger)yxtype delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_yxtype_add delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:catid] forKey:@"catid"];
    [request setPostValue:[NSNumber numberWithInteger:zhutid] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:yxtype] forKey:@"yxtype"];
    [self endRequest:request];
}

#pragma mark 大家说列表
-(void)ZhuTiDjsList:(NSInteger)zhutid  catid:(NSInteger)catid  pageid:(NSInteger)pageid delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_djs_list delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:catid] forKey:@"catid"];
    [request setPostValue:[NSNumber numberWithInteger:zhutid] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:pageid] forKey:@"pageid"];
    [self endRequest:request];
}

#pragma mark  大家说发消息
-(void)ZhuTiDjsAdd:(NSInteger)zhutid  catid:(NSInteger)catid  parentid:(NSInteger)parentid content:(NSString*)content delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_djs_add delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:catid] forKey:@"catid"];
    [request setPostValue:[NSNumber numberWithInteger:zhutid] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:parentid] forKey:@"parentid"];
    [request setPostValue:content forKey:@"content"];
    [self endRequest:request];
}


#pragma mark  主题活动搜索
-(void)ZhuTiSearchZthd:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_search_zthd delegate:delegate];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    [request setPostValue:keywords forKey:@"keywords"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}
#pragma mark 特色玩法搜索
-(void)ZhuTiSearchTswf:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_search_tswf delegate:delegate];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    [request setPostValue:keywords forKey:@"keywords"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}


#pragma mark 线路搜索
-(void)ZhuTiSearchXl:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_zhuti_search_xl delegate:delegate];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    [request setPostValue:keywords forKey:@"keywords"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}


#pragma mark  首页数据获取
-(void)ShouYeDataWithDelegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_shouye_data delegate:delegate];
//    [request setPostValue:[Utility getDeviceType] forKey:@"device_type"];
//    [request setPostValue:[NSNumber numberWithFloat:[Utility getSystemVersion]] forKey:@"system_version"];
//    [request setPostValue:[Utility getApplicationVersion] forKey:@"Application_version"];
//    [request setPostValue:[GlobalModel sharedGameModel].deviceToken forKey:@"device_token"];
//    [request setPostValue:[Utility getUdid] forKey:@"udid"];
//    [request setPostValue:[NSNumber numberWithInteger:21] forKey:@"modelid"];
    [request setPostValue:[LhLocationModel nowLocationCode] forKey:@"cityid"];
    
    [self endRequest:request];
}

#pragma mark 订单提交
-(void)YuDingTiJiaoWith:(NSInteger)xlId catId:(NSInteger)catId tel:(NSString *)tel yd_num:(NSInteger)yd_num delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_order_chuli delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:xlId] forKey:@"id"];
    [request setPostValue:[NSNumber numberWithInteger:catId] forKey:@"catid"];
    [request setPostValue:tel forKey:@"tel"];
    [request setPostValue:[NSNumber numberWithInteger:yd_num] forKey:@"yd_num"];
    [self endRequest:request];
}

#pragma mark 用户订单列表获取
-(void)DingDanListForShangHu:(NSInteger)type page:(NSInteger)page delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_shanghu_list delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}
-(void)DingDanListForYongHu:(NSInteger)type page:(NSInteger)page delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_yonghu_list delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}

#pragma mark 用户订单详情
-(void)DingDanDetailForYongHu:(NSString *)orderId delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_yonghu_detail delegate:delegate];
    [request setPostValue:orderId forKey:@"orderid"];
    [self endRequest:request];
}
#pragma mark 验证状态查询接口
-(void)DingDanYanZhengForYongHu:(NSString *)orderNumber delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_yonghu_yanzheng delegate:delegate];
    [request setPostValue:orderNumber forKey:@"order_sn"];
    [self endRequest:request];

}
#pragma mark 商户订单详情
-(void)DingDanDetailForShangHu:(NSString *)productId catId:(NSInteger)catId userType:(NSInteger)userType page:(NSInteger)page delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_shanghu_detail delegate:delegate];
    [request setPostValue:productId forKey:@"productid"];
    [request setPostValue:[NSNumber numberWithInteger:catId] forKey:@"catid"];
    [request setPostValue:[NSNumber numberWithInteger:userType] forKey:@"usertype"];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}

#pragma mark 商家用户联系验证
-(void)DingDanForLianXi:(NSString *)orderNumber delegate:(id)delegate;{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_shanghu_lianxi delegate:delegate];
    [request setPostValue:orderNumber forKey:@"order_sn"];
    [self endRequest:request];
}
-(void)DingDanForTiXi:(NSString *)useId orderNumber:(NSString *)orderNumber content:(NSString *)content delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_shanghu_tixi delegate:delegate];
    [request setPostValue:useId forKey:@"userid"];
    [request setPostValue:orderNumber forKey:@"order_sn"];
    [request setPostValue:content forKey:@"content"];
    [self endRequest:request];
}

#pragma mark- 商家验证（二维码 或者 验证码）
-(void)DingDanForYanZheng:(NSString *)keyNumber type:(NSInteger)type delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_dingdan_shanghu_yanzheng delegate:delegate];
    [request setPostValue:keyNumber forKey:@"keynum"];
    [request setPostValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    [self endRequest:request];
}

#pragma mark- 收藏
-(void)ShouCangForYongHu:(NSInteger)page delegate:(id)delegate{
    
    ASIFormDataRequest *request = [self getRequest:app_yonghu_shoucang delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self endRequest:request];
}
@end
