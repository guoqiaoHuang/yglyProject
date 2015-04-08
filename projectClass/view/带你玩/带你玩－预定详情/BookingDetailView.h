//
//  BookingDetailView.h
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
@interface BookingDetailView : BackTitleUIImageView<VIewDadaGetDelegate>
@property(nonatomic,retain)NSString*alerturl;
@end

@interface UILabel (ChangeTextAlignment)

@end