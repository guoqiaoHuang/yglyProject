//
//  CZYGCell.h
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyModel.h"

@interface CZYGCell : UIView

@property(nonatomic, readonly)UIImageView *leftTopImageView;
@property(nonatomic, readonly)UIView *bgTiaoView;//图片背部的条
@property(nonatomic, readonly)UIImageView *bodayBgImageview;//boday的背景图
@property(nonatomic, readonly)BodyModel *bodayModel;
@property(nonatomic, readonly)UIView *topLineView;
@property(nonatomic, readonly)UIView *leftLineView;
@property(nonatomic, readonly)UIView *bellowLineView;

+(CZYGCell *)createCZYGCellWithDict:(NSDictionary *)dict frame:(CGRect)frame;

@end
