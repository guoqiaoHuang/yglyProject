//
//  ProvinceModel.m
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

- (void)dealloc{
    
    self.cityArray =  nil;
    self.provienceCode = nil;
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
