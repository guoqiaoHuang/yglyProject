//
//  DataRequestTimerRecord.h
//  yglyProject
//
//  Created by 枫 on 14-12-5.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataRequestTimerRecord : NSObject

@property(nonatomic,retain)NSMutableDictionary *dictionary;
@property(nonatomic,retain)NSString *plistFile;
@property(nonatomic,retain)NSString *path;

+ (DataRequestTimerRecord*)sharedDataRequestTimerRecord;
- (void)beginRequestTimeWithApi:(NSString *)api uniqueAPI:(NSString *)uniqueAPI;
- (void)endRequestTimeWithApi:(NSString *)api uniqueAPI:(NSString *)uniqueAPI;
@end
