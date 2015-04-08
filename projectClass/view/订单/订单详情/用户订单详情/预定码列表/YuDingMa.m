//
//  YuDingMa.m
//  yglyProject
//
//  Created by 枫 on 14-11-14.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "YuDingMa.h"
#import "BaseUIImageView.h"
#import "MainViewController.h"
#import "QREncoder.h"
#import "EnlargeImageDoubleTap.h"
#import "HBJUIImage.h"

@interface YuDingMa ()
{
}
@end

@implementation YuDingMa
-(void)dealloc{
    [_erWeiMaStr release];_erWeiMaStr = nil;
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict{
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = frame.size.width;
        CGRect stateRect = {{width/YGLY_SIZE_SCALE-120,0},{100,65}};
        _stateLabel = [[[UILabel alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(stateRect)] autorelease];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(30)];
        _stateLabel.textColor = [Utility hexStringToColor:@"#a3a3a3"];
        if ([dict[@"state"] intValue] == 0) {
           _stateLabel.text = @"未验证";
        }else{
            _stateLabel.text = @"已验证";
        }
        [self addSubview:_stateLabel];
        
        _erWeiMaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _erWeiMaButton.frame = YGLY_VIEW_FRAME_ALL(CGRectMake(width/YGLY_SIZE_SCALE-120-65, 0, 65, 65));
        [_erWeiMaButton setImage:[Utility getImageByName:@"二维码默认.png"] forState:UIControlStateNormal];
        [_erWeiMaButton setImage:[Utility getImageByName:@"二维码按下.png"] forState:UIControlStateHighlighted];
        [_erWeiMaButton addTarget:self action:@selector(openErWeiMa:) forControlEvents:UIControlEventTouchUpInside];
        _erWeiMaButton.enabled = ![dict[@"state"] intValue];
        _erWeiMaButton.userInteractionEnabled = ![dict[@"state"] intValue];
        [self addSubview:_erWeiMaButton];
        
        CGRect passwordRect = {{20,0},{width/YGLY_SIZE_SCALE-120-65-40,65}};
        _passwordLabel = [[[UILabel alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(passwordRect)]autorelease];
        _passwordLabel.backgroundColor = [Utility hexStringToColor:@"#a6c9ed"];
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.textColor = [UIColor blackColor];
        
        NSString *passwordStr = [dict strValue:@"password"];
        _erWeiMaStr = [[NSMutableString alloc] initWithString:passwordStr];
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int i = 0; i < passwordStr.length; i++) {
            
            if (i % 4 == 0) {
                
                NSRange range = NSMakeRange(i, 4);
                if ((range.location + range.length) > passwordStr.length) {
                    
                    range.length = passwordStr.length - range.location;
                }
                [tmpArray addObject:[passwordStr substringWithRange:range]];
            }
        }
        passwordStr = [tmpArray componentsJoinedByString:@" "];
        _passwordLabel.text = [NSString stringWithFormat:@"密码：%@",passwordStr];
        [self addSubview:_passwordLabel];
        
    }
    return self;
}

+(YuDingMa *)createYuDingMaWithDict:(NSDictionary *)dict frame:(CGRect)frame{
   
    return [[[YuDingMa alloc] initWithFrame:frame dict:dict] autorelease];
}
-(void)openErWeiMa:(UIButton *)sender{
    
    UIImage *erWeiMaImage = [QREncoder encode:_erWeiMaStr];
    if (!erWeiMaImage) {
        return;
    }
    NSDictionary *dict = @{@"position":@"{100,300}",
                           @"position_Iphone4":@"{100,300}",
                           @"position_Iphone5":@"{100,300}",
                           @"position_Iphone6":@"{100,300}",
                           @"image":erWeiMaImage,
                           @"isImage":@"1"};
    EnlargeImageDoubleTap *t = [BaseUIImageView setEnlargeImageDoubleTapWithDict:dict];
    for (UIView *view in [MainViewController sharedViewController].view.subviews) {
        
        if ([view isKindOfClass:[EnlargeImageDoubleTap class]]) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    [[MainViewController sharedViewController].view addSubview:t];
    t.hidden = YES;
    [t handleDoubleTap:t.doubleTapRecognize];
    
    CGFloat qrSize = 220;
    t.imageBackground.frame = CGRectMake(0, 0,
                                         qrSize, qrSize);
    [t.imageBackground layer].magnificationFilter = kCAFilterNearest;
    t.imageBackground.center = [MainViewController sharedViewController].view.center;
//    t.complete = ^{
//        
//        id delegate = _delegate;
//        if (delegate && [delegate respondsToSelector:@selector(erWeiMaDidHidden:)]) {
//            
//            [delegate erWeiMaDidHidden:self];
//        }
//    };
    
    if (_delegate && [_delegate respondsToSelector:@selector(erWeiMaDidShow:)]) {
        
        [_delegate erWeiMaDidShow:self];
    }
}

-(void)handleTap{//关闭二维码
    
    if (_erWeiMaButton.enabled) {
        
        for (UIView *view in [MainViewController sharedViewController].view.subviews) {
            
            if ([view isKindOfClass:[EnlargeImageDoubleTap class]]) {
                [((EnlargeImageDoubleTap *)view) handleTap];
            }
        }
    }
}
@end
