//
//  CityModel.h
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ChineseString.h"

@interface CityModel : ChineseString

@property(nonatomic,assign)CGFloat lat;//纬度
@property(nonatomic,assign)CGFloat lon;//经度
@property(nonatomic,retain)NSString *cityCode;//城市编码
@property(nonatomic,retain)NSString *otherCityCode;//不同地图中相同城市的不同城市编码
@property(nonatomic,retain)NSString *provience;//城市所属的省份，或者是直辖市，或者是特别行政区等等

@end
