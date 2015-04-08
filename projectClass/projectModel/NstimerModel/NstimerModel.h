//
//  GlobalModel.h
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NstimerModel : NSObject{
    NSTimer*timer;
    float tmpAllTimes;
}
@property(nonatomic,retain)  NSMutableDictionary* delegates;

+(NstimerModel*)sharedNstimerModel;
+(void)addObejct:(id)object time:(float)time;
+(void)removeObejct:(id)object;
@end

/*
 用法说明：
 添加:[NstimerModel addObejct:self time:7];
 同一个对象最好不要添加两个，如要添加两个 那摩时间必须保持不一致，否则会把第一个覆盖
 删除时候需要手动清除：[NstimerModel removeObejct:self];不能放在dealloc
 */
