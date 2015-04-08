//
//  TravelingModel.m
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

//行程说明cell会重新计算高度，大小不变
#import "TravelingModel.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "LhUIView.h"
#import "BodyModel.h"
/* key-value
NSDictionary *dic = @{@"lineColor":@"",
                      @"headBGColor":@"",
                      @"leftImage":@"",
                      @"rightImageNormal":@"",@"rightImageHighlight":@"",@"method":@"",@"target":@"",
                      @"headText":@"",
                      @"bodyDict":@"",};
*/


@implementation TravelingModel

+(TravelingModel *)createTravelingModelWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    TravelingModel *model = [[[TravelingModel alloc] initWithFrame:frame] autorelease];
    model.backgroundColor = [UIColor whiteColor];
    
    //一个像素的线的颜色
    NSString *lineColor = [dict strValue:@"lineColor" default:@"#9c9c9c"];
    NSString *headBGColor = [dict strValue:@"headBGColor" default:@"ececec"];
    CGFloat width = CGRectGetWidth(frame)/YGLY_SIZE_SCALE;
    //添加头部背景颜色view
    UIView *view = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 0, width, 75))] autorelease];
    view.backgroundColor = [Utility hexStringToColor:headBGColor];
    [model addSubview:view];
    //添加两条线
    UIView *line1 = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 0, width, 1))] autorelease];
    line1.backgroundColor = [Utility hexStringToColor:lineColor];
    [model addSubview:line1];
    
    UIView *line2 = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 74, width, 1))] autorelease];
    line2.backgroundColor = [Utility hexStringToColor:lineColor];
    [model addSubview:line2];
    
    
    if ([dict strValue:@"leftImage"]) {
        
        UIImageView *imageView = [Utility getUIImageViewByName:[dict strValue:@"leftImage"]];
        CGSize imageSize = imageView.frame.size;
        imageView.point = CGPointMake(YGLY_VIEW_FLOAT(20), (YGLY_VIEW_FLOAT(75) - imageSize.height)/2.0);
        [model addSubview:imageView];
    }
    //右侧更改为button
    if ([dict strValue:@"rightImageNormal"]) {
        
        UIButton *button = [[[UIButton alloc] init] autorelease];
        UIImage *image = [Utility getImageByName:[dict strValue:@"rightImageNormal"]];
        CGSize imageSize = YGLY_VIEW_SIZE(image.size);
        CGRect btnRect = {{0,0},imageSize};
        button.frame = btnRect;
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[Utility getImageByName:[dict strValue:@"rightImageHighlight"]] forState:UIControlStateHighlighted];
        
        SEL method = NSSelectorFromString([dict objectForKey:@"method"]);
        [button addTarget:[dict objectForKey:@"target"] action:method forControlEvents:UIControlEventTouchUpInside];
        button.tag = [dict intValue:@"btnTag"];
        
        CGFloat width = CGRectGetWidth(model.frame);
        button.point = CGPointMake(width-(YGLY_VIEW_FLOAT(20)+imageSize.width), (YGLY_VIEW_FLOAT(75) - imageSize.height)/2.0);
        [model addSubview:button];
    }
    if ([dict strValue:@"headText"]) {
        
        UILabel *label = [[[UILabel alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(140, 1, 430, 75))] autorelease];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        label.text = [dict strValue:@"headText"];
        [model addSubview:label];
        
    }
    if ([[dict objectForKey:@"bodyDict"] isKindOfClass:[NSDictionary class]]) {
        
        CGFloat width = CGRectGetWidth(model.frame)/YGLY_SIZE_SCALE;
        BodyModel *bodyModel = [BodyModel createBodyModelWithDict:[dict objectForKey:@"bodyDict"] frame:YGLY_VIEW_FRAME_ALL(CGRectMake(140, 95, width - 160, 50))];
        
        [model addSubview:bodyModel];
        
        frame.size.height = CGRectGetMaxY(bodyModel.frame);
    }
    model.frame = frame;
    
    return model;
}


@end
