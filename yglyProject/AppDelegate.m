//
//  AppDelegate.m
//  StickFigureSecond
//
//  Created by dev_lei on 13-4-15.
//  Copyright (c) 2013年 dev_lei. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MainViewController.h"
#import "Utility.h"
#import "MyView.h"
#import "JsonData.h"
#import "GlobalModel.h"

#import "LhLocationModel.h"
#import "NstimerModel.h"
#import "LhdatabasePublic.h"
#import "LhSelfKeyboard.h"
//第三方
#import <MAMapKit/MAMapKit.h>//高德地图
#import "APService.h"//激光推送
#import "MobClick.h"//友盟
#import "AppKeFuLib.h"//微克服
#import "SMS_SDK/SMS_SDK.h"
#define AppKeFuLib_APP_KEY @"bcba4d1e47f772dd6a1e65bcf2366382"
@implementation AppDelegate

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/DataBase"]];
    if(flag || [Utility UnzipFileToPath:[Utility getPathByName:@"YglyDataBase.zip"] path:[Utility GetCachePath:@"Library/DataBase"]]){
        EBLog(@"解压成功");
    }else{
        EBLog(@"解压失败");
    }
    //删除httpcache数据
    [LhdatabasePublic deleteHttpCache];
    //友盟
    [self statYouMeng];
    //推送注册
    [self pushRegister:launchOptions];
    //地图定位开始
    [MAMapServices sharedServices].apiKey = @"101a598ebd0c435a352b605683df8a3b";
    
    [[GlobalModel sharedGameModel] userAutoLogin:nil];//自动登录
    
    [LhLocationModel shareLocationModel];
    [NstimerModel sharedNstimerModel];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController sharedViewController] autorelease]];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    [Utility getNode];
    [MyView statWater:@"水波纹底.png"];
    
    
//    微克服
    [[AppKeFuLib sharedInstance] loginWithAppkey:AppKeFuLib_APP_KEY];
//#define appKey @"25a64c839b5f"
//#define appSecret @"9a639150fcb464d9a1c1ab926648ca3f"
#define appKey @"46811b982c04"
#define appSecret @"eb7fac232990d887f2a1551f38b12d91"
    [SMS_SDK	registerApp:appKey withSecret:appSecret];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //进入后台
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //微克服退出
    [[AppKeFuLib sharedInstance] logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //被激活
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    //微克服被激活
    [[AppKeFuLib sharedInstance] loginWithAppkey:AppKeFuLib_APP_KEY];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    
     //k k k//    [[GameDataModel sharedInstance].gameData setValue:[NSString stringWithFormat:@"%d",0] forKey:@"gamenum"];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}



#pragma mark_
#pragma mark 友盟
-(void)statYouMeng{
    //数据统计与页面展现数据非实时  页面展示有一定延迟
    [MobClick startWithAppkey:@"541152a6fd98c5f8950068c4"];
    [MobClick setAppVersion:[Utility getApplicationVersion]];
#ifdef DEBUG
//    [MobClick setLogEnabled:YES];
#else
#endif
    
    [MobClick beginEvent:@"test1"];
    [MobClick endEvent:@"test1"];
}

#pragma mark_
#pragma mark 推送code

- (void)networkDidRegister:(NSNotification *)notification {
    [GlobalModel sharedGameModel].apserviceRegistrationID = [APService registrationID];
    EBLog(@"已注册:%@",[APService registrationID]);
}

- (void)networkDidLogin:(NSNotification *)notification {
    [GlobalModel sharedGameModel].apserviceRegistrationID = [APService registrationID];
    
    EBLog(@"已登录:%@",[APService registrationID]);
    
    [APService setAlias:AppPushAlias callbackSelector:nil object:nil];
    
}

-(void)pushRegister:(NSDictionary *)launchOptions{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidSetupNotification object:nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
    [GlobalModel sharedGameModel].deviceToken = [[[[deviceToken description]
                                                   stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                                  stringByReplacingOccurrencesOfString:@">" withString:@""]
                                                 stringByReplacingOccurrencesOfString:@" " withString:@""];
    EBLog(@"deviceToken:%@",[GlobalModel sharedGameModel].deviceToken);
    //同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
//    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
    

}


- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    EBLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
  //  NSLog(@"发送通知:%@", [self logDic:userInfo]);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark 发送通知点击回调
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString*msg = [dic objectForKey:@"aps"][@"alert"];
//    [Utility alertMsg:@"发送通知" msg:msg];
    [[MainViewController sharedViewController] postViewByMsg:msg];
    return msg;
}
#pragma mark 自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    [Utility alertMsg:@"自定义" msg:content];
    
}

@end
