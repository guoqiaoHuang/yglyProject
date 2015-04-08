//
//  TextAndPhotoShowView.m
//  yglyProject
//
//  Created by 枫 on 14-10-21.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 NSDictionary *dict = @{@"text":@"",
 @"defaultImage":@"",
 @"imgUrl":@""
 @"style":@""
 @"bgColor":@""};
 */
//高度会放生改变
#import "TextAndPhotoShowView.h"
#import "LhNSDictionary.h"
#import "LhUIView.h"

//style 0-默认为文字上图片下 1- 图片上文字下

@implementation TextAndPhotoShowView

- (instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        //默认背景色为白色
        NSString *colorString = [dict strValue:@"bgColor"];//self的背景颜色默认为透明色
        if(colorString){
            self.backgroundColor = [Utility hexStringToColor:colorString];
        }else{
            self.backgroundColor = [UIColor whiteColor];
        }
        CGFloat topOffset = YGLY_VIEW_FLOAT([dict floatValue:@"topOffset"]);
        CGFloat bottomOffset = YGLY_VIEW_FLOAT([dict floatValue:@"bottomOffset"]);
        
        if ([dict strValue:@"text"]) {
            
            CGRect rect = {{10,topOffset},{frame.size.width-20,frame.size.height}};
            _textLabel = [self createUILabelWithText:[dict strValue:@"text"] fontSize:YGLY_VIEW_FLOAT(26) textColor:[UIColor blackColor] frame:rect];
            frame.size.height = CGRectGetHeight(_textLabel.frame);
            self.frame = frame;
            
            [self addSubview:_textLabel];
        }
        if ([dict strValue:@"defaultImage"]) {
            
            if (_textLabel) {
                frame.size.height = CGRectGetMaxY(_textLabel.frame) + YGLY_VIEW_FLOAT(20);
            }else{
                frame.size.height = 0.0;
            }
            self.frame = frame;
            
            UIImage *image = [Utility getImageByName:[dict strValue:@"defaultImage"]];
            CGFloat imageW = image.size.width*YGLY_SIZE_SCALE;
            CGPoint point = {(frame.size.width - imageW)/2.0,frame.size.height};
            _imageView = (DownloadUIImageView *)[DownloadUIImageView Create:[dict strValue:@"imgUrl"] defauleImage:[dict strValue:@"defaultImage"]];
            _imageView.point = point;
            
            CGSize size = frame.size;
            size.height += CGRectGetHeight(_imageView.frame);
            self.size = size;
            
            [self addSubview:_imageView];
        }
        CGSize size = self.size;
        size.height += bottomOffset;
        self.size = size;
        
        NSInteger flage = [dict intValue:@"style"];
        if (flage == 0){//默认
            ;
        }else if (flage == 1){//图上文下
            if (_textLabel) {
                _imageView.point = CGPointMake(_imageView.point.x, _textLabel.point.y);
                _textLabel.point = CGPointMake(_textLabel.point.x, CGRectGetMaxY(_imageView.frame)+YGLY_VIEW_FLOAT(20));
            }
        }
    }
    return self;
}

+(TextAndPhotoShowView *)CreateTextAndPhotoShowViewWithDic:(NSDictionary *)dict frame:(CGRect)frame{
    
    return [[[TextAndPhotoShowView alloc] initWithFrame:frame dict:dict] autorelease];
    
}

//重新计算高度
-(UILabel*)createUILabelWithText:(NSString *)text
                        fontSize:(CGFloat)fontSize
                       textColor:(UIColor*)color
                           frame:(CGRect)frame{
    
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    
    //重新计算frame
    CGSize contentSize = CGSizeZero;
    contentSize = [Utility getSizeFormString:text maxW:CGRectGetWidth(label.frame) font:label.font];
    
    CGRect labelFrame = frame;
    labelFrame.size = contentSize;
    labelFrame.size.width = CGRectGetWidth(label.frame);
    label.frame = labelFrame;
    
    return label;
}

#pragma mark- frame 发生改变的时候重新计算子视图的frame
//-(void)setFrame:(CGRect)frame{
//    
//    
//    [super setFrame:frame];
//}
@end
