//
//  CityModel.m
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

-(void)dealloc
{
    self.cityCode = nil;
    self.otherCityCode = nil;
    self.provience = nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
