//
//  BusinessOrderDetailCell.h
//  yglyProject
//
//  Created by 枫 on 14-11-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
#import "ACPButton.h"
#import "BusinessOrderDetailView.h"

@interface BusinessOrderDetailCell : UITableViewCell
{
    DownloadUIImageView *userImageView;//用户头像
    UILabel *dingdanhaoLabel;
    UILabel *numberLabel;
    UILabel *priceLabel;
    ACPButton *stateButton;
    ACPButton *callHe;//用作提醒按钮
    NSString *phoneNumber;
}

@property(nonatomic,assign)UIView *bgView;
@property(nonatomic,assign)BusinessOrderDetailView *delegate;
@property(nonatomic,retain)NSIndexPath *indexPath;
-(void)setDict:(NSDictionary*)dict;
@end
