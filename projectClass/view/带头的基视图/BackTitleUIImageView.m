//
//  BaseBaseUIImageView.m
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "Utility.h"
#import "MapView.h"
#import "MapButton.h"

@implementation BackTitleUIImageView



-(void)showView{
    
     self.backgroundColor = [UIColor whiteColor];
    [self showUIViewList:@"BackTitleBaseUIViews" index:0];
    [super showView];
    UIView *view = [self viewWithTag:511];
    [view makeInsetShadowWithRadius:3 Color:[UIColor grayColor] Directions:[NSArray arrayWithObjects:@"bottom", nil]];
    [self showUILabelList:@"BackTitleUILabel" index:0];
    [self showButtonList:@"BackTitleButtons" index:0];
    [self showColorButtonList:@"BackTitlecolorButtons" index:0];
}

#pragma mark- 进入地图
-(void)gotoMapBtn:(UIButton *)sender{
    
    NSMutableArray *btnArray = [NSMutableArray array];
    MapView*t = [MapView alloc];
    if ([sender isKindOfClass:[MapButton class]]) {
        
        for (UIView *view in sender.superview.subviews) {
            
            if ([view isKindOfClass:[MapButton class]]) {
                if ([view isEqual:sender]) {
                    [btnArray insertObject:view atIndex:0];
                }else{
                    [btnArray addObject:view];
                }
            }
        }
    }else{
        [btnArray addObject:sender];
    }
     t.btnArray = btnArray;
    [[t initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}
-(CATransition*)getPush{
    if ([Utility getNode].isIpad) {
        return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromRight];
    }else{
        return [super getPush];
    }
    
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    if ([Utility getNode].isIpad) {
        return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
    }else{
        return [super getPopo];
    }
    
}


@end
