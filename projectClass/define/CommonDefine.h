//
//  Header.h
//  StickFigureSecond
//
//  Created by dev_lei on 13-4-16.
//  Copyright (c) 2013年 dev_lei. All rights reserved.
//

#ifndef COMMON_DEFINE_h
#define COMMON_DEFINE_h




#define FILEMANAGER [NSFileManager defaultManager]
#define IS_IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DocumentPath NO //控制读取文件路径

#ifdef DEBUG
#define AppPushAlias   @"YglypDebug"
#define EBLog(...) NSLog(__VA_ARGS__)
#else
#define AppPushAlias   @"YglypRelese"
#define EBLog(...) /* */
#endif

#define  CenterPoint(p1,p2) CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5)
#define degreesToRadians(x) (3.14*(x)/180.0)

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


#define LHNSStringFromCGPoint           NSStringFromCGPoint
#define LHNSStringFromCGSize            NSStringFromCGSize
#define LHNSStringFromCGRect            NSStringFromCGRect
#define LHNSStringFromCGAffineTransform NSStringFromCGAffineTransform
#define LHNSStringFromUIEdgeInsets      NSStringFromUIEdgeInsets
#define LHCGPointFromString             CGPointFromString
#define LHCGSizeFromString              CGSizeFromString
#define LHCGRectFromString              CGRectFromString
#define LHCGAffineTransformFromString   CGAffineTransformFromString
#define LHUIEdgeInsetsFromString        UIEdgeInsetsFromString
#define LHUIOffsetFromString            UIOffsetFromString
#define LHCGAffineTransformFromString   CGAffineTransformFromString




#define maxPasswordLength   10
#define minPasswordLength   6
#define maxUserNameLength   10
#define minUserNameLength   4
#define maxEmailLength   20

#define TemporaryNotOpened @"暂未开通"
#define AvactorImage         @"AvactorImage.jpg"
#define YangGuangDownloadPath   @"Library/YangGuanLvYou/Download"
#define Application_version      1.0

//信息管理单例
#define MESSAGE_MANAGER [MessageManager sharedMessageManager]
#define IS_LOGIN [GlobalModel isLogin]
#define LOGIN_AUTH [GlobalModel login_auth]
//信息存储
#define MESSAGE_MANAGER_FOR_DB [MessageManagerForDB sharedInstance]
//收件箱
#define RECIVER_MESSAGE_TABLE  @"GET_MESSAGE_INBOX"
//发件箱
#define POST_MESSAGE_TABLE  @"POST_MESSAGE_OUTBOX"
//系统消息
#define SYSTEM_MESSAGE_TABLE  @"SYSTEM_MESSAGE"

#define TEXT_VIEW_SIZE(textView) [textView sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)]

//城市发生改变通知
#define CURRENT_CITY_CHANGED_NOTIFICATION @"currentCityChange"
#define adEffecTime   4.0
#endif

//模拟器与真机区分
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

