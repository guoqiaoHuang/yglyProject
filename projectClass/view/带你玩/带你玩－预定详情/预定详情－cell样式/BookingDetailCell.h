//
//  BookingDetailCell.h
//  yglyProject
//
//  Created by 枫 on 14-11-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
#import "LineUITableViewCell.h"
@interface BookingDetailCell : LineUITableViewCell
{
    DownloadUIImageView *imageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
}
-(void)setWithDict:(NSDictionary *)dict;

@end
