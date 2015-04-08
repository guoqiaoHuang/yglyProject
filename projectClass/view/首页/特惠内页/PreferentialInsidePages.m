//
//  PreferentialInsidePages.m
//  yglyProject
//
//  Created by 枫 on 14-10-31.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "PreferentialInsidePages.h"
#import "HBJUILabel.h"
#import "LeaderAndFriendCell.h"
#import "LeaderAndFriendFlowLayout.h"
#import "LineFeaturesView.h"
#import "TraveDetaillView.h"
#import "MainViewController.h"

@interface PreferentialInsidePages ()

@property(nonatomic,assign)UICollectionView *leaderCollectionView;
@property(nonatomic,assign)UICollectionView *togetherCollectionView;
@end

@implementation PreferentialInsidePages

-(void)loadView{
    
    [self initScrollViewWithBottomHeight:0];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[  @"",@"640x250默认图片.png",
                                                                @"#336699",@"优惠",
                                                                @"",@"#ffffff",@"#99ccff",
                                                                @"",@"",@"",
                                                                @"景色图黑底衬.png",@"行程：两天一夜",@"￥ 28元/人",@"1"]
                         
                                                    forKeys:@[  @"senceUrl",@"defaultSence",
                                                                @"leftTopColor",@"leftTopText",
                                                                @"expiredDate",@"timeTextColor",@"timeBGColor",
                                                                @"rightImageName",@"rightImageViewTopText",@"rightImageViewBellowText",
                                                                @"belloImageName",@"bellowTitle",@"belloSubTitle",@"bellowLabelStyle"]];
    
    [self addSenceImageViewWithDic:dic bSpace:0 eSpace:0];
    [self showUIViewList:@"UIView" index:0 uiview:self.scrollView];
    
    CGSize scrollSize = self.scrollView.contentSize;
    scrollSize.height += [self viewWithTag:611].frame.size.height;
    self.scrollView.contentSize = scrollSize;
    
     NSDictionary *timeDict = @{@"expiredDate":[NSDate dateWithTimeIntervalSinceNow:30],@"bgColor":@"#a5c8ec"};
    [self addTimeViewWithDict:timeDict bSpace:20 eSpace:20];
    //设置scrollView的contentSize
    UIView *view = [self viewWithTag:614];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(view.frame));
    
    [self showUILabelList:@"UILabel" index:0 uiview:self.scrollView];
    [Utility addBevel:[self viewWithTag:412] ahScale:0.5];
    [self showButtonList:@"Buttons" index:0 uiview:self.scrollView];
    [self showColorButtonList:@"ColorButtons" index:0 uiview:self.scrollView];
    //设置colorbutton的textLabel
    UIButton *button = (UIButton *)[self viewWithTag:211];
    CGSize size = [button.titleLabel splitToLine:2];
    CGFloat top = (button.size.height - size.height) / 2.0;
    CGFloat left = (button.size.width - size.width) / 2.0;
    button.titleEdgeInsets = UIEdgeInsetsMake(top, left-5, top, left-5);
    button.titleLabel.frame = button.bounds;
    button.titleLabel.numberOfLines = 2;
    
    CGSize contentSize = {CGRectGetWidth(self.frame),YGLY_VIEW_FLOAT(620.0)};
    self.scrollView.contentSize = contentSize;
/*#warning leaderCollectionView
    self.leaderCollectionView = [self addCollectionViewWithReuseIdentifier:@"LeaderCell" collectionViewFlowLayout:[[[LeaderAndFriendFlowLayout alloc] init] autorelease]collectionViewCellClass:[LeaderAndFriendCell class] bSpace:80 eSpace:20];
    [self setCollectionViewCenter:_leaderCollectionView];
    
    UILabel *label1 = (UILabel *)[self viewWithTag:419];
    NSMutableAttributedString *atString = [[[NSMutableAttributedString alloc] initWithString:label1.text] autorelease];
    [atString setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSRangeFromString([NSString stringWithFormat:@"{%d,%d}",4,5])];
    label1.attributedText = atString;
*/
    NSDictionary *headDic = [NSDictionary dictionaryWithObjects:@[@"#336699",
                                                                  @"路线特色",
                                                                  @"jiantou.png"]
                             
                                                        forKeys:@[  @"bgColor",
                                                                    @"labelText",
                                                                    @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:20 eSpace:20];
    
    NSDictionary *dict = @{@"text":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延。我不相信佛，只是喜欢玄冥空灵的梵音经贝，与慈悲淡然的佛境禅心，在清欢中，从容幽静，自在安然。一直向往走进青的山，碧的水，体悟山水的绚丽多姿，领略草木的兴衰荣枯，倾听黄天厚土之声，探寻宇宙自然的妙趣。走进了山水，也就走出了喧嚣，给身心以清凉，给精神以沉淀，给灵魂以升华。",
                           @"defaultImage":@"",
                           @"imgUrl":@""};
    [self addTextAndPhotoViewWithDic:dict bSpace:0 eSpace:20 addGesture:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLineFeaturesView)] autorelease]];
    
    headDic = [NSDictionary dictionaryWithObjects:@[@"#336699",
                                                    @"行程说明",
                                                    @"jiantou.png"]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
    
    NSDictionary *dayDict = @{@"lineColor":@"",
                              @"headBGColor":@"",
                              @"leftImage":@"D1.png",
                              @"headText":@"西安-保农谷",
                              @"bodyDict":@{@"吃":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                                            @"住":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                                            @"行":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟"}};
    [self addTravelingViewWithDic:dayDict bSpace:0 eSpace:20];
    
    dayDict = @{@"lineColor":@"",
                @"headBGColor":@"",
                @"leftImage":@"D2.png",
                @"headText":@"西安-保农谷",
                @"bodyDict":@{@"吃":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                              @"住":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                              @"交通情况":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟"}};
    [self addTravelingViewWithDic:dayDict bSpace:0 eSpace:20];
    
    headDic = [NSDictionary dictionaryWithObjects:@[@"#336699",
                                                    @"预订须知",
                                                    @"jiantou.png"]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
    
    NSDictionary *yudingDict = @{@"报名须知":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                                 @"装备要求":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟",
                                 @"费用说明":@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟"};
    [self addBodyViewWithDic:yudingDict style:1 bSpace:0 eSpace:20];
    
    headDic = [NSDictionary dictionaryWithObjects:@[@"#336699",
                                                    @"一起玩",
                                                    @"jiantou.png"]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:20];
#warning togetherCollectionView
    self.togetherCollectionView = [self addCollectionViewWithReuseIdentifier:@"FriendsCell" collectionViewFlowLayout:[[[LeaderAndFriendFlowLayout alloc] init] autorelease] collectionViewCellClass:[LeaderAndFriendCell class] bSpace:0 eSpace:20];
    [self setCollectionViewCenter:_togetherCollectionView];
   
}

-(void)showView{
    
    [super showView];
    //  [self showLoadMsg:@"页面信息加载中。。。"];
    [[MainViewController sharedViewController] showLoad:self];
    //    [self.controller showLoad];
    [Utility delay:2.0 action:^{
        [[MainViewController sharedViewController] endLoad];
        [self loadView];
    }];
    
}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LeaderAndFriendCell *cell = nil;
    if ([collectionView isEqual:_leaderCollectionView]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeaderCell" forIndexPath:indexPath];
        cell.defaultImage = @"leader.png";
        cell.title = @"领队小花";
    }
    if ([collectionView isEqual:_togetherCollectionView]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCell" forIndexPath:indexPath];
        if (indexPath.row == 9) {
            
            [cell.button setImage:[Utility getImageByName:@"加入默认.png"] forState:UIControlStateNormal];
            [cell.button setImage:[Utility getImageByName:@"加入按下.png"] forState:UIControlStateSelected];
            cell.title = @"加入";
            cell.button.userInteractionEnabled = YES;
            
        }else{
            cell.defaultImage = @"leader.png";
            cell.title = @"胡清水";
        }
    }
    return cell;
}

#pragma mark- collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if ([collectionView isEqual:_togetherCollectionView]) {
    //
    //        if (indexPath.row == 9) {
    //            EBLog(@"------获取用户头像-----");
    //        }
    //    }
}
#pragma mark
- (void)joinBtnClicked:(id)sender{
    EBLog(@"参加");
}
#pragma mark-打电话
- (void)callBtnClicked:(id)sender{
    
    EBLog(@"打电话");
    [Utility callPhone:@"10086"];
}
#pragma mark-意见反馈
- (void)feedbackBtnClicked:(id)sender{
    
    EBLog(@"意见反馈");
}

#pragma mark 进入路线特色详情页
- (void)gotoLineFeaturesView{
    
    LineFeaturesView*t = [[[LineFeaturesView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}
#pragma mark 进入行程详情页
-(void)gotoTraveDetail:(id)sender{
    
    NSInteger day = ((UIButton *)sender).tag/10000;
    
    TraveDetaillView*t = [[[TraveDetaillView alloc]initWithFrame:self.frame] autorelease];
    t.day = day;
    t.controller = self.controller;
    [t.controller push:t atindex:6];
    
    EBLog(@"day----%ld",(long)day);
}
#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}
@end
