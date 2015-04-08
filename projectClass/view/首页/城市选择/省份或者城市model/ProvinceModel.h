//
//  ProvinceModel.h
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ChineseString.h"

@interface ProvinceModel : ChineseString

//省份包含的城市列表
@property (nonatomic,retain)NSString *provienceCode;
@property (nonatomic,retain)NSMutableArray *cityArray;

@end
