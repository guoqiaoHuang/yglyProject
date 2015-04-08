
#import "UtilityExt.h"
@implementation Utility (Ext)

+(NSString *)hdGetFullUrl:(NSString *)url {
    if (url == nil || [url length] < 7) {
        EBLog(@"hdGetFullUrl:error");
        return url;
    }
    if ([[url substringToIndex:7] isEqualToString:@"http://"]) {
        return url;
    } else {
        return [URL_CONNECTION_IMGSITE stringByAppendingString:url];
    }
}
+(CLLocationCoordinate2D)getLocation:(NSDictionary *)dict
{
    if (dict != nil) {
        NSString *tmpStr = [dict objectForKey:@"location"];
        NSString *trimmedStr = [tmpStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //去括号
        NSRange range = NSMakeRange(1, trimmedStr.length-2);
        trimmedStr = [trimmedStr substringWithRange:range];
        
        NSArray *array = [trimmedStr componentsSeparatedByString:@","];
        if (array != nil && array.count == 2) {
            
            return CLLocationCoordinate2DMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
        }
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

+(NSArray *)getProvienceAndCity:(NSDictionary *)dict
{
    if (dict != nil) {
        NSString *tmpStr = [dict objectForKey:@"provience"];
        NSString *trimmedStr = [tmpStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray *array = [trimmedStr componentsSeparatedByString:@"-"];
        if (array != nil && array.count == 2) {
         
            return array;
        }
    }
    return nil;
}
+(void)showMsg:(NSString *)msg
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alterView show];
    [alterView release];
}

+(BOOL)locationServiceMode
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];//判断定位服务是否被打开
    
    if (kCLAuthorizationStatusDenied == status||
        
        kCLAuthorizationStatusRestricted == status) {
        
        [Utility showMsg:@"请打开您的位置服务!"];
        return false;
    }
    return true;
}
+(BOOL)checkView:(UIView *)view containPoint:(CGPoint)point
{
    return CGRectContainsPoint(view.frame, point);
}

#pragma mark--短信息管理提示框展示
-(void)showDataReciverSuccessMsg:(NSString *)msg//数据获取成功展示
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
}
-(void)showDataReciverFailMsg:(NSInteger)errNo withMsg:(NSString *)msg forApi:(NSString *)apiKey
{
    if (errNo == 12) {
        msg = @"您还未登录，请先登录！";
    }
    if (errNo == -11) {
        msg = @"身份验证失败，请稍后重试！";
    }
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alterView show];
    [alterView release];
}

@end
