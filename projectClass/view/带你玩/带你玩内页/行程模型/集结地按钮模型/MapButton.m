//
//  MapButton.m
//  yglyProject
//
//  Created by 枫 on 14-10-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 NSDictionary *dic = @{@"title":@"",
 @"imageName":@"",@"selectedImageName":@""};
 */

#import "MapButton.h"

@implementation MapButton
{
    CGSize titleSize;
    CGSize imageSize;
    CGFloat distance;//文字与图片之间的间距,默认为十个像素
}
- (void)dealloc{
    
    self.title = nil;
    self.address = nil;
    [super dealloc];
}
- (instancetype)initWithDict:(NSDictionary *)dict point:(CGPoint)point style:(NSInteger)style
{
    self = [super init];
    if (self) {
        
        self.style = style;
        self.titleLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [self setTitleColor:[Utility hexStringToColor:@"#30629a"] forState:UIControlStateNormal];
        titleSize = CGSizeZero;
        imageSize = CGSizeZero;
        distance = YGLY_VIEW_FLOAT(10);
       
        if ([dict strValue:@"title"]) {
            self.title = [dict strValue:@"title"];
            [self setTitle:_title forState:UIControlStateNormal];
            //计算title的frame
            titleSize = [Utility getSizeFormString:_title maxW:MAXFLOAT font:self.titleLabel.font];
        }
        if ([dict strValue:@"imageName"]) {
            UIImage *image = [Utility getImageByName:[dict strValue:@"imageName"]];
            imageSize = YGLY_VIEW_SIZE(image.size);
            [self setImage:image forState:UIControlStateNormal];
            
            UIImage *selectedImage = [Utility getImageByName:[dict strValue:@"selectedImageName"]];
            [self setImage:selectedImage forState:UIControlStateHighlighted];
        }
        
        self.address = dict[@"content"];
        //计算button的frame
        CGRect rect = {point,{imageSize.width + titleSize.width + distance,MAX(titleSize.height, imageSize.height)}};
        self.frame = rect;
    }
    return self;
}

+(MapButton *)createMapButtonWithDict:(NSDictionary *)dict point:(CGPoint)point style:(NSInteger)style{
    
    return [[[MapButton alloc] initWithDict:dict point:point style:style] autorelease];
}
+(MapButton *)createMapButtonWithDict:(NSDictionary *)dict point:(CGPoint)point{
    
    return [MapButton createMapButtonWithDict:dict point:point style:0];
    
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGPoint point = {0,(MAX(titleSize.height, imageSize.height) - titleSize.height)/2.0};
    if (_style == 1) {
        
        point.x = imageSize.width+distance;
    }
    CGRect rect = {point,titleSize};
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGPoint point = {titleSize.width + distance,(MAX(titleSize.height, imageSize.height) - imageSize.height)/2.0};
    if (_style == 1) {
        
        point.x = 0.0;
    }
    CGRect rect = {point,imageSize};
    return rect;
}

@end
