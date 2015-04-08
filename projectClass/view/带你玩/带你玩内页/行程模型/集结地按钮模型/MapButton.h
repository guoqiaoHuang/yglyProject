//
//  MapButton.h
//  yglyProject
//
//  Created by 枫 on 14-10-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>

// style 0 图片在右 1 图片在左
@interface MapButton : UIButton

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,assign)NSInteger style;
+(MapButton *)createMapButtonWithDict:(NSDictionary *)dict point:(CGPoint)point style:(NSInteger)style;
+(MapButton *)createMapButtonWithDict:(NSDictionary *)dict point:(CGPoint)point;
@end
