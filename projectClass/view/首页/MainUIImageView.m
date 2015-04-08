#import "MainUIImageView.h"
#import "Utility.h"
#import "HBJCycleScrollView.h"
#import "DownloadUIImageView.h"
#import "SenceImageViewCell.h"
#import "MJRefresh.h"
#import "TakePlayInsidePages.h"
#import "ShowAllControl.h"
#import "PreferentialInsidePages.h"

#import "MapView.h"
#import "LunBoImage.h"
#import "NewsGuDong.h"
#import "VIewDadaGet.h"
#import "MainViewController.h"

#import "TableHeaderView.h"
#import "GlobalModel.h"
#import "LhLocationModel.h"

#import "LhNoticeMsg.h"
#ifndef _SHOU_YE_MICRO_
#define _LUN_BO_ 0
#define _TSWF_ 1
#define _ZTHD_ 2
#define _DNW_ 3
#endif

@interface MainUIImageView ()<HBJCycleScrollViewDatasource,HBJCycleScrollViewDelegate,UIScrollViewDelegate,SenceImageViewCellDelegate,SenceImageViewDelegate,VIewDadaGetDelegate>
{
    NSInteger imageFlage;//两列图片展示标识
}
@property(nonatomic,retain)NSMutableArray *lunboArray;//伦博图
@property(nonatomic,retain)NSMutableArray *tswfArray; //特色玩法
@property(nonatomic,retain)NSMutableArray *zthdArray;//主题活动
@property(nonatomic,retain)NSMutableArray *dnwArray;//带你玩
@property(nonatomic,retain)TableHeaderView *tableHeader;
@end

@implementation MainUIImageView
-(void)dealloc{
    
    self.lunboArray = nil;
    self.tswfArray = nil;
    self.zthdArray = nil;
    self.dnwArray = nil;
    self.tableHeader = nil;
    [super dealloc];
}
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    [[MainViewController sharedViewController] endLoad];
    imageFlage = 0;//reset
    if ([apiKey isEqualToString:app_shouye_data]) {
        
        [self loadViewWithDict:dict];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"没有该城市的信息"];
}

-(void)viewdidHidden{
    [_csView pauseTimer];
}

-(void)viewdidShow{
    [_csView resumeTimer];
    [self scrollViewDidScroll:self.scrollView];
}

-(id)initWithFrame:(CGRect)frame{
    [super initWithFrame: frame];
    
    return self;
}

-(void)loadViewWithDict:(NSDictionary *)dict{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.lunboArray = dict[@"lunbo"];
    [self initHBJScrollView];
    self.tableHeader = [[[TableHeaderView alloc] init] autorelease];
    [_tableHeader stretchHeaderForTableView:self.scrollView withView:self.scrollView.subviews.lastObject];
    UIView *view = (UIView *)[self viewWithTag:214];
    [self.scrollView addSubview:view];
    
    self.tswfArray = dict[@"tswf"];
    self.dnwArray = dict[@"dnw"];
    self.zthdArray = dict[@"zthd"];
    
    NSDictionary *headDic;
    if (_tswfArray.count > 0) {
        headDic = [NSDictionary dictionaryWithObjects:@[@"#009933",
                                                                      @"当季去哪玩",
                                                                      @"jiantou.png"]
                                 
                                                            forKeys:@[  @"bgColor",
                                                                        @"labelText",
                                                                        @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:20 eSpace:17];
    }
    [_tswfArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
         NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:10];
            
            [dic setObject:[obj strValue:@"listimg" default:@""] forKey:@"senceUrl"];
            [dic setObject:@"640x250默认图片.png" forKey:@"defaultSence"];
            [dic setObject:@"rightImage-1.png" forKey:@"rightImageName"];
            [dic setObject:@"想玩" forKey:@"rightImageViewTopText"];
            [dic setObject:@"去哪儿呢" forKey:@"rightImageViewBellowText"];
            [dic setObject:[NSIndexPath indexPathForItem:idx inSection:_TSWF_] forKey:@"indexPath"];
        
            [self addSenceImageViewWithDic:dic bSpace:0 eSpace:20 delegate:self];
    }];
    
    if (_zthdArray.count > 0) {
        headDic = [NSDictionary dictionaryWithObjects:@[@"#f15b29",
                                                                  @"主题活动",
                                                                  @"jiantou.png"]
                             
                                                        forKeys:@[  @"bgColor",
                                                                    @"labelText",
                                                                    @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:17];
    }
    [_zthdArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        [dic setObject:[obj strValue:@"listimg" default:@""] forKey:@"senceUrl"];
        [dic setObject:@"640x250默认图片.png" forKey:@"defaultSence"];
        [dic setObject:@"rightImage-2.png" forKey:@"rightImageName"];
        [dic setObject:@"吃和玩" forKey:@"rightImageViewTopText"];
        [dic setObject:@"有意思吧" forKey:@"rightImageViewBellowText"];
        [dic setObject:[NSIndexPath indexPathForItem:idx inSection:_ZTHD_] forKey:@"indexPath"];
        
        [self addSenceImageViewWithDic:dic bSpace:0 eSpace:20 delegate:self];
    }];
    
    if (_dnwArray.count > 0) {
        headDic = [NSDictionary dictionaryWithObjects:@[@"#336699",
                                                    @"路线推荐",
                                                    @"jiantou.png"]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:0 eSpace:17];
    }
    [_dnwArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
        [dic setObject:[obj strValue:@"listimg" default:@""] forKey:@"senceUrl"];
        [dic setObject:@"首页-线路推荐默认图片.png" forKey:@"defaultSence"];
        [dic setObject:@"景色图黑底衬.png" forKey:@"belloImageName"];
        [dic setObject:[obj strValue:@"mobile_title" default:@""] forKey:@"bellowTitle"];
       // [dic setObject:[obj strValue:@"mobile_title" default:@""] forKey:@"belloSubTitle"];
        [dic setObject:@"2" forKey:@"bellowLabelStyle"];
        [dic setObject:[NSIndexPath indexPathForItem:idx inSection:_DNW_] forKey:@"indexPath"];
        [self addSenceImageViewWithDic:dic];
    }];
    
}
-(void)showView{
    
   
    [super showView];
    [self initScrollViewWithBottomHeight:88];
    
    if([GlobalModel sharedGameModel].isFirstLogin){
        [[MainViewController sharedViewController] showLoad:self];
        [[VIewDadaGet sharedGameModel] ShouYeDataWithDelegate:self];
    }else{
        [Utility delay:1.0 action:^{
            [[MainViewController sharedViewController] showLoad:self];
            [[VIewDadaGet sharedGameModel] ShouYeDataWithDelegate:self];
        }];
    }
    
    
//    [self initRefreshControl];
//    [self.scrollView headerBeginRefreshing];
    [self updateButonState:[GlobalModel isLogin]];
}


- (void)initHBJScrollView{
    
    CGSize size = CGSizeZero;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE;
    CGFloat width = CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE;
    //305
    _csView = [[[HBJCycleScrollView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, scrollH, width, 200))] autorelease];
    _csView.datasource = self;
    _csView.delegate   = self;
    _csView.autoScroll = YES;
    _csView.interval = 3.0f;
    _csView.showPageControlView = YES;
    
    [self.scrollView addSubview:_csView];
    [self.viewArray addObject:_csView];
    
    size.height = CGRectGetMaxY(_csView.frame);
    self.scrollView.contentSize = size;
}

- (void)initRefreshControl{
    
    [self.scrollView addHeaderWithTarget:self action:@selector(headerRefresh:)];

}
- (void)headerRefresh:(id)sender{
    
    [[MainViewController sharedViewController] showLoad:self];
    [[VIewDadaGet sharedGameModel] ShouYeDataWithDelegate:self];
//    //两秒后刷新数据
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.scrollView headerEndRefreshing];
//    });
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [super searchBarSearchButtonClicked:searchBar];
    
    //开始搜索；
}

-(CATransition*)getReplace{
    
    return  nil;
}

#pragma mark -
#pragma mark HBJCycleScrollView-dataSoutce
-(NSInteger)numberOfPagesInCycleScrollView
{
    return [_lunboArray count];
}
-(UIView *)cycleScrollView:(HBJCycleScrollView *)cycleScrollView pageAtIndex:(NSInteger)index
{
    NSDictionary *dict = [_lunboArray objectAtIndex:index];
    UIImageView *imageView = [DownloadUIImageView Create:[dict strValue:@"thumb"] defauleImage:@"640x250默认图片.png"];
    imageView.frame = cycleScrollView.bounds;
    return imageView;
}
#pragma mark HBJCycleScrollView-delegate
-(void)cycleScrollView:(HBJCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    EBLog(@"---scrollView--%ld---",(long)index);
    //测试地图
    [self senceCliked:[NSIndexPath indexPathForItem:index inSection:_LUN_BO_]];
}
-(NSString *)cycleScrollView:(HBJCycleScrollView *)cycleScrollView showTextAtIndex:(NSInteger)index
{
     NSDictionary *dict = [_lunboArray objectAtIndex:index];
    return dict[@"title"];
}

#pragma mark - ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     static BOOL flage = NO;//是否已经执行某个方法
    
    if (scrollView.contentOffset.y > CGRectGetHeight(_csView.frame)) {
        if (!flage) {
            [_csView pauseTimer];
            flage = YES;
        }
    }else{
        if (flage) {
            [_csView resumeTimer];
            flage = NO;
        }
    }
}

#pragma mark - removeFormSuperView
-(void)removeFromSuperview{
    
    self.scrollView.delegate = nil;
    _csView.delegate = nil;
    _csView.datasource = nil;
    [super removeFromSuperview];
}

#pragma mark - 添加一个 风景图片展示 - 两列展示
- (void)addSenceImageViewWithDic:(NSDictionary *)dict{
    
    CGSize size = self.scrollView.contentSize;
    CGFloat scrollH = size.height/YGLY_SIZE_SCALE;
    
    //取上一次view最大的y值作为这一次的最小y值
    static CGFloat lastYPosition;//保存上一次该类图片
    
    CGRect rect = CGRectZero;
    if (imageFlage % 2 == 0) {
        
        rect = YGLY_VIEW_FRAME_ALL(CGRectMake(20, scrollH, 295, 295));
        
        lastYPosition = self.scrollView.contentSize.height;
        size.height = CGRectGetMaxY(rect) + YGLY_VIEW_FLOAT(10);
        self.scrollView.contentSize = size;
    }else{
        
        rect = YGLY_VIEW_FRAME_ALL(CGRectMake(325, lastYPosition/YGLY_SIZE_SCALE, 295, 295));
    }
    SenceImageView *senceImageView = [SenceImageView createSenceImageFromDictionary:dict frame:rect];
    senceImageView.belowTitleLabel.font = [UIFont systemFontOfSize:14];
    senceImageView.delegate = self;
    [self.scrollView addSubview:senceImageView];
    [self.viewArray addObject:senceImageView];
    
    imageFlage++;
}
#pragma mark senceImageViewCellDelegate
-(void)senceImageViewCellClicked:(NSIndexPath *)indexPath{
    ;
}
-(void)timeDidStop{
    
}
#pragma mark senceImageViewDelegate
-(void)senceCliked:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case _LUN_BO_:
        {
            
            NSDictionary *dict = self.lunboArray[indexPath.row];
            if ([dict intValue:@"cid"]) {
                [[MainViewController sharedViewController] showViewByIdAndType:[dict intValue:@"xid"] typeValue:[dict intValue:@"cid"]];
            }else{
                [Utility openUrl:[dict strValue:@"url" default:@""] controller:self.controller flag:NO];
            }
        }
            break;
        case _TSWF_:
        {
            NSDictionary *dict = self.tswfArray[indexPath.row];
            [[MainViewController sharedViewController] showViewByIdAndType:[dict intValue:@"id"] typeValue:[dict intValue:@"catid"]];
            
        }
            break;
        case _ZTHD_:
        {
             NSDictionary *dict = self.zthdArray[indexPath.row];
            [[MainViewController sharedViewController] showViewByIdAndType:[dict intValue:@"id"] typeValue:[dict intValue:@"catid"]];
        }
            break;
        case _DNW_:
        {
            
            
           NSDictionary *dict = self.dnwArray[indexPath.row];
            [[MainViewController sharedViewController] showViewByIdAndType:[dict intValue:@"id"] typeValue:76];
        }
            break;
        default:
            break;
    }

}

-(void)controlBtn:(id)sender{
    
    NewsGuDong *t = [[[NewsGuDong alloc] initWithFrame:self.bounds] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:10];
    
}

#pragma mark 注销/登陆
-(void)logoutClicked:(UIButton*)sender{
    [[GlobalModel sharedGameModel]userLogout];
}


-(void)updateButonState:(BOOL)flag{
    UIView*t = [self viewWithTag:212];
    t.hidden = flag;
    t = [self viewWithTag:213];
    t.hidden = flag;
    t = [self viewWithTag:90214];
    t.hidden = !flag;
}

#pragma mark 事件回调通知
-(void)receiveNotifications:(NSInteger)type{
    if (type == YGLYNoticeTypeLogoutSuccess) {
        [self updateButonState:NO];
    }else if(type == YGLYNoticeTypeLoginSuccess){
        [self updateButonState:YES];
    }else if (type == YGLYNoticeTypeLocationDidChange){
        
        self.tableHeader = nil;
        [self clearViewByViews:self.scrollView.subviews];
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[MainViewController sharedViewController] showLoad:self];
        [[VIewDadaGet sharedGameModel] ShouYeDataWithDelegate:self];
        
        [super receiveNotifications:type];
    }
}

@end
