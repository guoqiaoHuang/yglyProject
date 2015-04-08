//
//  BaseAllShowViewBaseView.h
//  yglyProject
//
//  Created by 枫 on 14-10-20.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BaseUIImageView.h"
#import "TextAndPhotoShowView.h"
#import "RouteRecommendationView.h"

@interface BaseAllShowViewBaseView : BaseUIImageView

//除了头部视图，其它所有的视图都将添加在该视图上
@property(nonatomic, readonly)UIScrollView *scrollView;
@property(nonatomic, readonly)UIView *naviView;//头部视图

#pragma mark-初始化一个scrollView
//height 单位为像素（px）
//创建一个与底部相距height高度的scrollview
- (void)initScrollViewWithBottomHeight:(CGFloat)height scrolViewClass:(Class)scrolViewClass;
- (void)initScrollViewWithBottomHeight:(CGFloat)height;
#pragma mark-// 供领队 和 一起玩展示 使用
//参数一 与上一个所添加的view之间的距离 单位（px）
//参数二 与下一个将要添加的view之间的距离 单位（px）
//每添加一个部分都会
- (UICollectionView *)addCollectionViewWithReuseIdentifier:(NSString *)identifier   collectionViewFlowLayout:(UICollectionViewFlowLayout *)layout
                                   collectionViewCellClass:(Class)cellClass
                                                    bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加一个 风景头部展示cell
- (void)addSenceHeadViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加一个 风景图片展示
- (void)addSenceImageViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace delegate:(id)delegate;
- (void)addSenceImageViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加行程
- (void)addTravelingViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加预定须知
- (void)addBodyViewWithDic:(NSDictionary *)dict style:(NSInteger)style bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加线路推荐
- (RouteRecommendationView *)addRouteRecommendationViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark 动态计算label的size,并添加到scrollView上
//字符串的最大宽度为label的最大宽度,只改变它的y坐标和size大小
-(void)resizeLabelSize:(UILabel *)label text:(NSString *)text bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark 添加吃住游购展示视图cell
-(void)addCZYGCellWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加一个 风景图片展示cell
- (void)addSenceImageViewCellWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 添加文字图片显示的视图
-(TextAndPhotoShowView *)addTextAndPhotoViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace addGesture:(UIGestureRecognizer *)gesture;
#pragma mark-添加一个倒计时view
-(void)addTimeViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark 添加预定码
-(void)addYuDingMaViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace delegate:(id)delegate;
-(void)addYuDingMaViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace;
#pragma mark - 设置当只有极少数cell时，居中显示问题
-(void)setCollectionViewCenter:(UICollectionView *)collV;

@end
