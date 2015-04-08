//
//  FavourateCell.h
//  yglyProject
//
//  Created by 枫 on 15-1-5.
//  Copyright (c) 2015年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"

@interface FavourateCell : UITableViewCell

@property(nonatomic,readonly)DownloadUIImageView *leftImageView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *zhubanLabel;
@property(nonatomic,readonly)UILabel *addressLabel;
@property(nonatomic,readonly)UIImageView *lockImageView;//放小钟表
@property(nonatomic,readonly)UILabel *timeLabel;
@property(nonatomic,readonly)UILabel *makeLabel;//标签Label,固定内容
@property(nonatomic,readonly)UIImageView *rightImageVeiw;

-(void)setWithDict:(NSDictionary *)dict;
@end
