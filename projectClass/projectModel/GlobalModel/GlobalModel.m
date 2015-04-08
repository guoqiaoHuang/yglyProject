//
//  GlobalModel.m
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ObserversNotice.h"
#import "GlobalModel.h"
#import "NetDefine.h"

@implementation GlobalModel
@synthesize selfUserProfile;
@synthesize deviceToken;
@synthesize currentDefaultVersion;
@synthesize delegates;
@synthesize loginType;
@synthesize apserviceRegistrationID;//激光推送
static GlobalModel *shareGameModel = nil;
+ (GlobalModel*)sharedGameModel{
	if (!shareGameModel)
    {
		shareGameModel = [[GlobalModel alloc] init];
        shareGameModel.delegates = [NSMutableDictionary dictionaryWithCapacity:10];
        shareGameModel.selfUserProfile = [[NSUserDefaults standardUserDefaults]objectForKey:@"selfUserProfile"];
        shareGameModel.loginType = (int)[[[NSUserDefaults standardUserDefaults]objectForKey:@"loginType"]integerValue];
	}
	return shareGameModel;
}

+(BOOL)isLogin{
    NSString * login_auth = [GlobalModel login_auth];
    if(login_auth){
        return YES;
    }
    return NO;
}
+(NSString*)login_auth{
    if([GlobalModel sharedGameModel].selfUserProfile){
        return [GlobalModel sharedGameModel].selfUserProfile[@"login_auth"];
    }
    return nil;
}

+(NSInteger)userid{
    if([GlobalModel sharedGameModel].selfUserProfile){
        return [[GlobalModel sharedGameModel].selfUserProfile intValue:@"userid"];
    }
    return 0;
}

-(void)setSelfUserProfile:(NSDictionary *)tselfUserProfile{
    [selfUserProfile release];
    selfUserProfile = nil;
    selfUserProfile = [tselfUserProfile retain];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",shareGameModel.loginType]forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults]setObject:selfUserProfile forKey:@"selfUserProfile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if(tselfUserProfile == nil){
        [ObserversNotice TellViewNotice:YGLYNoticeTypeLogoutSuccess];
    }else{
        [ObserversNotice TellViewNotice:YGLYNoticeTypeLoginSuccess];
    }
    
}


- (id) init {
    if (self = [super init]) {
        self.deviceToken = [Utility getUdid];
        selfUserProfile = nil;
    }
    return self;
}

- (void)dealloc {
    [selfUserProfile release];
    [deviceToken release];
    [super dealloc];
}






- (void)dispatchSuccessed:(NSDictionary*)data forApi:(NSString*)api {
   if ([api isEqualToString:app_account_manag]) {
       [self didSelfUseData:data forkey:api];
        return ;
    } else if([api isEqualToString:app_register] || [api isEqualToString:app_login] ||[api isEqualToString:app_auto_login]){
        self.isFirstLogin = YES;
        [self didGetProfile:data forkey:api];
    }else if ([api isEqualToString:app_account_manage_info]){
        [self didSelfUseData:data forkey:api];
        return;
    }else if([api isEqualToString:app_account_manage_avatar]){
        [self didSelfUseData:data forkey:api];
        return;
    }else {
        id<GlobalModelDelegate> delegate = [[GlobalModel sharedGameModel].delegates objectForKey:api];
        if(delegate  && [delegate  respondsToSelector:@selector(getSuccesFinished:)]){
            [delegate  performSelector:@selector(getSuccesFinished:) withObject:api];
            [[GlobalModel sharedGameModel].delegates removeObjectForKey:api];
        }
    }
}



- (void)didSelfUseData:(NSDictionary*)dict forkey:(NSString*)forkey{
    
    NSMutableDictionary*tmpData = [NSMutableDictionary dictionaryWithCapacity:3];
    if(self.selfUserProfile){
        NSArray*keys = [self.selfUserProfile allKeys];
        for(int i = 0; i< keys.count;i++){
            NSString*key = keys[i];
            [tmpData setObject:self.selfUserProfile[key] forKey:key];
        }
    }
    NSArray*keys = [dict allKeys];
    for(int i = 0; i< keys.count;i++){
        NSString*key = keys[i];
        [tmpData setObject:dict[key] forKey:key];
    }
    self.selfUserProfile = tmpData;
    id<GlobalModelDelegate> delegate = [[GlobalModel sharedGameModel].delegates objectForKey:forkey];
    if(delegate  && [delegate  respondsToSelector:@selector(getSuccesFinished:)]){
        [delegate  performSelector:@selector(getSuccesFinished:) withObject:forkey];
        [[GlobalModel sharedGameModel].delegates removeObjectForKey:forkey];
    }
}


- (void)didGetProfile:(NSDictionary*)dict forkey:(NSString*)forkey{
    [Utility delay:0.0 action:^{//异步加载，
        self.selfUserProfile = dict;
    }];
    id<GlobalModelDelegate> delegate = [[GlobalModel sharedGameModel].delegates objectForKey:forkey];
    if(delegate  && [delegate  respondsToSelector:@selector(getSuccesFinished:)]){
        [delegate  performSelector:@selector(getSuccesFinished:) withObject:forkey];
        [[GlobalModel sharedGameModel].delegates removeObjectForKey:forkey];
    }
}

- (void)didUsersLogoutReceiveData:(NSDictionary*)dict forkey:(NSString*)forkey{
    self.selfUserProfile = nil;
    id<GlobalModelDelegate> delegate = [[GlobalModel sharedGameModel].delegates objectForKey:forkey];
    if(delegate  && [delegate  respondsToSelector:@selector(getSuccesFinished:)]){
        [delegate  performSelector:@selector(getSuccesFinished:) withObject:forkey];
        [[GlobalModel sharedGameModel].delegates removeObjectForKey:forkey];
    }
}


#pragma mark 登录
- (void)userLogin:(NSString*)username password:(NSString*)password delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_login delegate:delegate];
    [request setPostValue:[Utility getApplicationVersion] forKey:@"Application_version"];
    [request setPostValue:[NSNumber numberWithFloat:[Utility getSystemVersion]] forKey:@"system_version"];
    [request setPostValue:[Utility getDeviceType] forKey:@"device_type"];
    [request setPostValue:[GlobalModel sharedGameModel].deviceToken forKey:@"device_token"];
    [request setPostValue:[Utility getUdid] forKey:@"udid"];
    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"types"];//ios 默认1
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [ASIFormDataRequest setSessionCookies:nil];//清空缓存的SessionCookies
    [self endRequest:request];
}

#pragma mark 自动登陆
- (void)userAutoLogin:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_auto_login delegate:delegate];
    [request setPostValue:[Utility getApplicationVersion] forKey:@"Application_version"];
    [request setPostValue:[NSNumber numberWithFloat:[Utility getSystemVersion]] forKey:@"system_version"];
    [request setPostValue:[Utility getDeviceType] forKey:@"device_type"];
    [request setPostValue:[GlobalModel sharedGameModel].deviceToken forKey:@"device_token"];
    [request setPostValue:[Utility getUdid] forKey:@"udid"];
    [ASIFormDataRequest setSessionCookies:nil];//清空缓存的SessionCookies
    [self endRequest:request];
}


#pragma mark 注册
- (void)userRegister:(NSString*)mobile password:(NSString*)password  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_register delegate:delegate];
    [request setPostValue:[Utility getApplicationVersion] forKey:@"Application_version"];
    [request setPostValue:[NSNumber numberWithFloat:[Utility getSystemVersion]] forKey:@"system_version"];
    [request setPostValue:[Utility getDeviceType] forKey:@"device_type"];
    [request setPostValue:[GlobalModel sharedGameModel].deviceToken forKey:@"device_token"];
    [request setPostValue:[Utility getUdid] forKey:@"udid"];
    [request setPostValue:[NSNumber numberWithInteger:21] forKey:@"modelid"];//ios 默认21
    [request setPostValue:[NSNumber numberWithInteger:1] forKey:@"types"];//ios 默认1
    [request setPostValue:mobile forKey:@"mobile"];
    [request setPostValue:password forKey:@"password"];
    [self endRequest:request];
}

- (void)userLogout{
    
    ASIFormDataRequest *request = [self getRequest:app_logout delegate:nil];
    [request setPostValue:[Utility getUdid] forKey:@"udid"];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    
    [self endRequest:request];
    [GlobalModel sharedGameModel].selfUserProfile = nil;
    [Login Logout];
}


#pragma mark 验证用户名
- (void)publicChecknameAjax:(NSString*)username delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_public_checkname_ajax delegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [self endRequest:request];
}

#pragma mark 验证邮箱
- (void)publicCheckemailAjax:(NSString*)email delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_public_checkemail_ajax delegate:delegate];
    [request setPostValue:email forKey:@"email"];
    [self endRequest:request];
}


- (void)dispatchFailed:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)api {
    if([api isEqualToString:app_auto_login]){
        [GlobalModel sharedGameModel].selfUserProfile = nil;
    }
    id<GlobalModelDelegate> delegate = [[GlobalModel sharedGameModel].delegates objectForKey:api];
    if(delegate  && [delegate  respondsToSelector:@selector(getErrorFinished:withMsg:forApi:)]){
        [delegate getErrorFinished:errNo withMsg:msg forApi:api];
        [[GlobalModel sharedGameModel].delegates removeObjectForKey:api];
    }
}


#pragma mark 获取个人信息
- (void)accountManage:(NSString*)login_auth delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manag delegate:delegate];
    [request setPostValue:login_auth forKey:@"login_auth"];
    [self endRequest:request];

}

#pragma mark 修改用户信息
- (void)accountManageInfo:(NSString*)nickname info:(NSDictionary*)info  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_info delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    if(info){
        [request setPostValue:[info JSONRepresentation] forKey:@"info"];
    }
    if(nickname){
       [request setPostValue:nickname forKey:@"nickname"];
    }
    [self endRequest:request];
}

#pragma mark 修改密码
-(void)accountManagePassword:(NSDictionary*)info  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_password delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    [request setPostValue:[info JSONRepresentation] forKey:@"info"];
    [self endRequest:request];
    
}

#pragma mark 密码找回
-(void)accountManagePasswordLost:(NSDictionary*)info  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_password_lost delegate:delegate];
    [request setPostValue:[info JSONRepresentation] forKey:@"info"];
    [self endRequest:request];
    
}


#pragma mark 修改邮箱
-(void)accountManageEmail:(NSDictionary*)info  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_email delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    [request setPostValue:[GlobalModel login_auth] forKey:@"login_auth"];
    [request setPostValue:[info JSONRepresentation] forKey:@"info"];
    [self endRequest:request];
    
}


#pragma mark 修改头像
-(void)accountManageAvatar:(NSString*)pic  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_avatar delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    [request setFile:pic forKey:@"pic"];
    [self endRequest:request];
}

-(void)accountManageAvatarGet:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_account_manage_avatar_get delegate:delegate];
    [request setPostValue:[NSNumber numberWithInteger:[GlobalModel userid]] forKey:@"userid"];
    [self endRequest:request];
}
-(ASIFormDataRequest*)getRequest:(NSString*)key delegate:(id)delegate{
    if(delegate){
        [[GlobalModel sharedGameModel].delegates removeObjectForKey:key];
        [[GlobalModel sharedGameModel].delegates setObject:delegate forKey:key];
    }
    ASIFormDataRequest*request =  [self beginRequest:key];
    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"application_num"];
    [request setPostValue:[NSNumber numberWithInt:1] forKey:@"dosubmit"];
//    [request setPostValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"apptime"];
    return request;
}



#pragma mark 密码找回
-(void)appYjfk:(NSString*)info  delegate:(id)delegate{
    ASIFormDataRequest *request = [self getRequest:app_dingdan_yonghu_yjfk delegate:delegate];
    [request setPostValue:info forKey:@"content"];
    [self endRequest:request];
    
}
@end
