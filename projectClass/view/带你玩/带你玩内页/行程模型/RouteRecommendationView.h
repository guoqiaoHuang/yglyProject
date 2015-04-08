//
//  RouteRecommendationView.h
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
//线路推荐展示view
@interface RouteRecommendationView : UIButton

+(RouteRecommendationView *)createRouteRecommendationViewWithDict:(NSDictionary *)dict frame:(CGRect)frame;

@end
