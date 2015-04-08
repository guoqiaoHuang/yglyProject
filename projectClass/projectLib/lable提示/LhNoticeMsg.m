//
//  SF2ViewController.m
//  StickFigureSecond
//
//  Created by dev_lei on 13-4-15.
//  Copyright (c) 2013年 dev_lei. All rights reserved.
//
#import  "LhNoticeMsg.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "MainViewController.h"
@implementation LhNoticeMsg
@synthesize dataMsg;
@synthesize Centerpoint;
@synthesize Controller;
+ (LhNoticeMsg*)sharedInstance {
    static LhNoticeMsg* shareView = nil;
    if (!shareView) {
        shareView = [[LhNoticeMsg alloc] initWithFrame:[MainViewController sharedViewController].view.bounds];
        shareView.Controller = [MainViewController sharedViewController];
        shareView.dataMsg = [NSMutableArray arrayWithCapacity:0];
        shareView.backgroundColor = [UIColor clearColor];
        [[MainViewController sharedViewController].view insertSubview:shareView atIndex:20];
        shareView.center = shareView.Controller.view.center;
//        shareView.userInteractionEnabled = !shareView.userInteractionEnabled;
    }
    return shareView;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if([Utility getNode].isIpad){
        times = 2.0;
        frontsize = 20.0;
        bianJu = 12;
        alertMaxWid = 160;
        alertMinWid = 40;
        MsgMAx = 20;
    }else{
        times = 2.0;
        frontsize = 12.0;
        bianJu = 7;
        
        alertMaxWid = 100;
        alertMinWid = 25;
        MsgMAx = 30;
    }
    if(self){
        bg = [[[ UIView alloc]init]autorelease];
        
        bg.backgroundColor = [Utility hexStringToColor:@"999999"];//[UIColor blackColor];
        bg.alpha = 0.7;
        bg.layer.cornerRadius = [Utility getNode].isIpad?8:6;//设置那个圆角的有多圆
        bg.layer.masksToBounds = YES;//设为NO去试试
        [self addSubview:bg];
        
        title = [[LHMLEmojiLabel alloc]init];
        title.numberOfLines = 0;
        title.emojiDelegate = self;
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = [UIColor clearColor];
        title.lineBreakMode = NSLineBreakByCharWrapping;
        title.isNeedAtAndPoundSign = YES;
        title.font = [UIFont fontWithName:@"Helvetica" size:frontsize];
        title.textColor = [UIColor whiteColor];
        title.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        title.customEmojiPlistName = @"expressionImage_custom.plist";
        [self addSubview:title];
    }
    return self;
}
-(void)ShowMsg:(NSString*)msg{
    if(!msg.length){
        return;
    }
    if(self.dataMsg.count > MsgMAx){
        [self.dataMsg removeAllObjects];
    }
    
    if (self.dataMsg.count >= 1) {
        if(![[self.dataMsg lastObject] isEqualToString:msg]){
            [self.dataMsg addObject:msg];
        }
    }else{
        [self.dataMsg addObject:msg];
    }
    if(self.dataMsg.count == 1)[self StatShow];
}


-(void)ClearBeforeShowNow:(NSString*)msg{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.dataMsg removeAllObjects];
    [self.dataMsg addObject:msg];
    [self StatShow];
}

-(void)StatShow{
    self.hidden = YES;
    if(![self changeVieFrame]){
        return;
    }
    self.hidden = NO;
//    [self fadeIn];
    [self performSelector:@selector(stopAlert) withObject:Nil afterDelay:times/self.dataMsg.count];
}

-(void)stopAlert{
    [self fadeOut];
    [LhNoticeMsg hideView];
    if(self.dataMsg.count){
        [self.dataMsg removeObjectAtIndex:0];
        [self performSelector:@selector(StatShow) withObject:Nil afterDelay:0.5];
    }
}

-(BOOL)changeVieFrame{
    NSString*msg;
    if(self.dataMsg.count){
        msg = [[self.dataMsg objectAtIndex:0]copy];
    }else{
        self.hidden = YES;
        return NO;
    }
    float width = msg.length*frontsize+2*bianJu;
    int hig = width/alertMaxWid;
    if(width > hig*alertMaxWid){
        hig++;
    }
    if(hig) width = alertMaxWid;
    title.frame = CGRectMake(bianJu,bianJu,width,(frontsize+3)*hig);
    [title setEmojiText:msg];
    [title sizeToFit];
    title.size = CGSizeMake(title.size.width, title.size.height*1.2);
    bg.size = CGSizeMake(title.size.width+2*bianJu, title.size.height+2*bianJu);
    self.size = bg.size;
    self.center = self.Controller.view.center;
    return  YES;
}

-(void)end{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.hidden = YES;
}


+(void)hideView{
    [[LhNoticeMsg sharedInstance] end];
}

- (void)mlEmojiLabel:(LHMLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(LHMLEmojiLabelLinkType)type{
    switch(type){
        case LHMLEmojiLabelLinkTypeURL:
            EBLog(@"点击了链接%@",link);
            break;
        case LHMLEmojiLabelLinkTypePhoneNumber:
            EBLog(@"点击了电话%@",link);
            break;
        case LHMLEmojiLabelLinkTypeEmail:
            EBLog(@"点击了邮箱%@",link);
            break;
        case LHMLEmojiLabelLinkTypeAt:
            EBLog(@"点击了用户%@",link);
            break;
        case LHMLEmojiLabelLinkTypePoundSign:
            EBLog(@"点击了话题%@",link);
            break;
        default:
            EBLog(@"点击了不知道啥%@",link);
            break;
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [LhNoticeMsg hideView];
    [self.dataMsg removeAllObjects];
}
@end

