//
//  MessageModel.m
//  lhProject
//
//  Created by 张晓燕 on 14-7-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

@synthesize content;
@synthesize del_type;
@synthesize folder;
@synthesize message_time;
@synthesize messageid;
@synthesize reply_num;
@synthesize replyid;
@synthesize send_from_id;
@synthesize send_to_id;
@synthesize status;
@synthesize subject;

-(void)dealloc
{
    [content release];
    [folder release];
    [send_from_id release];
    [send_to_id release];
    [subject release];
    
    [super dealloc];
}

@end
