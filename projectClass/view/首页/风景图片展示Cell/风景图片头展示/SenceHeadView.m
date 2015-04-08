//
//  SenceHeadView.m
//  yglyProject
//
//  Created by 枫 on 14-9-26.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "SenceHeadView.h"
#import "LhNSDictionary.h"
#import "Utility.h"

//本类所对应的字典如下
/* //all keys-values 如果不需要某些属性，请删除对应位置的key－values
 NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[  @"",
 @"",
 @""]
 
 forKeys:@[  @"bgColor",
 @"labelText",
 @"imageName"]];
 
 */

@implementation SenceHeadView

static  CGFloat ahScale = 0.5; //default is 0.5;

-(void)dealloc{
    
    self.label = nil;
    self.rightImageView = nil;
    
    EBLog(@"----%@-dealloc!---",NSStringFromClass([self class]));
    [super dealloc];
}

//topview height = 86; 20 49 17
// senceImageView 高度为125;
+(SenceHeadView *)createSenceHeadViewWithDict:(NSDictionary *)dict
                                        frame:(CGRect)frame{
    //设置右侧 左下斜角的底跟高的比
    
    SenceHeadView *senceHeadView = [[[SenceHeadView alloc] initWithFrame:frame] autorelease];
    
    if ([dict strValue:@"bgColor"]) {
        
        senceHeadView.backgroundColor = [Utility hexStringToColor:[dict strValue:@"bgColor"]];
        [Utility addBevel:senceHeadView ahScale:ahScale];
    }
    
    if ([dict strValue:@"labelText"]) {
        
        [senceHeadView initLabel:[dict strValue:@"labelText"]];
    }
    
    if ([dict strValue:@"imageName"]) {
        
        [senceHeadView initImageView:[dict strValue:@"imageName"]];
    }
    
    
    return senceHeadView;
}

-(void)initLabel:(NSString *)text {
    
    self.label = [[[UILabel alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(20, 0, 160, 49))] autorelease];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = text;
    _label.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    
}
-(void)initImageView:(NSString *)imageName{
    
    self.rightImageView = [Utility getUIImageViewByName:imageName];
    CGPoint point = _rightImageView.point;
    point.x = CGRectGetWidth(self.frame) - ahScale * CGRectGetHeight(self.frame) - CGRectGetWidth(_rightImageView.frame);
    _rightImageView.point = point;
    [self addSubview:_rightImageView];
    
    //修改——label的宽度
    if (_label) {
        
        CGFloat labeMaxX = CGRectGetMinX(_rightImageView.frame);
        CGRect rect = _label.frame;
        rect.size.width = labeMaxX - rect.origin.x;
        _label.frame = rect;
    }
    
}

@end
