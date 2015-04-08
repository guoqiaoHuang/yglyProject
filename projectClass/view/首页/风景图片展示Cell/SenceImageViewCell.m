//
//  SenceImageViewCell.m
//  yglyProject
//
//  Created by 枫 on 14-9-26.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "SenceImageViewCell.h"

//本类所对应的字典如下
/* //all keys-values 如果不需要某些属性，请删除对应位置的key－values
 NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[  @"",
 @"",
 @"",@"",@""]
 
 forKeys:@[  @"senceHeadViewDict",
 @"senceImageViewDict",
 @"expiredDate",@"timeTextColor",@"timeBGColor"]];
 
 */

@implementation SenceImageViewCell

-(void)dealloc{
    
    self.senceHeadView = nil;
    self.senceImageView = nil;
    
     EBLog(@"----%@-dealloc!---",NSStringFromClass([self class]));
    [super dealloc];
}

//topview height = 86; 20 49 17
// senceImageView 高度为125;
+(SenceImageViewCell *)createSenceImageViewCellWithDict:(NSDictionary *)dict
                                                  frame:(CGRect)frame{
    
    SenceImageViewCell *senceCell = [[[SenceImageViewCell alloc] initWithFrame:frame] autorelease];
    senceCell.backgroundColor = [UIColor whiteColor];
    
    if ([[dict objectForKey:@"senceHeadViewDict"] isKindOfClass:[NSDictionary class]]) {
        
        [senceCell initSenceHeadViewWithDict:[dict objectForKey:@"senceHeadViewDict"]];
    }
    
    if ([[dict objectForKey:@"senceImageViewDict"] isKindOfClass:[NSDictionary class]]) {
        
        [senceCell initSenceImageViewWithDict:[dict objectForKey:@"senceImageViewDict"]];
    }
    
    //显示时间label
    if ([dict dateValue:@"expiredDate"]) {
        
        NSDate *expiredDate = [dict dateValue:@"expiredDate"];
        
        UIColor *timeTextColor = nil;
        if ([dict strValue:@"timeTextColor"]) {
            timeTextColor = [Utility hexStringToColor:[dict strValue:@"timeTextColor"]];
        }
        UIColor *timeBGColor = nil;
        if ([dict strValue:@"timeBGColor"]) {
            timeBGColor = [Utility hexStringToColor:[dict strValue:@"timeBGColor"]];
        }
        
        [senceCell initTimeViewWithTextColor:timeTextColor labelBGColor:timeBGColor expiredDate:expiredDate];
    }
    
    return senceCell;
}

-(void)initSenceHeadViewWithDict:(NSDictionary *)dict{
    
    self.senceHeadView = [SenceHeadView createSenceHeadViewWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 20, 250, 49))];
    [self addSubview:_senceHeadView];
}

-(void)initSenceImageViewWithDict:(NSDictionary *)dict{
    
    self.senceImageView = [SenceImageView createSenceImageFromDictionary:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 86, CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE, 250))];
    self.senceImageView.delegate = self;
    [self addSubview:_senceImageView];
}

-(void)initTimeViewWithTextColor:(UIColor *)textColor
                    labelBGColor:(UIColor *)labelBGColor
                     expiredDate:(NSDate *)expiredDate{
    
    LHScrollNumView *scrollNumber  = [LHScrollNumView CreateLHScrollNumView:YGLY_VIEW_FRAME_ALL(CGRectMake(355, 20, 200, 49)) diff:2.5 num:3 numberSize:2 bgColor:[Utility hexStringToColor:@"#164a63"]];
    CGPoint point = scrollNumber.point;
    point.x = CGRectGetWidth(self.frame) - (YGLY_VIEW_FLOAT(20) + CGRectGetWidth(scrollNumber.frame));
    scrollNumber.point = point;
    scrollNumber.delegate = self;
    [scrollNumber setExpiredDate:expiredDate];
    [self addSubview:scrollNumber];
    
}
#pragma mark - delegate
- (void)LHScrollNumViewDidStop:(LHScrollNumView*)view{
 
    if (_delegate && [_delegate respondsToSelector:@selector(timeDidStop)]) {
        [_delegate timeDidStop];
    }
}
- (void)senceCliked:(NSIndexPath *)indexPath{
    
    if (_delegate && [_delegate respondsToSelector:@selector(senceImageViewCellClicked:)]) {
        [_delegate senceImageViewCellClicked:indexPath];
    }
}
@end
