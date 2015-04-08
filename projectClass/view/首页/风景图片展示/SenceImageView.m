//
//  SenceImageView.m
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "SenceImageView.h"
#import "Utility.h"

//#336699 #ff9933 #003366
//本类所对应的字典如下
/* //all keys-values 如果不需要某些属性，请删除对应位置的key－values
NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[  @"",@"",
                                                            @"",@"",
                                                            @"",@"",@"",
                                                            @"",@"",@"",
                                                            @"",@""]
 
                                                forKeys:@[  @"senceUrl",@"defaultSence",
                                                            @"leftTopColor",@"leftTopText",
                                                            @"expiredDate",@"timeTextColor",@"timeBGColor",
                                                            @"rightImageName",@"rightImageViewTopText",@"rightImageViewBellowText",
                                                            @"belloImageName",@"bellowTitle",@"belloSubTitle"]];
*/

@implementation SenceImageView

- (void)dealloc{
 
    self.imageView = nil;
    self.leftTopView = nil;
    self.leftTopLabel = nil;
    self.rightImageView = nil;
    self.rightImageViewBellowLabel = nil;
    self.rightImageViewTopLabel = nil;
    self.bellowImageView = nil;
    self.belowSubTitleLabel = nil;
    self.belowTitleLabel = nil;
    
    EBLog(@"----%@-dealloc!---",NSStringFromClass([self class]));
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
 
    self = [super initWithFrame:frame];
    if (self) {
 
    }
 
    return self;
}

+ (SenceImageView *)createSenceImageFromDictionary:(NSDictionary *)dict
                                frame:(CGRect)frame{
    
    SenceImageView * senceImageView = [[[SenceImageView alloc] initWithFrame:frame] autorelease];
    
    //最底下的图片
    senceImageView.imageView = (DownloadUIImageView *)[DownloadUIImageView Create:[dict strValue:@"senceUrl"] defauleImage:[dict strValue:@"defaultSence"]];
    senceImageView.imageView.frame = senceImageView.bounds;
    [senceImageView addSubview:senceImageView.imageView];
    
    //左上角背景显示
    if ([dict strValue:@"leftTopColor"]) {//如果左上侧设置了颜色，则显示是左上角
        
        [senceImageView initLeftTopView:[Utility hexStringToColor:[dict strValue:@"leftTopColor"]]];
    }
    //左上角label显示
    if ([dict strValue:@"leftTopText"]) {
        
        [senceImageView initLeftTopLabel:[dict strValue:@"leftTopText"]];
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
        
        [senceImageView initTimeViewWithTextColor:timeTextColor labelBGColor:timeBGColor expiredDate:expiredDate];
    }
        
    //显示右侧的图片
    if ([dict strValue:@"rightImageName"]) {
        
        [senceImageView initRightImageViewWithImageUrl:[dict strValue:@"rightImageDefaultUrl"] imageName:[dict strValue:@"rightImageName"]];
    }
    //显示右侧图片上的topLabel
    if ([dict strValue:@"rightImageViewTopText"]) {
        
        [senceImageView initRightImageViewTopLabel:[dict strValue:@"rightImageViewTopText"]];
    }
    
    //显示右侧图片上的bellowLabel
    if ([dict strValue:@"rightImageViewBellowText"]) {
        
        [senceImageView initRightImageViewBellowLabel:[dict strValue:@"rightImageViewBellowText"]];
    }
    
    //显示底下遮罩层图片
    if ([dict strValue:@"belloImageName"]) {
     
        [senceImageView initbellowImageView:[dict strValue:@"belloImageName"]];
    }
    
    //显示底下遮罩层title
    if ([dict strValue:@"bellowTitle"]) {
        
        [senceImageView initBellowTitleLabel:[dict strValue:@"bellowTitle"]];
    }
    
    //显示底下遮罩层subTitle
    if ([dict strValue:@"belloSubTitle"]) {
        
        [senceImageView initBellowSubTitleLabel:[dict strValue:@"belloSubTitle"]];
    }
    
    
    
    return senceImageView;
}

//添加左上侧三角，并在三角上添加label
-(void)initLeftTopView:(UIColor *)color {
    
    self.leftTopView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 47, 47)] autorelease];
    _leftTopView.backgroundColor = color;
    [Utility addBevel:_leftTopView];
    [self addSubview:_leftTopView];
    
}
-(void)initLeftTopLabel:(NSString *)text{
    
    if (_leftTopView == nil) return;
        
    self.leftTopLabel = [[[UILabel alloc] initWithFrame:CGRectMake(9, 9, 18, 20)] autorelease];
    _leftTopLabel.text = text;
    _leftTopLabel.backgroundColor = [UIColor clearColor];
    _leftTopLabel.textColor = [UIColor whiteColor];
    _leftTopLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [_leftTopLabel sizeToFit];
    [_leftTopView addSubview:_leftTopLabel];
    
}

-(void)initTimeViewWithTextColor:(UIColor *)textColor
                    labelBGColor:(UIColor *)labelBGColor
                     expiredDate:(NSDate *)expiredDate{
    
    TimeView *timeView = [[[TimeView alloc]initWithFrame:CGRectMake(130, 9, 20, 26)] autorelease];
    timeView.delegate = self;
    timeView.timeLabelWidth = 14.0f;
    timeView.timeLabelDistance = 3.0f;
    timeView.timeLabelCornerRadius = 5.0f;
    timeView.timeLabelTextColor = textColor;
    timeView.timeLabelBGColor = labelBGColor;
    timeView.expiredDate = expiredDate;
    [self addSubview:timeView];
    
}
- (void)timeViewDidStop{
    
    EBLog(@"=--time out---");
}

-(void)initRightImageViewWithImageUrl:(NSString *)urlString
                            imageName:(NSString *)imageName{
    
    self.rightImageView = (DownloadUIImageView *)[DownloadUIImageView Create:urlString defauleImage:imageName];
    _rightImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 65, 0, 65, CGRectGetHeight(self.frame));
    [self addSubview:_rightImageView];
    
}

-(void)initRightImageViewTopLabel:(NSString *)text{
    
    //topLabel
    if (_rightImageView == nil) return;
    
    self.rightImageViewTopLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rightImageView.frame), CGRectGetHeight(_rightImageView.frame) / 5)] autorelease];
    _rightImageViewTopLabel.text = text;
    _rightImageViewTopLabel.font = [UIFont boldSystemFontOfSize:20];
    _rightImageViewTopLabel.textColor = [UIColor whiteColor];
    _rightImageViewTopLabel.textAlignment = NSTextAlignmentCenter;
    [_rightImageView addSubview:_rightImageViewTopLabel];
    
}

-(void)initRightImageViewBellowLabel:(NSString *)text{
    
    //topLabel
    if (_rightImageView == nil) return;
    
    self.rightImageViewBellowLabel = [[[UILabel alloc] initWithFrame:CGRectMake( (CGRectGetWidth(_rightImageView.frame) - 15) / 2, CGRectGetHeight(_rightImageView.frame) / 5 , 15, CGRectGetHeight(_rightImageView.frame) * 4 / 5)] autorelease];
    _rightImageViewBellowLabel.text = text;
    _rightImageViewBellowLabel.numberOfLines = 10;
    _rightImageViewBellowLabel.font = [UIFont boldSystemFontOfSize:15];
    _rightImageViewBellowLabel.textColor = [UIColor whiteColor];
    _rightImageViewBellowLabel.textAlignment = NSTextAlignmentCenter;
    [_rightImageView addSubview:_rightImageViewBellowLabel];
    
}

- (void)initbellowImageView:(NSString *)imageName {
    
    self.bellowImageView = [Utility getUIImageViewByName:@"景色图黑底衬.png"];
    _bellowImageView.point = CGPointMake(0, CGRectGetHeight(self.frame) - CGRectGetHeight(_bellowImageView.frame));
    [self addSubview:_bellowImageView];
}

- (void)initBellowTitleLabel:(NSString *)title{
    
    if (_bellowImageView == nil) return;
    
    self.belowTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 30)] autorelease];
    _belowTitleLabel.text = title;
    _belowTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    _belowTitleLabel.textColor = [UIColor whiteColor];
    [_bellowImageView addSubview:_belowTitleLabel];
}

- (void)initBellowSubTitleLabel:(NSString *)subTitle{
    
    if (_bellowImageView == nil) return;
    
    self.belowSubTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 250, 17)] autorelease];
    _belowSubTitleLabel.text = subTitle;
    _belowSubTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    _belowSubTitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    [_bellowImageView addSubview:_belowSubTitleLabel];
}


@end
