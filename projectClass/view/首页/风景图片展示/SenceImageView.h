//
//  SenceImageView.h
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DownloadUIImageView.h"
#import "TimeView.h"

@interface SenceImageView : UIView <TimeViewDelegate>

////这些属性只能在使用类方法初始化以后使用 尽量不要修改
@property (nonatomic, retain)DownloadUIImageView *imageView;
@property (nonatomic, retain)UIView *leftTopView;
@property (nonatomic, retain)UILabel *leftTopLabel;
@property (nonatomic, retain)DownloadUIImageView *rightImageView;
@property (nonatomic, retain)UILabel *rightImageViewTopLabel;
@property (nonatomic, retain)UILabel *rightImageViewBellowLabel;
@property (nonatomic, retain)UIImageView *bellowImageView;
@property (nonatomic, retain)UILabel *belowTitleLabel;
@property (nonatomic, retain)UILabel *belowSubTitleLabel;

+(SenceImageView *)createSenceImageFromDictionary:(NSDictionary *)dict
                                frame:(CGRect)frame;

@end
