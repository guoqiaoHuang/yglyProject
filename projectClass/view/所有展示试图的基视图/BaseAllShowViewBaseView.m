//
//  BaseAllShowViewBaseView.m
//  yglyProject
//
//  Created by 枫 on 14-10-20.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
//本类是通过srollView的contentSize的改变来适应页面数据
#import "BaseAllShowViewBaseView.h"
#import "LeaderAndFriendCell.h"
#import "LeaderAndFriendFlowLayout.h"
#import "SenceHeadView.h"
#import "SenceImageView.h"
#import "SenceImageViewCell.h"
#import "TravelingModel.h"
#import "BodyModel.h"
#import "RouteRecommendationView.h"
#import "CZYGCell.h"
#import "TextAndPhotoShowView.h"
#import "YuDingMa.h"

@interface BaseAllShowViewBaseView ()<UICollectionViewDataSource,UICollectionViewDelegate,SenceImageViewCellDelegate,LHScrollNumViewDelegate>
{
    UIView *bottomView;
    NSInteger dayFlage;//记录行程说明中，当前点击的天数
}

@end

@implementation BaseAllShowViewBaseView

-(void)dealloc{
    
    _scrollView = nil;
    [super dealloc];
}
-(void)showView{
    
    [super showView];
    //拿到头部视图，主要获取它的frame,从而确定scrollView的起始位置
    _naviView = [self viewWithTag:511];
    bottomView = [self.controller.view viewWithTag:5];
    dayFlage = 10000;
}

#pragma mark-初始化一个scrollView
//height 单位为像素（px）
//创建一个与底部相距height高度的scrollview
- (void)initScrollViewWithBottomHeight:(CGFloat)height scrolViewClass:(Class)scrolViewClass{
    
    if (![scrolViewClass isSubclassOfClass:[UIScrollView class]]) {
        
        @throw [NSException exceptionWithName:@"class type faill" reason:@"scrolViewClass must be a UIScrollView subClass or UIScrollView" userInfo:nil];
    }
    CGFloat scroH;
    scroH = CGRectGetHeight(self.frame) - CGRectGetMaxY(_naviView.frame) - YGLY_VIEW_FLOAT(height);
    _scrollView = [[[scrolViewClass alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviView.frame), CGRectGetWidth(self.frame), scroH)] autorelease];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self insertSubview:_scrollView atIndex:0];
    [self.viewArray addObject:_scrollView];
}
- (void)initScrollViewWithBottomHeight:(CGFloat)height{
    
    [self initScrollViewWithBottomHeight:height scrolViewClass:[UIScrollView class]];
}
#pragma mark-// 供领队 和 一起玩展示 使用
//参数一 与上一个所添加的view之间的距离 单位（px）
//参数二 与下一个将要添加的view之间的距离 单位（px）
//每添加一个部分都会
- (UICollectionView *)addCollectionViewWithReuseIdentifier:(NSString *)identifier   collectionViewFlowLayout:(UICollectionViewFlowLayout *)layout
     collectionViewCellClass:(Class)cellClass
                      bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    UICollectionView *collectionView = [[[UICollectionView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 150)) collectionViewLayout:layout] autorelease];
    
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    
    [_scrollView addSubview:collectionView];
    [self.viewArray addObject:collectionView];
    
    size.height = CGRectGetMaxY(collectionView.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
    
    return collectionView;
}
#pragma mark - 添加一个 风景头部展示cell
- (void)addSenceHeadViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    //topview height = 86; 20 49 17
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    
    SenceHeadView *senceHeadView = [SenceHeadView createSenceHeadViewWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, 250, 49))];
    
    [_scrollView addSubview:senceHeadView];
    [self.viewArray addObject:senceHeadView];
    
    size.height = CGRectGetMaxY(senceHeadView.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark - 添加一个 风景图片展示
- (void)addSenceImageViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace delegate:(id)delegate{
    
    //取上一次view最大的y值作为这一次的最小y值
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    CGRect rect = YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 250));
    SenceImageView *senceImageView = [SenceImageView createSenceImageFromDictionary:dict frame:rect];
    senceImageView.delegate = delegate;
    [_scrollView addSubview:senceImageView];
    [self.viewArray addObject:senceImageView];
    
    size.height = CGRectGetMaxY(senceImageView.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
- (void)addSenceImageViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    [self addSenceImageViewWithDic:dict bSpace:bSpace eSpace:eSpace delegate:nil];
}
#pragma mark - 添加行程
- (void)addTravelingViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutDict setValuesForKeysWithDictionary:@{@"rightImageNormal":@"箭头默认.png",
                                           @"rightImageHighlight":@"箭头按下.png",
                                           @"method":@"gotoTraveDetail:",
                                            @"btnTag":[NSString stringWithFormat:@"%ld",(long)dayFlage],
                                           @"target":self}];
    TravelingModel *model = [TravelingModel createTravelingModelWithDict:mutDict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0,scrollH,width,75))];
    dayFlage+=10000;
    
    [_scrollView addSubview:model];
    [self.viewArray addObject:model];
    
    size.height = CGRectGetMaxY(model.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark - 添加预定须知
- (void)addBodyViewWithDic:(NSDictionary *)dict style:(NSInteger)style bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    BodyModel *model = [BodyModel createBodyModelWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(20, scrollH, width - 40, 10)) style:style];
    
    [_scrollView addSubview:model];
    [self.viewArray addObject:model];
    
    size.height = CGRectGetMaxY(model.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark - 添加线路推荐
- (RouteRecommendationView *)addRouteRecommendationViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    RouteRecommendationView *model = [RouteRecommendationView createRouteRecommendationViewWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 75))];
    model.tag = [dict intValue:@"tag"];
    SEL method = NSSelectorFromString([dict objectForKey:@"method"]);
    [model addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    model.userInteractionEnabled = YES;
    [_scrollView addSubview:model];
    [self.viewArray addObject:model];
    
    size.height = CGRectGetMaxY(model.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
    
    return model;
}

#pragma mark 动态计算label的size,并添加到scrollView上
//字符串的最大宽度为label的最大宽度,只改变它的y坐标和size大小(只改变y坐标和高度)
-(void)resizeLabelSize:(UILabel *)label text:(NSString *)text bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    
    CGSize contentSize = [Utility getSizeFormString:text maxW:CGRectGetWidth(label.frame) font:label.font];
    
    CGRect labelFrame = label.frame;
    labelFrame.origin.y = YGLY_VIEW_FLOAT(scrollH);
    labelFrame.size.height = contentSize.height;
    label.frame = labelFrame;
    label.text = text;
    
    size.height = CGRectGetMaxY(label.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
    
}
#pragma mark 添加吃住游购展示视图cell
-(void)addCZYGCellWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    CZYGCell *cell = [CZYGCell createCZYGCellWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 30))];
    
    [_scrollView addSubview:cell];
    [self.viewArray addObject:cell];
    
    size.height = CGRectGetMaxY(cell.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark - 添加一个 风景图片展示cell
- (void)addSenceImageViewCellWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    //取上一次view最大的y值作为这一次的最小y值
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    SenceImageViewCell *cell = [SenceImageViewCell createSenceImageViewCellWithDict:dict frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 336))];
    cell.delegate = self;
  
    [_scrollView addSubview:cell];
    [self.viewArray addObject:cell];
    
    size.height = CGRectGetMaxY(cell.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark 添加一个用来显示文本与图片的视图，文字在上图片在下
-(TextAndPhotoShowView *)addTextAndPhotoViewWithDic:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace addGesture:(UIGestureRecognizer *)gesture{
    
    //取上一次view最大的y值作为这一次的最小y值
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;

    CGRect rect = {{0,scrollH},{width,50}};
    TextAndPhotoShowView *tp = [TextAndPhotoShowView CreateTextAndPhotoShowViewWithDic:dict frame:YGLY_VIEW_FRAME_ALL(rect)];
    if (gesture) {
        [tp addGestureRecognizer:gesture];
    }
    [_scrollView addSubview:tp];
    [self.viewArray addObject:tp];
    
    size.height = CGRectGetMaxY(tp.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
    return tp;
}

#pragma mark 添加一个用来显示倒计时的view
-(void)addTimeViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    //默认时间label在左边显示
    //取上一次view最大的y值作为这一次的最小y值
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGRect rect = {{20,scrollH},{270,58}};
    LHScrollNumView *scrollNumber  = [LHScrollNumView CreateLHScrollNumView:YGLY_VIEW_FRAME_ALL(rect) diff:2.5 num:3 numberSize:2 bgColor:[Utility hexStringToColor:[dict strValue:@"bgColor"]]];
    
    if ([dict dateValue:@"expiredDate"]) {
        
        [scrollNumber setExpiredDate:[dict dateValue:@"expiredDate"]];
    }
    
    scrollNumber.delegate = self;
    [self.scrollView addSubview:scrollNumber];
    
    size.height = CGRectGetMaxY(scrollNumber.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
    
}

#pragma mark 添加预定码
-(void)addYuDingMaViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace{
    
    [self addYuDingMaViewWithDict:dict bSpace:bSpace eSpace:eSpace delegate:nil];
}
//确保delegate 是OrderDetailsView对象
-(void)addYuDingMaViewWithDict:(NSDictionary *)dict bSpace:(CGFloat)bSpace eSpace:(CGFloat)eSpace delegate:(id<YuDingMaDelegate>)delegate{
    
    CGSize size = _scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE + bSpace;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    
    CGRect rect = {{0,scrollH},{width,65}};
    YuDingMa *t = [YuDingMa createYuDingMaWithDict:dict frame:YGLY_VIEW_FRAME_ALL(rect)];
    t.delegate = delegate;
    [_scrollView addSubview:t];
    [self.viewArray addObject:t];
    
    size.height = CGRectGetMaxY(t.frame) + YGLY_VIEW_FLOAT(eSpace);
    _scrollView.contentSize = size;
}
#pragma mark 当item不足时，为了好看，该方法可设置显示的item居中
-(void)setCollectionViewCenter:(UICollectionView *)collV{
    
    //collv 必需只有一行且水平滚动
    NSInteger total = [collV.dataSource collectionView:collV numberOfItemsInSection:1];
    CGFloat minX = MAXFLOAT,maxX = -1;
    for (NSInteger i = 0; i < total; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewCell *cell = [collV.dataSource collectionView:collV cellForItemAtIndexPath:indexPath];
        
        minX = MIN(minX, CGRectGetMinX(cell.frame));
        CGFloat tmpX = MAX(maxX, CGRectGetMaxX(cell.frame));
        maxX = tmpX;
    }
    
    if (maxX > collV.size.width) {
        return;
    }
    CGRect frame = collV.frame;
    frame.size.width = maxX-minX;
    CGFloat diff = (CGRectGetWidth(_scrollView.frame) - frame.size.width)/2;
    frame.origin.x = diff;
    collV.frame = frame;
}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
#pragma mark- collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark-SenceImageViewCellDelegate
-(void)senceImageViewCellClicked:(NSIndexPath *)indexPath{
    //选中某个cell
}
-(void)timeDidStop{
    //时间停止时调用
}

#pragma mark 进入行程详情页
-(void)gotoTraveDetail:(id)sender{
    EBLog(@"行程详情");
}

@end
