//
//  BodyModel.h
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyModel : UIView

//--style=0  左右样式
//--style=1  上下样式
//--style = 2 左右样式，左边加粗,左右两边文本都为黑色
//---style = 3 会在keyLabel 前加一个小图标
+(BodyModel *)createBodyModelWithDict:(NSDictionary *)dict frame:(CGRect)frame style:(NSInteger)style;
+(BodyModel *)createBodyModelWithDict:(NSDictionary *)dict frame:(CGRect)frame;

-(void)setWithDict:(NSDictionary *)dict;
@end
