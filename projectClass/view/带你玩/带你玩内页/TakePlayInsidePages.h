//
//  PreferentialInsidePages.h
//  yglyProject
//
//  Created by 枫 on 14-10-15.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

//优惠内页

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
@interface TakePlayInsidePages : BackTitleUIImageView<VIewDadaGetDelegate>
{
    NSInteger nowPlayNum;
    NSInteger allPlayNum;
    NSInteger dayNum;
}
@property(nonatomic,copy)NSArray * playArray;
@property(nonatomic,retain)NSArray*xl_tuijian;
@property(nonatomic,copy)NSString*tell;
@end
