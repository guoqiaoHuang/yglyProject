//
//  MessageManager.h
//  lhProject
//
//  Created by 张晓燕 on 14-7-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface MessageManagerForDB : NSObject
{
    NSLock *lock;
    FMDatabase *database;
}
+ (MessageManagerForDB *)sharedInstance;
//创建表
+(void)createMessageTable:(NSString *)tableName;//创建表
//保存一条信息,该信息会与数据库中已有的数据对比，如果有所差异，则会更新该信息（先delete,然后 insert）
+(void)saveMessageToDB:(NSDictionary *)msgDi tableName:(NSString *)tableName;
//保存一组信息
+(void)saveMessageListToDB:(NSArray *)messageArray tableName:(NSString *)tableName;
//获取所有的信息
+(NSArray *)retrieveAllMessageWithTableName:(NSString *)tableName;
//获取指定页数的数据
+(NSArray *)retrieveMessagesWithTableName:(NSString *)tableName page:(NSInteger)page;//获取一段数据
//获取特定id的一条信息
+(NSDictionary *)retrieveMessageSById:(NSString *)msgId tableName:(NSString *)tableName;
//获取信息的个数
+(int)getMessageColsCountWithTableName:(NSString *)tableName;
//通过messageid删除信息
+(void)deleteMessageById:(NSString *)msgId tableName:(NSString *)tableName;
//通过messageidArray删除一组信息
+(void)deleteMessageByIdArray:(NSArray *)msgIdArray tableName:(NSString *)tableName;
//删除所有的数据
+(void)deleteAllMessageWithTableName:(NSString *)tableName;
@end
