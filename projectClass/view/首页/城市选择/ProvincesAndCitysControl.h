//
//  ProvincesAndCitysControl.h
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

@interface ProvincesAndCitysControl : NSObject

@property (nonatomic, retain)NSString *plistFile;

//下列相同位置处的表示该省份所对应的城市列表
@property (nonatomic, readonly)NSMutableArray *provinceArray;

+(ProvincesAndCitysControl *)shareInstance;
- (instancetype)initWithPlistFile:(NSString *)filePath;

//城市匹配查询
-(NSMutableArray *)searchByCityName:(NSString *)city type:(NSInteger)type;
@end
