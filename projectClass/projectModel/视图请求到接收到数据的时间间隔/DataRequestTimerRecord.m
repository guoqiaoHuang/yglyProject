//
//  DataRequestTimerRecord.m
//  yglyProject
//
//  Created by 枫 on 14-12-5.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DataRequestTimerRecord.h"

static DataRequestTimerRecord *shareInstance = nil;
@implementation DataRequestTimerRecord

- (void)dealloc{
    
    self.plistFile = nil;
    self.dictionary = nil;
    self.path = nil;
    [super dealloc];
}
+ (DataRequestTimerRecord*)sharedDataRequestTimerRecord{
    
    if (!shareInstance) {
        shareInstance = [[DataRequestTimerRecord alloc] init];
         shareInstance.plistFile =  [NSString stringWithFormat:@"%@.plist",[self class]];
    }
    return shareInstance;
}

- (void)beginRequestTimeWithApi:(NSString *)api uniqueAPI:(NSString *)uniqueAPI{
    
    
        NSMutableArray *tmpArray = [NSMutableArray array];
        if (!self.dictionary) {
            self.dictionary = [[[NSMutableDictionary alloc] init] autorelease];
        }
        id obj = [self.dictionary objectForKey:api];
        if (obj && [obj isKindOfClass:[NSArray class]]) {
            [tmpArray addObjectsFromArray:obj];
        }
    
        NSDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"start":[NSDate date],
                                                                         @"end":uniqueAPI,
                                                                         @"interval":@""}];
        [tmpArray addObject:dict];
        [self.dictionary setValue:tmpArray forKey:api];
    [self.dictionary writeToFile:_path atomically:YES];
}
- (void)endRequestTimeWithApi:(NSString *)api uniqueAPI:(NSString *)uniqueAPI{
   
//    @synchronized(self){
    
        id obj = [self.dictionary objectForKey:api];
        if (obj && [obj isKindOfClass:[NSArray class]]) {
            
            for (NSInteger i = [obj count]-1; i >= 0; i--) {
                
                NSMutableDictionary *dict = obj[i];
                if (dict[@"end"] && [dict[@"end"] isKindOfClass:[NSString class]] &&
                    [dict[@"end"] isEqualToString:uniqueAPI]) {
                    [dict setValue:[NSDate date] forKey:@"end"];
                    [dict setValue:[NSNumber numberWithFloat:[dict[@"end"] timeIntervalSinceDate:dict[@"start"]]] forKey:@"interval"];
                    break;
                }
            }
        }
    [self.dictionary writeToFile:_path atomically:YES];
}

#pragma mark - property
-(void)setPlistFile:(NSString *)plistFile{
    if (plistFile){
        if (_plistFile) {
            [_plistFile release];
            _plistFile = nil;
        }
        _plistFile = [plistFile retain];
        [self loadPlistFile];
    }else{
        EBLog(@"plistFile should not be nil!");
    }
    
}
-(void)loadPlistFile{
    if (_plistFile == nil){
        
    }else{
        NSString *documentPath = [pathFolder sharePathFolder].folder ;//单例模式
        if(documentPath){
            self.path = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"timeApi/%@",_plistFile]];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:_path]){
            if ([[NSFileManager defaultManager] createDirectoryAtPath:[documentPath stringByAppendingPathComponent:@"timeApi/"] withIntermediateDirectories:YES attributes:nil error:nil]) {
                
                EBLog(@"创建文件成功");
            }
            EBLog(@"file: %@ not exist!",_path);
        }else{
            self.dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_path];
           // EBLog(@"plistFile %@",self.dictionary);
        }
    }
}

@end
