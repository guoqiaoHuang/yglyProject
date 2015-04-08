//
//  SenceImageView.h
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DownloadUIImageView.h"
#import "LEffectLabel.h"

@protocol SenceImageViewDelegate;

@interface SenceImageView : UIView

////这些属性只能在使用类方法初始化以后使用 尽量不要修改
@property (nonatomic, retain)DownloadUIImageView *imageView;
@property (nonatomic, retain)UIView *leftTopView;
@property (nonatomic, retain)UILabel *leftTopLabel;
@property (nonatomic, retain)DownloadUIImageView *rightImageView;
@property (nonatomic, retain)UILabel *rightImageViewTopLabel;
@property (nonatomic, retain)LEffectLabel *rightImageViewBellowLabel;
@property (nonatomic, retain)UIImageView *bellowImageView;
@property (nonatomic, retain)UILabel *belowTitleLabel;
@property (nonatomic, retain)UILabel *belowSubTitleLabel;
@property (nonatomic, assign)id<SenceImageViewDelegate> delegate;
@property (nonatomic, retain)NSIndexPath *indexPath;

+(SenceImageView *)createSenceImageFromDictionary:(NSDictionary *)dict
                                            frame:(CGRect)frame;

@end

@protocol SenceImageViewDelegate <NSObject>

@optional
-(void)timeViewTimeDidStop;
-(void)senceCliked:(NSIndexPath *)indexPath;

@end

//负责在表示图中展示风景图片
@interface SenceCell : UITableViewCell

@property(nonatomic,readonly)SenceImageView *senceImageView;
@property(nonatomic,retain)NSIndexPath *indexPath;
-(void)setWithDict:(NSDictionary *)dict;
@end