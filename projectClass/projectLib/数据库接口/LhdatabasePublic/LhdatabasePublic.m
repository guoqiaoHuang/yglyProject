//
//  LittleMathFirstGlobalModel.m
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "LhdatabasePublic.h"
#import "Utility.h"
#import "NetDefine.h"
@implementation LhdatabasePublic

-(id)init{
    lock = [[NSLock alloc] init];
    return [super init];
}
-(void)dealloc{
    [lock release];
    lock = nil;
    [super dealloc];
}

+ (LhdatabasePublic*)sharedInstance {
    static LhdatabasePublic* selModel = nil;
    if (!selModel) {
        selModel = [[LhdatabasePublic alloc] init];
    }
    return selModel;
}

-(void)StatDbOpen{
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/DataBase/YglyDataBase/Client.sqlite"] ;//单例模式
    database= [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        EBLog(@"Could not open db.");
        database =  nil;
    }
}
-(void)endDbOpen{
    [database close];
}



-(int)_getHttpCacheCountCount:(NSString*)sql{
    [lock lock];
    FMResultSet *results = [database executeQuery:@"Select count(*) as num from babyinfo"];
    [lock unlock];
    int num = 0;
    while([results next]) {
        num  = [[results stringForColumn:@"num"]intValue];
    }
    return num;
}
#pragma  mark 得到缓存数量
+(int)getHttpCacheCount{
    [[LhdatabasePublic sharedInstance]StatDbOpen];
    int num = [[LhdatabasePublic sharedInstance]_getHttpCacheCountCount:@"Select count(id) as num from httpcachedata"];
    [[LhdatabasePublic sharedInstance]endDbOpen];
    return num;
}

#pragma  mark 更新或插入数据
+(void)UpOrInsertData:(NSString*)Sql{
    [[LhdatabasePublic sharedInstance]StatDbOpen];
    [[LhdatabasePublic sharedInstance]_UpOrInsertData:Sql];;
    [[LhdatabasePublic sharedInstance]endDbOpen];
}

-(void)_UpOrInsertData:(NSString*)Sql{
    [lock lock];
    [database executeUpdate:Sql];
    [lock unlock];
}
#pragma  mark 插入httpcache数据
+(void)InsertHttpCache:(NSString*)key value:(NSString*)value{
     NSString *sql = [NSString stringWithFormat:@"replace into httpcachedata (key,value,createtime) values('%@','%@','%@')",key,value,[Utility getNowTime:@"yyyy-MM-dd HH:mm:ss"  style:NSDateFormatterFullStyle]];
    [LhdatabasePublic UpOrInsertData:sql];
}

#pragma  mark 得到value数据
+(NSDictionary*)getHttpCacheValue:(NSString*)key{
    NSString *sql = [NSString stringWithFormat:@"select value from httpcachedata where key = '%@'",key];
    return [LhdatabasePublic getValueBySql:sql];
}

+(NSDictionary*)getValueBySql:(NSString*)sql{
    [[LhdatabasePublic sharedInstance]StatDbOpen];
    NSDictionary* value =  [[LhdatabasePublic sharedInstance]_getValueBySql:sql];;
    [[LhdatabasePublic sharedInstance]endDbOpen];
    return value;
}
-(NSDictionary*)_getValueBySql:(NSString*)sql{
    FMResultSet *results = [database executeQuery:sql];
    NSString*value = nil;
    while([results next]) {
        [value release];
        value =  [[results stringForColumn:@"value"]copy];
    }
    NSDictionary*dic =  ( NSDictionary*)[value JSONValue];
    [value release];
    return dic;

}

#pragma  mark 删除httpcache数据
+(void)deleteHttpCache{
    NSString *sql = [NSString stringWithFormat:@"delete from httpcachedata where id < (select Max(id) -300 from httpcachedata)"];
    [LhdatabasePublic UpOrInsertData:sql];
}
#pragma mark 初始化api借口配置
-(NSDictionary*)getApiDict{
    if (!self.apiDict) {
        self.apiDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                   @"1",app_logout,
                   @"1",app_login,
                   @"1",app_register,
                   @"1",app_auto_login,
                   @"1",app_public_checkname_ajax,
                   @"1",app_public_checkemail_ajax,
                   @"1",app_account_manage_avatar_get,
                   @"1",app_zhuti_yxtype_add,
                   @"1",app_account_manag,
                   @"1",app_order_chuli,
                   @"1",app_ydxq_info,
                    @"1",app_yonghu_shoucang,
                    @"1",app_dingdan_yonghu_yanzheng,
                    @"1",app_dingdan_yonghu_list,
                    @"1",app_dingdan_yonghu_detail,
                    @"1",app_dingdan_shanghu_list,
                    @"1",app_dingdan_shanghu_detail,
                    @"1",app_dingdan_shanghu_lianxi,
                    @"1",app_dingdan_shanghu_tixi,
                    @"1",app_dingdan_shanghu_yanzheng,
                   nil];
    }
  return self.apiDict;
}
#pragma mark 判断哪些api需要缓存
+(BOOL)getNoInsertApi:(NSString*)api{
    NSDictionary*dict =  [[LhdatabasePublic sharedInstance]getApiDict];
    return [dict intValue:api]==0;
}

@end
