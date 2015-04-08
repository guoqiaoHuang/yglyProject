#import "SubjectToPlayView.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "BackTitleUIImageView.h"
#import "AlerView.h"
#import "FeaturePlayInnerView.h"
#import "ThematicPlayInnerView.h"
#import "MainViewController.h"
#import "DVSwitch.h"
#import "SenceImageView.h"
#import "LhNoticeMsg.h"

static NSString *const MJTableViewCellIdentifier = @"senceCell";
@implementation SubjectToPlayView
#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    if (type != [dict intValue:@"zhuti_type"]) {
        [[MainViewController sharedViewController] endLoad];
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        return;
    }
    
    NSMutableArray*tmpCacheData = nil;
    if (type == 1) {
        tmpCacheData = self.featureFakeData;
    }else{
        tmpCacheData = self.thematicFakeData;
    }
    
    flagStop = [dict intValue:@"page_next"];
    page = [dict intValue:@"page"];
    
   
    NSInteger num = tmpCacheData.count;
    int i = 0;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSArray *arrays = [dict objectForKey:@"info"];
    for (NSDictionary*dic in arrays) {
        NSMutableDictionary *celDic = [NSMutableDictionary dictionaryWithCapacity:8];
        [celDic setObject:@"主题玩默认图片.png" forKey:@"defaultSence"];
        [celDic setObject:[dic objectForKey:@"listimg"] forKey:@"senceUrl"];
        [celDic setObject:[dic objectForKey:@"mobile_title"] forKey:@"bellowTitle"];
        [celDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
        [tmpCacheData addObject:celDic];
        [array addObject:[NSIndexPath indexPathForRow:num+i++ inSection:0]];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
    if(array.count < 1){
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    [self.tableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance]ShowMsg:@"数据加载失败"];
}



-(void)showView{
    page = 0;
    type = 2;
    self.featureFakeData = [NSMutableArray array];
    self.thematicFakeData = [NSMutableArray array];
    [super showView];
    [self showUISegmentedControlList :@"UISegmentedControl" index:0];
  //  UISegmentedControl *seg = (UISegmentedControl *)[self viewWithTag:13001];
    //[seg sendActionsForControlEvents:UIControlEventValueChanged];
    self.backgroundColor = [UIColor whiteColor];
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 90, self.size.width, self.size.height -134) style:UITableViewStyleGrouped]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView registerClass:[SenceCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    // 2.集成刷新控件
    [self setupRefresh];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [[VIewDadaGet sharedGameModel]ZhuTiList:type page:++page delegate:self];
    [[MainViewController sharedViewController] showLoad:self];
}

#pragma 集成刷新控件
- (void)setupRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing{
    if (!flagStop) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        [self.tableView footerEndRefreshing];
        return;
    }
    [[VIewDadaGet sharedGameModel]ZhuTiList:type page:++page delegate:self];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YGLY_VIEW_FLOAT(440);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *tmpArray = type==1?self.featureFakeData:self.thematicFakeData;
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SenceCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *tmpArray = type==1?self.featureFakeData:self.thematicFakeData;
    NSDictionary *dic = [tmpArray objectAtIndex:indexPath.row];
    [cell setWithDict:dic];
    
    if (type == 2) {//表示特色玩法
        [cell.senceImageView.belowTitleLabel hide];
    }else if (type == 1){
        [cell.senceImageView.belowTitleLabel show];
    }
    
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *tmpArray = type==1?self.featureFakeData:self.thematicFakeData;
    NSDictionary *dic = [tmpArray objectAtIndex:indexPath.row];
    BaseUIImageView *t = nil;
    if (type==1) {
        FeaturePlayInnerView*view = [FeaturePlayInnerView alloc];
        view.tag = [dic intValue:@"id"];
        view.selfCatid= 114;
        [[view initWithFrame:self.bounds] autorelease];
        t = view;
        
    }else{
        ThematicPlayInnerView*view = [ThematicPlayInnerView alloc];
        view.tag = [dic intValue:@"id"];
        view.selfCatid= 23;
        [[view initWithFrame:self.bounds] autorelease];
        t = view;
    }
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}



-(CATransition*)getReplace{
    return nil;
}

#pragma mark 切换类型
-(void)btnClicked:(UISegmentedControl *)Seg{
//    if (type == (Seg.selectedSegmentIndex+1)) {
//        return;
//    }
    [self.featureFakeData removeAllObjects];
    [self.thematicFakeData removeAllObjects];
    type = Seg.selectedSegmentIndex+1;
    page = 0;
    [[VIewDadaGet sharedGameModel]ZhuTiList:type page:++page delegate:self];
    [self.tableView reloadData];
    [[MainViewController sharedViewController] showLoad:self];
}

#pragma mark- 城市该变通知
-(void)receiveNotifications:(NSInteger)atype{
    
    if (atype == YGLYNoticeTypeLocationDidChange) {
        UISegmentedControl *seg = (UISegmentedControl *)[self viewWithTag:13001];
        [seg sendActionsForControlEvents:UIControlEventValueChanged];
        [super receiveNotifications:atype];
    }
}

-(void)dealloc{
    [self.featureFakeData removeAllObjects];
    self.featureFakeData = nil;
    [self.thematicFakeData removeAllObjects];
    self.thematicFakeData = nil;
    self.tableView = nil;
    self.featureFakeData = nil;
    self.thematicFakeData = nil;
    [super dealloc];
}

-(NSDictionary*)getSearchDict{
    return @{@"type":[NSString stringWithFormat:@"%ld",(long)type],@"class":@"SubjectToPlayView"};
}
@end
