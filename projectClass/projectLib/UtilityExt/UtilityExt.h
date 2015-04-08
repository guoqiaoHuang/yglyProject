
#import <Foundation/Foundation.h>
#import "Utility.h"
#import "NetDefine.h"
@interface Utility (Ext)
+(NSString *)hdGetFullUrl:(NSString *)url;
+(CLLocationCoordinate2D)getLocation:(NSDictionary *)dict;

+(NSArray *)getProvienceAndCity:(NSDictionary *)dict;
+(void)showMsg:(NSString *)msg;
+(BOOL)locationServiceMode;
+(BOOL)checkView:(UIView *)view containPoint:(CGPoint)point;

#pragma mark--短信息管理提示框展示
-(void)showDataReciverSuccessMsg:(NSString *)msg;//数据获取成功展示
-(void)showDataReciverFailMsg:(NSInteger)errNo withMsg:(NSString *)msg forApi:(NSString *)apiKey;

@end