//
//  LittleMathFirstGlobalModel.h
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h> 

#import "FMDatabase.h"
@interface LhdatabasePublic :NSObject
{
     NSLock *lock;
    FMDatabase *database;
   
}
@property (nonatomic,retain) NSDictionary *apiDict;
+ (LhdatabasePublic *)sharedInstance;
#pragma  mark 得到缓存数量
+(int)getHttpCacheCount;
+(void)InsertHttpCache:(NSString*)key value:(NSString*)value;
+(NSDictionary*)getHttpCacheValue:(NSString*)key;
#pragma  mark 删除httpcache数据
+(void)deleteHttpCache;
+(BOOL)getNoInsertApi:(NSString*)api;
-(NSDictionary*)getApiDict;
@end
