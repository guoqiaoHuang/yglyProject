//
//  TravelingModel.h
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>

//行程说明模型
@interface TravelingModel : UIView

+(TravelingModel *)createTravelingModelWithDict:(NSDictionary *)dict frame:(CGRect)frame;

@end
