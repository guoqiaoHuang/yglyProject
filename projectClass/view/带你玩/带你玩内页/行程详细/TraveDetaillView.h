//
//  TraveDetaillView.h
//  yglyProject
//
//  Created by 枫 on 14-10-29.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
@interface TraveDetaillView : BackTitleUIImageView<VIewDadaGetDelegate>

@property(nonatomic,assign)NSInteger day;
-(void)setDayNum:(NSInteger)num dayIndx:(NSInteger)dayIndx;
@end
