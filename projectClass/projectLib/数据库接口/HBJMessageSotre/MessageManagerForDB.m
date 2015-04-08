//
//  MessageManager.m
//  lhProject
//
//  Created by 张晓燕 on 14-7-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "MessageManagerForDB.h"
#import "Utility.h"
#import "JsonData.h"
#import "SBJson.h"
#import "AESCrypt.h"
#import "GlobalModel.h"
const NSInteger number = 8;

@implementation MessageManagerForDB

-(id)init{
    lock = [[NSLock alloc] init];
    return [super init];
}
-(void)dealloc{
    [lock release];
    lock = nil;
    [super dealloc];
}

+ (MessageManagerForDB *)sharedInstance {
    static MessageManagerForDB* selModel = nil;
    if (!selModel) {
        selModel = [[MessageManagerForDB alloc] init];
    }
    return selModel;
}

-(void)StatDbOpen{
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/DataBase/Sqlite/Client.sqlite"] ;//单例模式
    database= [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        EBLog(@"Could not open db.");
        database =  nil;
    }
}
-(void)endDbOpen{
    [database close];
}

#pragma  mark 更新或插入数据
+(BOOL)UpOrInsertData:(NSString*)Sql{
    [MESSAGE_MANAGER_FOR_DB StatDbOpen];
    BOOL  isOk=[MESSAGE_MANAGER_FOR_DB _UpOrInsertData:Sql];
    [MESSAGE_MANAGER_FOR_DB endDbOpen];
    return isOk;
}

-(BOOL)_UpOrInsertData:(NSString*)Sql{
    [lock lock];
    BOOL  isOk=[database executeUpdate:Sql];
    [lock unlock];
    return isOk;
}

#pragma mark--数据库建表

+(void)createMessageTable:(NSString *)tableName
{
    [MessageManagerForDB UpOrInsertData:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY, USERID INTEGER, content TEXT);",tableName]];
}

#pragma mark--保存数据
+(void)saveMessageListToDB:(NSArray *)messageArray tableName:(NSString *)tableName
{
    for (NSDictionary *dic in messageArray) {
        
        [MessageManagerForDB saveMessageToDB:dic tableName:tableName];
    }
}
+(void)saveMessageToDB:(NSDictionary *)msgDic tableName:(NSString *)tableName
{
    
    NSString *newEncryptedPWD = [AESCrypt encrypt:[msgDic JSONRepresentation] password:[NSString stringWithFormat:@"%ld",(long)[GlobalModel userid]]];
    NSDictionary *dic = [MessageManagerForDB retrieveMessageSById:[msgDic strValue:@"messageid"] tableName:tableName];
    if (dic && [dic isEqualToDictionary:msgDic]) {
        EBLog(@"信息已存在，不需要再保存在数据库！");
        return;
    }
    //新获得的信息未发生改变，或者不存在则保存在数据库中。
    //删除存在数据库中信息内容有更新的短信息
    [MessageManagerForDB deleteMessageById:[msgDic strValue:@"messageid"] tableName:tableName];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(%ld,%ld,'%@');",tableName,(long)[msgDic intValue:@"messageid"],[GlobalModel userid],newEncryptedPWD];
    [MessageManagerForDB UpOrInsertData:sql];
    
}

#pragma mark --获取所有信息列表(只获取当前用户)
+(NSArray *)retrieveAllMessageWithTableName:(NSString *)tableName
{
    //desc降序排序（asc升序排序）
        return [MESSAGE_MANAGER_FOR_DB retrieveMessageSBySql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE USERID=%ld ORDER BY ID DESC",tableName,[GlobalModel userid]]];
}
+(NSArray *)retrieveMessagesWithTableName:(NSString *)tableName page:(NSInteger)page//获取一段数据
{
    return [MESSAGE_MANAGER_FOR_DB retrieveMessageSBySql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE USERID=%ld ORDER BY ID DESC LIMIT %ld,%ld",tableName,(long)[GlobalModel userid],page * number,(long)number]];
}
-(NSArray *)retrieveMessageSBySql:(NSString *)sql
{
    [MESSAGE_MANAGER_FOR_DB StatDbOpen];
    NSArray *tmpArray = [MESSAGE_MANAGER_FOR_DB _retrieveMessageSBySql:sql];
    [MESSAGE_MANAGER_FOR_DB endDbOpen];
    return tmpArray;
}
+(NSDictionary *)retrieveMessageSById:(NSString *)msgId tableName:(NSString *)tableName
{
        
        return [[MESSAGE_MANAGER_FOR_DB retrieveMessageSBySql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID=%ld AND USERID=%ld ORDER BY ID DESC",tableName,(long)[msgId integerValue],(long)[GlobalModel userid]]] lastObject];
  
}
-(NSArray *)_retrieveMessageSBySql:(NSString *)sql
{
    [lock lock];
    FMResultSet *results = [database executeQuery:sql];
    [lock unlock];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:1];
    while([results next]) {
        
        NSString *jsonStr = [AESCrypt decrypt:[results stringForColumnIndex:2] password:[NSString stringWithFormat:@"%ld",(long)[GlobalModel userid]]];//取第二列的json串
        JsonData *json = [[[JsonData alloc] initWithString:jsonStr] autorelease];
        NSObject *object = [json dictValue:nil];
        if (object) {
            [dataArray addObject:object];
        }
        
    }
    return dataArray;
}
//获取信息的个数
+(int)getMessageColsCountWithTableName:(NSString *)tableName
{
        
        [MESSAGE_MANAGER_FOR_DB StatDbOpen];
        int messageCount = [MESSAGE_MANAGER_FOR_DB _getMessageColsCount:[NSString stringWithFormat:@"SELECT COUNT(*) AS NUM FROM %@ WHERE USERID=%ld",tableName,(long)[GlobalModel userid]]];
        [MESSAGE_MANAGER_FOR_DB endDbOpen];
        return messageCount;
    
}
-(int)_getMessageColsCount:(NSString*)sql{
    [lock lock];
    FMResultSet *results = [database executeQuery:sql];
    [lock unlock];
    int num = 0;
    while([results next]) {
        num  = [[results stringForColumn:@"num"]intValue];
    }
    return num;
}
//通过messageid删除信息
+(void)deleteMessageById:(NSString *)msgId tableName:(NSString *)tableName
{
     
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=%ld AND USERID=%ld",tableName,(long)[msgId integerValue],(long)[GlobalModel userid]];
        [MessageManagerForDB UpOrInsertData:sql];
}
//通过messageid
+(void)deleteMessageByIdArray:(NSArray *)msgIdArray tableName:(NSString *)tableName
{
    for (NSString *msgId in msgIdArray) {
        [MessageManagerForDB deleteMessageById:msgId tableName:tableName];
    }
}
//删除所有的数据
+(void)deleteAllMessageWithTableName:(NSString *)tableName
{
    //删除表(下一次执行的时候会再创建表)
    
        [MessageManagerForDB UpOrInsertData:[NSString stringWithFormat:@"DELETE FROM %@ WHERE USERID=%ld",tableName,(long)[GlobalModel userid]]];
}
@end
