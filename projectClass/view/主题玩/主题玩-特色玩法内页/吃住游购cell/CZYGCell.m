//
//  CZYGCell.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 NSDictionary *dict = @{@"leftTopImage":@"",
                        @"bodyDict":@"",
                        @"bellowLineHidden":@""};
 */
#import "CZYGCell.h"
#import "LhNSDictionary.h"
#import "Utility.h"

@implementation CZYGCell

- (instancetype)initWithDict:(NSDictionary *)dict frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        
        self.clipsToBounds = NO;
        CGFloat width = frame.size.width/YGLY_SIZE_SCALE;
        
        //两个两像素的线---view
        _topLineView = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(120, 20, width-120, 2))] autorelease];
        _topLineView.backgroundColor = [Utility hexStringToColor:@"#ededed"];
        [self addSubview:_topLineView];
        
        _leftLineView = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(52 , 20, 2, 50))] autorelease];//会随着cell的宽度而改变
        _leftLineView.backgroundColor = [Utility hexStringToColor:@"#ececec"];
        [self addSubview:_leftLineView];
        
        _bellowLineView = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(120, 20, width-120, 2))] autorelease];
        _bellowLineView.backgroundColor = [Utility hexStringToColor:@"#ededed"];
        [self addSubview:_bellowLineView];
        
        _leftTopImageView = [Utility getUIImageViewByName:[dict strValue:@"leftTopImage"]];
        _leftTopImageView.scale = .5;//缩放比例，缩为原来的一半
        _leftTopImageView.layer.masksToBounds = YES;
        _leftTopImageView.layer.cornerRadius = _leftTopImageView.frame.size.width/2.0;
        
        //给左上角的图片添加一个渐变背景
//        UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-3, -3, _leftTopImageView.size.width + 6, _leftTopImageView.size.height + 6) cornerRadius:(_leftTopImageView.frame.size.width + 6)/2.0];
//        _leftTopImageView.clipsToBounds = NO;
//        _leftTopImageView.layer.shadowPath =bezier.CGPath;
//        _leftTopImageView.layer.shadowOffset = CGSizeZero;
//        _leftTopImageView.layer.shadowOpacity = 0.6;
//        _leftTopImageView.layer.shadowColor = [UIColor grayColor].CGColor;
        
        _leftTopImageView.center =  YGLY_VIEW_POINT(CGPointMake(53,21));
        [self addSubview:_leftTopImageView];
        
        //图片背部添加一个条状view
//        _bgTiaoView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 10)] autorelease];
//        _bgTiaoView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
//        CGPoint point = _leftTopImageView.center;
//        point.y -= _bgTiaoView.size.height/2.0;
//        _bgTiaoView.point = point;
      //  [self insertSubview:_bgTiaoView belowSubview:_leftTopImageView];
        
      //  CGRect _bodayRect = {{110,_bgTiaoView.origin.y - 3},{width - 110-20,60}};
       // _bodayBgImageview = [[[UIImageView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(_bodayRect)] autorelease];
//        _bodayBgImageview.backgroundColor = [UIColor whiteColor];
//        _bodayBgImageview.layer.masksToBounds = YES;
//        _bodayBgImageview.layer.cornerRadius = 3;
//        _bodayBgImageview.clipsToBounds = NO;
       // [self addSubview:_bodayBgImageview];
        
        
        if ([[dict objectForKey:@"bodyDict"] isKindOfClass:[NSDictionary class]]) {
            
            _bodayModel = [BodyModel createBodyModelWithDict:[dict objectForKey:@"bodyDict"] frame:YGLY_VIEW_FRAME_ALL(CGRectMake(120 , 42, width-140, 30)) style:2];
            frame.size.height = CGRectGetMaxY(_bodayModel.frame);
            self.frame = frame;
            [self addSubview:_bodayModel];
            
            CGRect rect = _leftLineView.frame;
            rect.size.height = CGRectGetHeight(self.frame);
            _leftLineView.frame = rect;
            
            _bellowLineView.hidden = [dict intValue:@"bellowLineHidden"];
            if (!_bellowLineView.hidden) {
                
                CGPoint point = _bellowLineView.origin;
                point.y = CGRectGetHeight(self.frame)+ YGLY_VIEW_FLOAT(20);//。。。。
                _bellowLineView.point = point;
                frame.size.height = point.y;
                self.frame = frame;
            }
        //    CGSize size = _bodayBgImageview.size;
          //  size.height = self.frame.size.height - YGLY_VIEW_FLOAT(20);
           // _bodayBgImageview.size = size;
//            UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-3, -3, _bodayBgImageview.size.width + 6, _bodayBgImageview.size.height + 6) cornerRadius:3];
//            _bodayBgImageview.layer.shadowPath =bezier.CGPath;
//            _bodayBgImageview.layer.shadowOffset = CGSizeZero;
//            _bodayBgImageview.layer.shadowOpacity = 0.6;
//            _bodayBgImageview.layer.shadowColor = [UIColor grayColor].CGColor;
            
         //   [_bodayBgImageview addSubview:_bodayModel];
          //  _bodayModel.point = CGPointMake(YGLY_VIEW_FLOAT(10), (_bodayBgImageview.size.height - _bodayModel.size.height + 10)/2.0);
        }
        
    }
    return self;
}

#pragma mark 如果不放在cell中则使用该方法
+(CZYGCell *)createCZYGCellWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    return [[[CZYGCell alloc] initWithDict:dict frame:frame] autorelease];
}
@end
