//
//  ActivityCell.m
//  yglyProject
//
//  Created by 枫 on 14-10-21.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = (DownloadUIImageView *)[DownloadUIImageView Create:@"" defauleImage:@"640x250默认图片.png"];
        CGRect rect = {{0, 0}, YGLY_VIEW_SIZE(CGSizeMake(186,186))};
        _imageView.frame = rect;
        
        [self addSubview:_imageView];
    }
    return self;
}

@end
