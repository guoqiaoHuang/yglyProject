//
//  ReplyMsgView.m
//  yglyProject
//
//  Created by 枫 on 14-11-4.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ReplyMsgView.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "LHMLEmojiLabel.h"

//长度会发生改变
static CGFloat lastMaxY = 0;
static NSInteger nowIndex = 0;

@implementation ReplyMsgView
//因为key值不能重复，所以需要服务器或者外界在key的后边添加一些特殊的字符来加以区分，而在在现实的时候，再还原
+(ReplyMsgView *)createReplyMsgViewWithDict:(NSDictionary *)dict
                                      frame:(CGRect)frame
                                     method:(NSString *)method
                                     target:(id)target
                                    tagDict:(NSDictionary *)tagDict{
    
    ReplyMsgView *model = [[[ReplyMsgView alloc] initWithFrame:frame] autorelease];
    NSArray *keyArray = [dict allKeys];
    
    for (NSString *key in keyArray) {
        
        NSString *value = [dict strValue:key];
        [model createKeyLabel:key valueLabel:value atview:model method:method target:self tag:[tagDict intValue:key]];
    }
    lastMaxY = 0;
    return model;
    
}

-(void)createKeyLabel:(NSString *)key
           valueLabel:(NSString *)value
               atview:(ReplyMsgView *)view
               method:(NSString *)method
               target:(id)target
                tag:(NSInteger)tag{
    
        
        //添加keybutton
    NSMutableString *str = [NSMutableString stringWithString:key];
    //预留需要对str所做的处理
    [str appendString:@": "];
    UIButton *btn = [view createColorButtonWithText:str fontSize:YGLY_VIEW_FLOAT(26) textColor:[UIColor blueColor] method:method target:target tag:tag];
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:[Utility hexStringToColor:@"#30629a"] forState:UIControlStateNormal];
    CGRect btnRect = btn.frame;
    btnRect.origin.y = lastMaxY;
    btn.frame = btnRect;
    [view addSubview:btn];
        
    CGFloat btnW = CGRectGetWidth(btn.frame);
    CGFloat btnMaxX = CGRectGetMaxX(btn.frame);
    
    //添加valueEmjlabel
    LHMLEmojiLabel *valueLabel = [view createLabelWithText:value
                                                  fontSize:YGLY_VIEW_FLOAT(26)
                                                 textColor:[UIColor blackColor]];
    
    CGRect labelRect = {{btnMaxX, lastMaxY},{CGRectGetWidth(self.frame) - btnW,40}};
    valueLabel.frame = labelRect;
    [view addSubview:valueLabel];
     [valueLabel sizeToFit];
    
        
    lastMaxY = CGRectGetMaxY(valueLabel.frame) + YGLY_VIEW_FLOAT(20);
    CGRect frame = view.frame;
    frame.size.height = lastMaxY;
    view.frame = frame;
    
}


#pragma mark 重新计算高度 - for colorBtn
-(UIButton *)createColorButtonWithText:(NSString *)text
                        fontSize:(CGFloat)fontSize
                       textColor:(UIColor*)color
                          method:(NSString *)method
                          target:(id)target
                             tag:(NSInteger)tag{

    //重新计算frame
    CGSize contentSize = CGSizeZero;
    NSString *tmpStr = @"abcde...: ";
    contentSize = [Utility getSizeFormString:tmpStr maxW:MAXFLOAT font:[UIFont systemFontOfSize:fontSize]];
    CGRect butRect = {CGPointZero,contentSize};
    
    ACPButton *button = [ACPButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = butRect;
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    SEL method1 = NSSelectorFromString(method);
    if (method1) {
        [button addTarget:target action:method1 forControlEvents:UIControlEventTouchUpInside];
    }
    button.tag = tag;
    
    return button;
}
-(LHMLEmojiLabel *)createLabelWithText:(NSString *)text
                              fontSize:(CGFloat)fontSize
                             textColor:(UIColor*)color{
    

    LHMLEmojiLabel *emojiLabel = [[[LHMLEmojiLabel alloc] init] autorelease];
    emojiLabel.numberOfLines = 0;
    emojiLabel.font = [UIFont systemFontOfSize:fontSize];
   // emojiLabel.emojiDelegate = self;
    emojiLabel.textAlignment = NSTextAlignmentLeft;
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    
    [emojiLabel setEmojiText:text];
    [emojiLabel setTextColor:color];
    
    return emojiLabel;
}


-(void)setWithDict:(NSArray *)array
            method:(NSString *)method
            target:(id)target
           {
    
//    NSArray *keyArray = [dict allKeys];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for (NSString *key in keyArray) {
//        
//        NSString *value = [dict strValue:key];
//        [self createKeyLabel:key valueLabel:value atview:self method:method target:target tag:[tagDict intValue:key]];
//    }
//    
//    
    for (NSDictionary*d in array) {
       [self createKeyLabel:[d objectForKey:@"username"] valueLabel:[d objectForKey:@"content"] atview:self method:method target:target tag:[d intValue:@"userid"]];
    }
    lastMaxY = 0;
}


@end
