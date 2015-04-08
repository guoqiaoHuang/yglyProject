//
//  RouteRecommendationView.m
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 NSDictionary *dict = @{@"lineColor",@"",
 @"bgColor":@"",
 @"routeLine":@"",
 @"routePrice":@"",
 @"btnDict":@""};
 
 NSDictionary *btnDict = @{@"position":@"",
 @"position_Iphone4":@"",
 @"position_Iphone5":@"",
 @"position_Iphone6":@"",
 @"image":@"",
 @"method":@"",
 @"highlighted":@"",
 @"target":@""};

 */
#import "RouteRecommendationView.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "BaseUIImageView.h"

@implementation RouteRecommendationView

+(RouteRecommendationView *)createRouteRecommendationViewWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    RouteRecommendationView *model = [[[RouteRecommendationView alloc] initWithFrame:frame] autorelease];
//    return model;
    //一个像素的线的颜色
    NSString *lineColor = [dict strValue:@"lineColor" default:@"#9c9c9c"];
    NSString *bgColor = [dict strValue:@"bgColor" default:@"ececec"];
    //设置背景颜色
    model.backgroundColor = [Utility hexStringToColor:bgColor];
    
    CGFloat width = CGRectGetWidth(frame)/YGLY_SIZE_SCALE;
    CGFloat height = CGRectGetHeight(frame)/YGLY_SIZE_SCALE;
    //添加一条线
    UIView *line = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 0, width, 1))] autorelease];
    line.backgroundColor = [Utility hexStringToColor:lineColor];
    [model addSubview:line];
    //添加一条线
    line = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, height, width, 1))] autorelease];
    line.backgroundColor = [Utility hexStringToColor:lineColor];
    [model addSubview:line];
    
    if ([dict strValue:@"routeLine"]) {
        UILabel *routeLineLabel = [model addLabelWithText:[dict strValue:@"routeLine"] fontSize:YGLY_VIEW_FLOAT(26) frame:YGLY_VIEW_FRAME_ALL(CGRectMake(20, 1, 520, height-2))
                            textColor:[UIColor blackColor]];
        [model addSubview:routeLineLabel];
        routeLineLabel.userInteractionEnabled = NO;
        if ([dict strValue:@"routePrice"]) {
            
            NSString *string = [NSString stringWithFormat:@"￥%@",[dict strValue:@"routePrice"]];
            UILabel *routeLineLabel = [model addLabelWithText:string fontSize:YGLY_VIEW_FLOAT(26) frame:CGRectMake(0, 1, frame.size.width-5, height*0.5)
              textColor:[UIColor redColor]];
            routeLineLabel.textAlignment = NSTextAlignmentRight;
            routeLineLabel.userInteractionEnabled = NO;
            [model addSubview:routeLineLabel];
        }
    }
    return model;
}

-(UILabel *)addLabelWithText:(NSString *)text
                   fontSize:(CGFloat)fontSize
                  frame:(CGRect)frame
              textColor:(UIColor *)textColor{
    
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
    if ([text hasPrefix:@"￥"]) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    label.textColor = textColor;
    return label;
}
@end
