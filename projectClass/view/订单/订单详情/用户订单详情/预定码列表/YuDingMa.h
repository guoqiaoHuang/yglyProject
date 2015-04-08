//
//  YuDingMa.h
//  yglyProject
//
//  Created by 枫 on 14-11-14.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailsView.h"

@protocol YuDingMaDelegate;

@interface YuDingMa : UIView

@property(nonatomic,readonly) UILabel *passwordLabel;
@property(nonatomic,readonly) UIButton *erWeiMaButton;
@property(nonatomic,readonly) UILabel *stateLabel;
@property(nonatomic,readonly) NSMutableString *erWeiMaStr;
@property(nonatomic,assign) id<YuDingMaDelegate> delegate; //确保是OrderDetailsView对象

+(YuDingMa *)createYuDingMaWithDict:(NSDictionary *)dict frame:(CGRect)frame;
-(void)handleTap;//关闭二维码
@end

@protocol YuDingMaDelegate <NSObject>
@optional
-(void)erWeiMaDidShow:(YuDingMa *)yuDingMa;
-(void)erWeiMaDidHidden:(YuDingMa *)yuDingMa;

@end