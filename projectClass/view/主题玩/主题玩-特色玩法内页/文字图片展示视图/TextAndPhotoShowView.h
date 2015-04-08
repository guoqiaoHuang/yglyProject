//
//  TextAndPhotoShowView.h
//  yglyProject
//
//  Created by 枫 on 14-10-21.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"

@interface TextAndPhotoShowView : UIView

@property(nonatomic, readonly)UILabel *textLabel;
@property(nonatomic, readonly)DownloadUIImageView *imageView;

+(TextAndPhotoShowView *)CreateTextAndPhotoShowViewWithDic:(NSDictionary *)dict frame:(CGRect)frame;

@end
