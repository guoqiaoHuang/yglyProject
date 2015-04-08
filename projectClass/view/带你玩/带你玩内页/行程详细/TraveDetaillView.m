//
//  TraveDetaillView.m
//  yglyProject
//
//  Created by 枫 on 14-10-29.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "TraveDetaillView.h"
#import "MainViewController.h"
#import "ActivityCell.h"
#import "ActivityFlowLayout.h"
#import "LhNoticeMsg.h"
#import "TableHeaderView.h"
@interface TraveDetaillView ()<UIScrollViewDelegate>
{
    TextAndPhotoShowView *_tp;
    CGFloat lastOffset;
    CGFloat _tpMaxY;
    CGFloat _beginY;
    CGFloat _endY;
    TableHeaderView *_headerView;
}
@end

@implementation TraveDetaillView

-(void)dealloc{
    
    if (_headerView) {
        [_headerView release];_headerView = nil;
    }
    [super dealloc];
}
#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{

    [self loadView:dict];
    [[MainViewController sharedViewController] endLoad];
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance]ShowMsg:@"数据加载失败"];
}

-(void)setDay:(NSInteger)day{
    _day =day;
    if(_day == 1){
 //       self.image = [Utility getImageByName:@"行程详细BG-1.jpg"];
    }
    if(_day == 2){
  //      self.image = [Utility getImageByName:@"行程详细BG-2.jpg"];
    }
    [self LHWillDVSwitchDid:nil index: _day-1];
    
}
-(void)setDayNum:(NSInteger)num dayIndx:(NSInteger)dayIndx{
    self.day = dayIndx;
    if (num >1 && num <= 3) {
        [self showDVSwitchList:@"DVSwitch" index:num -2];
        DVSwitch*tdv= (DVSwitch*)[self viewWithTag:20611];
        [tdv forceSelectedIndex:dayIndx-1 animated:NO];
    }else{
        CGSize size = self.scrollView.size;
        size.height += 25;
        self.scrollView.size = size;
        self.scrollView.point = CGPointMake(0, self.scrollView.point.y - 25);
        
        UIView*t = [self viewWithTag:711];
        t.hidden = YES;
    }
}
-(void)loadView:(NSDictionary*)alldict{
    
    self.scrollView.delegate = nil;
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:[alldict strValueDeleteReturn:@"xctw" ] forKey:@"text"];
    [dic setObject:[alldict strValue:@"xcimg" default:@""] forKey:@"imgUrl"];
    [dic setObject:@"640x250默认图片.png" forKey:@"defaultImage"];
    [dic setObject:@"#ececec" forKey:@"bgColor"];
    [dic setObject:@"0.0" forKey:@"topOffset"];
    [dic setObject:@"0.0" forKey:@"bottomOffset"];
    [dic setObject:@"1" forKey:@"style"];
    _tp = [self addTextAndPhotoViewWithDic:dic bSpace:0 eSpace:0 addGesture:nil];
    _tpMaxY = CGRectGetMaxY(_tp.frame);
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += YGLY_VIEW_FLOAT(20);
    self.scrollView.contentSize = contentSize;
    
    if (!_headerView) {
        
        _headerView = [[TableHeaderView alloc] init];
    }
    [_headerView stretchHeaderForTableView:self.scrollView withView:_tp.imageView];
    _tp.clipsToBounds = NO;
    
    NSDictionary *imgDict = @{@"3450":@"活动.png",
                              @"3451":@"食物.png",
                              @"3452":@"住宿.png",
                              @"3453":@"交通工具.png",
                              @"3478":@"推荐景点.png",
                              @"3479":@"其他.png"};
    NSArray*values =[alldict objectForKey:@"xcxq"];
    for (int i = 0; i < values.count; i++) {
        [dic removeAllObjects];
        NSString *key = [values[i] objectForKey:@"types"];
        if (key) {
             [dic setObject:[imgDict strValue:key default:@""] forKey:@"leftTopImage"];
        }
        NSDictionary*d = @{[values[i]strValueDeleteReturn:@"name"]:[values[i]strValueDeleteReturn:@"content"]};
        [dic setObject:d forKey:@"bodyDict"];
        if (i != values.count-1) {
            [dic setObject:@"1" forKey:@"bellowLineHidden"];
        }
        [self addCZYGCellWithDic:dic bSpace:0 eSpace:0];
    }
    
}

-(void)showView{
    
    [super showView];
    [self showUIViewList:@"UIView" index:0];
    [self insertSubview:[self viewWithTag:711] belowSubview:self.naviView];
    
    [self initScrollViewWithBottomHeight:0];
    self.scrollView.alwaysBounceVertical = YES;
    
}

#pragma mark DVSwitchDelegate
- (void)LHDVSwitchDid:(DVSwitch*)view index:(int)index{
    
//    [[MainViewController sharedViewController] showLoad:self];
}
- (void)LHWillDVSwitchDid:(DVSwitch*)view index:(NSInteger)index{
    _day = index + 1;
    
    [self clearViewByViews:self.scrollView.subviews];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_headerView) {
        [_headerView release];_headerView = nil;
    }
    CGSize scrolContentSize = self.size;
    scrolContentSize.height = YGLY_VIEW_FLOAT(50+3);
    self.scrollView.contentSize = scrolContentSize;
    
    [[VIewDadaGet sharedGameModel] TakeXcxqInfo:self.tag  daynum:self.day  delegate:self];
    [[MainViewController sharedViewController] showLoad:self];
}
#pragma mark- collectionView dataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"activity" forIndexPath:indexPath];
    return cell;
}

#pragma mark- collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EBLog(@"---%ld----选中-", (long)indexPath.row);
}

#pragma mark-scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _beginY = scrollView.contentOffset.y;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _endY = scrollView.contentOffset.y;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    if(offset.y <= _tpMaxY && offset.y >= 0 &&(_beginY - _endY) < 0){
        
        CGPoint point = {0,_tpMaxY-20};
        scrollView.decelerationRate = 5.0;
        [scrollView setContentOffset:point animated:YES];
    }else if(offset.y <= _tpMaxY && offset.y >= 0 && (_beginY - _endY) > 0){
       
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    if(offset.y <= _tpMaxY && offset.y >= 0){
   
        CGRect rect = _tp.frame;
        _tp.contentMode = UIViewContentModeScaleAspectFill;
        rect.origin.y += (offset.y - lastOffset)*0.5;
        rect.size.height -= (offset.y - lastOffset)*0.5;
        _tp.frame  = rect;
        lastOffset = offset.y;
        
    }
   
    
}

#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}
@end
