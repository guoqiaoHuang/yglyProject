//
//  VerificationCodeCheckView.m
//  yglyProject
//
//  Created by 枫 on 14-11-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "VerificationCodeCheckView.h"
#import "MainViewController.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"

@interface VerificationCodeCheckView ()<VIewDadaGetDelegate>

@end
@implementation VerificationCodeCheckView

-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_dingdan_shanghu_yanzheng]) {
        
        [self dismissLoadMsg];
        [[LhNoticeMsg sharedInstance] ShowMsg:@"验证成功"];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [self dismissLoadMsg];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"验证失败"];
}
#pragma mark -
-(void)showView{
    
    [super showView];
    
    [self showUITextFieldList:@"UITextFields" index:0];
    textF = (UITextField *)[self viewWithTag:1611];
    textF.delegate = self;
    [self showColorButtonList:@"ColorButtons" index:0];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
-(void)checkBtnClicked:(id)sender{
    
    [[VIewDadaGet sharedGameModel] DingDanForYanZheng:textF.text type:2 delegate:self];
    [self showLoadMsg:@"正在验证..."];
    //验证
}

-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}
@end
