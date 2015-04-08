//
//  GlobalModel.h
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatherHttpModel.h"
@protocol VIewDadaGetDelegate<NSObject>
@optional
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict;
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;
@end
@interface VIewDadaGet : FatherHttpModel{
}
@property(nonatomic,retain) NSMutableDictionary* delegates;
+ (VIewDadaGet*)sharedGameModel;

#pragma mark 带你玩
-(void)TakePlayData:(NSInteger)daynum  time_order:(NSString*)time_order price_order:(NSString*)price_order  order_first:(NSInteger)order_first page:(NSInteger)page delegate:(id)delegate;
-(void)TakePlayDataInf:(NSInteger)infId  delegate:(id)delegate;
-(void)TakeXlteInf:(NSInteger)infId delegate:(id)delegate;
-(void)TakeXcxqInfo:(NSInteger)infId daynum:(NSInteger)daynum delegate:(id)delegate;
-(void)TakeYdxqInfo:(NSInteger)infId  delegate:(id)delegate;

#pragma mark 主题玩列表
-(void)ZhuTiList:(NSInteger)type page:(NSInteger)page delegate:(id)delegate;
-(void)ZhuTiInfo:(NSInteger)zhutid  catid:(NSInteger)catid  delegate:(id)delegate;
-(void)ZhuTiYxtypeAdd:(NSInteger)zhutid  catid:(NSInteger)catid  yxtype:(NSInteger)yxtype delegate:(id)delegate;
-(void)ZhuTiDjsList:(NSInteger)zhutid  catid:(NSInteger)catid  pageid:(NSInteger)pageid delegate:(id)delegate;
-(void)ZhuTiDjsAdd:(NSInteger)zhutid  catid:(NSInteger)catid  parentid:(NSInteger)parentid content:(NSString*)content delegate:(id)delegate;

#pragma mark 搜索
-(void)ZhuTiSearchZthd:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate;

-(void)ZhuTiSearchTswf:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate;
-(void)ZhuTiSearchXl:(NSString*)keywords  page:(NSInteger)page delegate:(id)delegate;

#pragma mark  首页数据获取
-(void)ShouYeDataWithDelegate:(id)delegate;

#pragma mark 订单提交
-(void)YuDingTiJiaoWith:(NSInteger)xlId catId:(NSInteger)catId tel:(NSString *)tel yd_num:(NSInteger)yd_num delegate:(id)delegate;

#pragma mark 用户订单列表获取
-(void)DingDanListForShangHu:(NSInteger)type page:(NSInteger)page delegate:(id)delegate;
-(void)DingDanListForYongHu:(NSInteger)type page:(NSInteger)page delegate:(id)delegate;

#pragma mark 用户订单详情
-(void)DingDanDetailForYongHu:(NSString *)orderId delegate:(id)delegate;
#pragma mark 验证状态查询接口
-(void)DingDanYanZhengForYongHu:(NSString *)orderNumber delegate:(id)delegate;

#pragma mark 商户订单详情
-(void)DingDanDetailForShangHu:(NSString *)productId catId:(NSInteger)catId userType:(NSInteger)userType page:(NSInteger)page delegate:(id)delegate;

#pragma mark 商家用户联系验证
-(void)DingDanForLianXi:(NSString *)orderNumber delegate:(id)delegate;
-(void)DingDanForTiXi:(NSString *)useId orderNumber:(NSString *)orderNumber content:(NSString *)content delegate:(id)delegate;

#pragma mark- 商家验证（二维码 或者 验证码）
-(void)DingDanForYanZheng:(NSString *)keyNumber type:(NSInteger)type delegate:(id)delegate;

#pragma mark- 收藏
-(void)ShouCangForYongHu:(NSInteger)page delegate:(id)delegate;
@end
