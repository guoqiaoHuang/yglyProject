//
//  GatherAnnotationView.m
//  yglyProject
//
//  Created by 枫 on 14-10-8.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "GatherAnnotationView.h"
#import "Utility.h"

#define kWidth  40.f //单位未px
#define kHeight 40.f
#define normalColor @"#797979"
#define highlightColor @"#118bfe"

@implementation GatherAnnotationView

- (void)dealloc{
    
    [super dealloc];
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = [Utility getFrame:CGPointMake(0.f, 0.f) size:CGSizeMake(kWidth, kHeight)];
        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
        self.clipsToBounds = NO;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = CGRectGetWidth(_titleLabel.frame) / 2.0;
        _titleLabel.backgroundColor = [Utility hexStringToColor:normalColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.contentMode = UIViewContentModeCenter;
        [_titleLabel adjustsFontSizeToFitWidth];
        
        [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(2.0, 2.0);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.15 animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
        
        [self addSubview:_titleLabel];
        [_titleLabel release];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
}

@end
