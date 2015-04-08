//
//  SenceImageViewCell.h
//  yglyProject
//
//  Created by 枫 on 14-9-26.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenceImageView.h"
#import "SenceHeadView.h"
#import "LHScrollNumView.h"

@protocol SenceImageViewCellDelegate;

@interface SenceImageViewCell : UIView<LHScrollNumViewDelegate,SenceImageViewDelegate>

//这些属性只能在使用类方法初始化以后使用
@property(nonatomic,retain)SenceHeadView *senceHeadView;
@property(nonatomic,retain)SenceImageView *senceImageView;
@property(nonatomic,assign)id<SenceImageViewCellDelegate> delegate;

+(SenceImageViewCell *)createSenceImageViewCellWithDict:(NSDictionary *)dict
                                                  frame:(CGRect)frame;

@end

@protocol SenceImageViewCellDelegate <NSObject>
//timeView的时间已经停止（时间到了）
-(void)timeDidStop;
-(void)senceImageViewCellClicked:(NSIndexPath *)indexPath;

@end