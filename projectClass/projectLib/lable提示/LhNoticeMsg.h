//
//  SF2ViewController.h
//  StickFigureSecond
//
//  Created by dev_lei on 13-4-15.
//  Copyright (c) 2013年 dev_lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHMLEmojiLabel.h"
@interface LhNoticeMsg : UIView<LHMLEmojiLabelDelegate>{
    NSMutableArray*dataMsg;
    UIView*bg;
    LHMLEmojiLabel*title;
    float times;
    float frontsize;
    float bianJu;
    CGPoint Centerpoint;
    int alertMaxWid;
    int alertMinWid;
    int MsgMAx;
}
@property(nonatomic,retain) NSMutableArray *dataMsg;
@property(nonatomic,assign) CGPoint Centerpoint;
@property (nonatomic, retain) UIViewController *Controller;
+ (LhNoticeMsg*)sharedInstance;
-(void)ShowMsg:(NSString*)msg;
-(void)ClearBeforeShowNow:(NSString*)msg;
+(void)hideView;
@end


