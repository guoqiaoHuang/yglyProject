//
//  OrderDetailsView.h
//  yglyProject
//
//  Created by 枫 on 14-11-14.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"

@interface OrderDetailsView : BackTitleUIImageView

@property(nonatomic,retain)NSString* orderId;
@property(nonatomic,retain)NSString *productId;
@property(nonatomic,retain)NSString *catId;

@end
