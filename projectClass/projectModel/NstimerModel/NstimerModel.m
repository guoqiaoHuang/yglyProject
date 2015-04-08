//
//  GlobalModel.m
//  VenusIphone
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NstimerModel.h"
#import "NetDefine.h"
@implementation NstimerModel

@synthesize delegates;

static NstimerModel *shareNstimerModel = nil;
+ (NstimerModel*)sharedNstimerModel{
	if (!shareNstimerModel)
    {
		shareNstimerModel = [[NstimerModel alloc] init];
        shareNstimerModel.delegates = [NSMutableDictionary dictionaryWithCapacity:10];
        [shareNstimerModel start];
	}
	return shareNstimerModel;
}

+(void)addObejct:(id)object time:(float)time{
    [[NstimerModel sharedNstimerModel] addObejct:object time:time];
}

+(void)removeObejct:(id)object{
    NSArray*arrayKeys = [[NstimerModel sharedNstimerModel].delegates allKeys];
    NSString*key;
    for (int i = 0 ; i < arrayKeys.count; i++) {
        key = arrayKeys[i];
        id ob = [[NstimerModel sharedNstimerModel].delegates objectForKey:key];
        if ([object isEqual:ob]) {
            [[NstimerModel sharedNstimerModel].delegates removeObjectForKey:key];
            return;
        }
    }
}
-(void)start{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    tmpAllTimes = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction:) userInfo:nil repeats:YES];
}
-(void)updateAction:(NSTimer *)theTimer{
    tmpAllTimes += [theTimer timeInterval];
    NSArray*arrayKeys = [delegates allKeys];
    NSString*key;
    NSString*time;
    NSString*class;
    NSString* delegate;
    long numsize  = 0;
    float tDiff = 0.0;
    for (int i = 0 ; i < arrayKeys.count; i++) {
        key = [arrayKeys objectAtIndex:i];
        delegate = [delegates objectForKey:key];
        class = [NSString stringWithFormat:@"%@:%p:",[delegate class],delegate];
        time = [key substringWithRange:NSMakeRange(class.length,key.length - class.length)];
        numsize = tmpAllTimes/[time floatValue];
        tDiff = tmpAllTimes - numsize*[time floatValue];
        if(tDiff < [theTimer timeInterval]){
            if(delegate && [delegate respondsToSelector:@selector(updateAction)]){
                EBLog(@"updateAction:%f",tmpAllTimes);
                [delegate performSelector:@selector(updateAction) withObject:nil];
            }
        }
    }
}

-(void)addObejct:(id)object time:(float)time{
    NSString*keyS = [NSString stringWithFormat:@"%@:%p:%f",[object class],object,time];
    [delegates removeObjectForKey:keyS];
    [delegates setObject:object forKey:keyS];
}

@end
