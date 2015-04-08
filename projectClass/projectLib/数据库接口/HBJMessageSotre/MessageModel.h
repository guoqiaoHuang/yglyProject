//
//  MessageModel.h
//  lhProject
//
//  Created by 张晓燕 on 14-7-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,copy) NSString *content;
@property(nonatomic,assign) NSInteger del_type;
@property(nonatomic,copy) NSString *folder;
@property(nonatomic,assign) NSInteger message_time;
@property(nonatomic,assign) NSInteger messageid;
@property(nonatomic,assign) NSInteger reply_num;
@property(nonatomic,assign) NSInteger replyid;
@property(nonatomic,copy) NSString *send_from_id;
@property(nonatomic,copy) NSString *send_to_id;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,copy) NSString *subject;


@end
