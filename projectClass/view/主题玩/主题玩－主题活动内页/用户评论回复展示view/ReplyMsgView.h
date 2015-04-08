//
//  ReplyMsgView.h
//  yglyProject
//
//  Created by 枫 on 14-11-4.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyMsgView : UIView

+(ReplyMsgView *)createReplyMsgViewWithDict:(NSDictionary *)dict
                                      frame:(CGRect)frame
                                     method:(NSString *)method
                                     target:(id)target
                                    tagDict:(NSDictionary *)tagDict;
-(void)setWithDict:(NSArray *)array
            method:(NSString *)method
            target:(id)target;

@end
