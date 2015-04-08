//
//  GlobalModel.h
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatherHttpModel.h"
#import "Login.h"
@protocol GlobalModelDelegate<NSObject>
@optional
-(void)getSuccesFinished:(NSString*)apiKey;
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;
@end

@interface GlobalModel : FatherHttpModel{
}
@property (assign,nonatomic)LoginType loginType;
@property(nonatomic,retain)  NSMutableDictionary* delegates;
@property (copy, nonatomic) NSString *deviceToken;
@property(copy,nonatomic)NSString*apserviceRegistrationID;//激光推送
@property (copy, nonatomic) NSDictionary *selfUserProfile;
@property (assign,nonatomic) NSInteger currentDefaultVersion;

@property (assign,nonatomic) BOOL isFirstLogin;

+ (GlobalModel*)sharedGameModel;
+(BOOL)isLogin;
+(NSInteger)userid;
+(NSString*)login_auth;

- (void)userLogout;
#pragma mark 登陆
- (void)userLogin:(NSString*)username password:(NSString*)password delegate:(id)delegate;
- (void)userAutoLogin:(id)delegate;
#pragma mark 注册
- (void)userRegister:(NSString*)mobile password:(NSString*)password  delegate:(id)delegate;
- (void)publicChecknameAjax:(NSString*)username delegate:(id)delegate;
#pragma mark 验证邮箱
- (void)publicCheckemailAjax:(NSString*)email delegate:(id)delegate;

#pragma mark 获取个人信息
- (void)accountManage:(NSString*)login_auth delegate:(id)delegate;
- (void)accountManageInfo:(NSString*)nickname info:(NSDictionary*)info  delegate:(id)delegate;
-(void)accountManagePassword:(NSDictionary*)info  delegate:(id)delegate;
-(void)accountManageEmail:(NSDictionary*)info  delegate:(id)delegate;
-(void)accountManageAvatar:(NSString*)pic  delegate:(id)delegate;
-(void)accountManageAvatarGet:(id)delegate;
-(void)accountManagePasswordLost:(NSDictionary*)info  delegate:(id)delegate;
-(void)appYjfk:(NSString*)info  delegate:(id)delegate;
@end
