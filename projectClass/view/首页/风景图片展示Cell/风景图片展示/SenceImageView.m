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
//时间显示time View已经失效
/* //all keys-values 如果不需要某些属性，请删除对应位置的key－values
 NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[  @"",@"",
 @"",@"",
 @"",@"",@"",
 @"",@""]
 
 forKeys:@[  @"senceUrl",@"defaultSence",
 @"leftTopColor",@"leftTopText",
 @"rightImageName",@"rightImageViewTopText",@"rightImageViewBellowText",
 @"belloImageName",@"bellowTitle",@"belloSubTitle",@"bellowLabelStyle"]];
 */
/*
 
 notice  你必须设置self.autoresizesSubviews = yes;
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
    self.indexPath = nil;
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
    senceImageView.clipsToBounds = YES;
    //索引值绑定
    senceImageView.indexPath = dict[@"indexPath"];
    //最底下的图片
    senceImageView.imageView = (DownloadUIImageView *)[DownloadUIImageView Create:[dict strValue:@"senceUrl"] defauleImage:[dict strValue:@"defaultSence"]];
    senceImageView.imageView.frame = senceImageView.bounds;
    //关键步骤 设置可变化背景view属性
    [senceImageView addSubview:senceImageView.imageView];
    senceImageView.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //左上角背景显示
    if ([dict strValue:@"leftTopColor"]) {//如果左上侧设置了颜色，则显示是左上角
        
        [senceImageView initLeftTopView:[Utility hexStringToColor:[dict strValue:@"leftTopColor"]]];
    }
    //左上角label显示
    if ([dict strValue:@"leftTopText"]) {
        
        [senceImageView initLeftTopLabel:[dict strValue:@"leftTopText"]];
    }
    
    //显示右侧的图片
    if ([dict strValue:@"rightImageName"]) {
        
        [senceImageView initRightImageViewWithImageUrl:[dict strValue:@"rightImageDefaultUrl"] imageName:[dict strValue:@"rightImageName"]];
        
        //显示右侧图片上的topLabel
        if ([dict strValue:@"rightImageViewTopText"]) {
            
            [senceImageView initRightImageViewTopLabel:[dict strValue:@"rightImageViewTopText"]];
        }
        
        //显示右侧图片上的bellowLabel
        if ([dict strValue:@"rightImageViewBellowText"]) {
            
            [senceImageView initRightImageViewBellowLabel:[dict strValue:@"rightImageViewBellowText"]];
        }
    }
    
    //显示底下遮罩层图片
    if ([dict strValue:@"belloImageName"]) {
        
        [senceImageView initbellowImageView:[dict strValue:@"belloImageName"]];
        
        //显示底下遮罩层title
        //样式一 参见首页-路线推荐
        //样式二 参见 路线详情
        //样式三 参见 主题玩
        // 如果包含有￥ 则该子标题为白色字号为30px
        if ([dict intValue:@"bellowLabelStyle"] == 0) {//样式一
            
            //显示底下遮罩层title
            if ([dict strValue:@"bellowTitle"]) {
                
                [senceImageView initBellowTitleLabel:[dict strValue:@"bellowTitle"] xPosition:YGLY_VIEW_FLOAT(20)];
            }
            //显示底下遮罩层subTitle
            if ([dict strValue:@"belloSubTitle"]) {
                
                [senceImageView initBellowSubTitleLabel:[dict strValue:@"belloSubTitle"] xPosition:YGLY_VIEW_FLOAT(20)];
                //标题向上移动
                CGRect titleRect = senceImageView.belowTitleLabel.frame;
                titleRect.origin.y -= (CGRectGetHeight(senceImageView.belowSubTitleLabel.frame)+YGLY_VIEW_FLOAT(10));
                senceImageView.belowTitleLabel.frame = titleRect;
            }
        }else if ([dict intValue:@"bellowLabelStyle"] == 1){//样式二
            
            //显示底下遮罩层title
            if ([dict strValue:@"bellowTitle"]) {
                
                [senceImageView initBellowTitleLabel:[dict strValue:@"bellowTitle"] xPosition:YGLY_VIEW_FLOAT(20)];
            }
            //显示底下遮罩层subTitle
            if ([dict strValue:@"belloSubTitle"]) {
                
                [senceImageView initBellowSubTitleLabel:[dict strValue:@"belloSubTitle"] xPosition:YGLY_VIEW_FLOAT(20)];
                //调整位置让label距离view右侧20像素
                CGRect subtitleRect = senceImageView.belowSubTitleLabel.frame;
                subtitleRect.origin.x = (CGRectGetWidth(senceImageView.frame) - CGRectGetWidth(senceImageView.belowSubTitleLabel.frame)-YGLY_VIEW_FLOAT(20));
                senceImageView.belowSubTitleLabel.frame = subtitleRect;
            }
        }else if ([dict intValue:@"bellowLabelStyle"] == 2){//样式三
            
            //显示底下遮罩层title
            if ([dict strValue:@"bellowTitle"]) {
                
                [senceImageView initBellowTitleLabel:[dict strValue:@"bellowTitle"] xPosition:YGLY_VIEW_FLOAT(20)];
            }
        }
    }
    
    [senceImageView initTapGesture];
    return senceImageView;
}

//添加左上侧三角，并在三角上添加label
-(void)initLeftTopView:(UIColor *)color {
    
    self.leftTopView = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 0, 120, 120))] autorelease];
    _leftTopView.backgroundColor = color;
    [Utility addBevel:_leftTopView];
    [self addSubview:_leftTopView];
    
}
-(void)initLeftTopLabel:(NSString *)text{
    
    if (_leftTopView == nil) return;
    
    self.leftTopLabel = [[[UILabel alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(30, 30, 36, 40))] autorelease];
    _leftTopLabel.text = text;
    _leftTopLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(34)];
    _leftTopLabel.backgroundColor = [UIColor clearColor];
    _leftTopLabel.textColor = [UIColor whiteColor];
    _leftTopLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [_leftTopLabel sizeToFit];
    [_leftTopView addSubview:_leftTopLabel];
    
}

-(void)initRightImageViewWithImageUrl:(NSString *)urlString
                            imageName:(NSString *)imageName{
    
    self.rightImageView = (DownloadUIImageView *)[DownloadUIImageView Create:urlString defauleImage:imageName];
    _rightImageView.frame = YGLY_VIEW_FRAME_ALL(CGRectMake(CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE - 110, 0, 110, CGRectGetHeight(self.frame)/YGLY_SIZE_SCALE));
    [self addSubview:_rightImageView];
    
}

-(void)initRightImageViewTopLabel:(NSString *)text{
    
    //topLabel
    if (_rightImageView == nil) return;
    
    self.rightImageViewTopLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rightImageView.frame), CGRectGetHeight(_rightImageView.frame) / 5)] autorelease];
    _rightImageViewTopLabel.text = text;
    _rightImageViewTopLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(34)];
    _rightImageViewTopLabel.textColor = [UIColor whiteColor];
    _rightImageViewTopLabel.textAlignment = NSTextAlignmentCenter;
    [_rightImageView addSubview:_rightImageViewTopLabel];
    
}

-(void)initRightImageViewBellowLabel:(NSString *)text{
    
    //topLabel
    if (_rightImageView == nil) return;
    
    self.rightImageViewBellowLabel = [[[LEffectLabel alloc] initWithFrame:CGRectMake( (CGRectGetWidth(_rightImageView.frame) - 15) / 2, CGRectGetHeight(_rightImageView.frame) / 5 , 15, CGRectGetHeight(_rightImageView.frame) * 3 / 6)] autorelease];
    _rightImageViewBellowLabel.text = text;
    //   _rightImageViewBellowLabel.backgroundColor = [UIColor clearColor];
    //_rightImageViewBellowLabel.numberOfLines = 10;
    _rightImageViewBellowLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(26)];
    _rightImageViewBellowLabel.textColor = [UIColor whiteColor];
    _rightImageViewBellowLabel.effectColor = [UIColor purpleColor];
    //  _rightImageViewBellowLabel.textAlignment = NSTextAlignmentCenter;
    // _rightImageViewBellowLabel.spotlightColor = [UIColor redColor];
    [_rightImageView addSubview:_rightImageViewBellowLabel];
    [_rightImageViewBellowLabel repeatRandomAnimation];
    
}

- (void)initbellowImageView:(NSString *)imageName {
    
    UIImage *image = [Utility getImageByName:imageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    self.bellowImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    _bellowImageView.point = CGPointMake(0, CGRectGetHeight(self.frame) - image.size.height/image.scale);
    CGRect rect = _bellowImageView.frame;
    rect.size.width = CGRectGetWidth(self.frame);
    _bellowImageView.image = image;
    _bellowImageView.frame = rect;
    _bellowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_bellowImageView];
}

- (void)initBellowTitleLabel:(NSString *)title xPosition:(CGFloat)xPosition{
    
    if (_bellowImageView == nil) return;
    
    //左右各空出20个像素
    CGSize contentSize = [Utility getSizeFormString:title maxW:(CGRectGetWidth(self.frame)-YGLY_VIEW_FLOAT(20+20)) font:[UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)]];
    CGRect rect = {{xPosition,CGRectGetHeight(self.bellowImageView.frame)-YGLY_VIEW_FLOAT(10)-17},{contentSize.width,17}};
    
    self.belowTitleLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    _belowTitleLabel.text = title;
    _belowTitleLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
    _belowTitleLabel.textColor = [UIColor whiteColor];
    [_bellowImageView addSubview:_belowTitleLabel];
}


- (void)initBellowSubTitleLabel:(NSString *)subTitle xPosition:(CGFloat)xPosition{
    
    if (_bellowImageView == nil) return;
    
    //左右各空出20个像素
    UIFont *font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(22)];
    UIColor *textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    if ([subTitle hasPrefix:@"￥"]) {
        font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        textColor = [UIColor whiteColor];
    }
    CGSize contentSize = [Utility getSizeFormString:subTitle maxW:(CGRectGetWidth(self.frame)-YGLY_VIEW_FLOAT(20+20)) font:font];
    CGRect rect = {{xPosition,CGRectGetHeight(self.bellowImageView.frame)-YGLY_VIEW_FLOAT(10)-17},{contentSize.width,17}};
    
    self.belowSubTitleLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    _belowSubTitleLabel.text = subTitle;
    _belowSubTitleLabel.font = font;
    _belowSubTitleLabel.textColor = textColor;
    [_bellowImageView addSubview:_belowSubTitleLabel];
}

- (void)initTapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    [tap release];
}

- (void)doTap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(senceCliked:)]) {
        
        [_delegate senceCliked:_indexPath];
    }
}

@end


@implementation SenceCell

-(void)setWithDict:(NSDictionary *)dict{
    
    if (!_senceImageView) {
        
        NSDictionary *tmpDict = @{@"senceUrl":@"",
                                  @"defaultSence":@"主题玩默认图片.png",
                                  @"leftTopColor":@"",
                                  @"leftTopText":@"",
                                  @"expiredDate":@"",
                                  @"timeTextColor":@"",
                                  @"timeBGColor":@"",
                                  @"rightImageName":@"",
                                  @"rightImageViewTopText":@"",
                                  @"rightImageViewBellowText":@"",
                                  @"belloImageName":@"景色图黑底衬.png",
                                  @"bellowTitle":@"行程：两天一夜",
                                  @"belloSubTitle":@"",
                                  @"bellowLabelStyle":@"2"};
        CGRect rect = {{0,20},{self.size.width/YGLY_SIZE_SCALE,415}};
        _senceImageView = [SenceImageView createSenceImageFromDictionary:tmpDict frame:YGLY_VIEW_FRAME_ALL(rect)];
       // _senceImageView.point = CGPointMake(0, YGLY_VIEW_FLOAT(20));
        [self.contentView addSubview:_senceImageView];
        _senceImageView.belowTitleLabel.width = 300;
        
        for (UIGestureRecognizer *gesture in _senceImageView.gestureRecognizers) {
            [_senceImageView removeGestureRecognizer:gesture];
        }
        
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGPathMoveToPoint(pathRef, NULL, 0, 10);
//        CGPathAddLineToPoint(pathRef, NULL, _senceImageView.size.width, 10);
//        CGPathAddLineToPoint(pathRef, NULL, _senceImageView.size.width, _senceImageView.size.height + 10);
//        CGPathAddCurveToPoint(pathRef, NULL, _senceImageView.size.width, _senceImageView.size.height + 10, _senceImageView.size.width/2, _senceImageView.size.height*0.8, 0, _senceImageView.size.height + 10);
//        CGPathCloseSubpath(pathRef);
//        
//        _senceImageView.clipsToBounds = NO;
//        _senceImageView.layer.shadowPath = pathRef;
//        _senceImageView.layer.shadowOffset = CGSizeMake(0, 3);
//        _senceImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _senceImageView.layer.shadowOpacity = 0.6;
//        CGPathRelease(pathRef);
        self.backgroundColor = [UIColor clearColor];
    }
    
    [_senceImageView.imageView setNewUrl:[dict objectForKey:@"senceUrl"] defauleImage:dict[@"defaultSence"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _senceImageView.belowTitleLabel.text = [dict strValue:@"bellowTitle"];
    });
}

@end