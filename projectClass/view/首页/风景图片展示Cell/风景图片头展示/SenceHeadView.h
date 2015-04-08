//
//  SenceHeadView.h
//  yglyProject
//
//  Created by 枫 on 14-9-26.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenceHeadView : UIView

@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIImageView *rightImageView;

+(SenceHeadView *)createSenceHeadViewWithDict:(NSDictionary *)dict
                                      frame:(CGRect)frame;
@end
