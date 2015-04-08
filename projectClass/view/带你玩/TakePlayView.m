#import "TakePlayView.h"
#import "Utility.h"
#import "TakePlayCell.h"
#import "MJRefresh.h"
#import "TakePlayInsidePages.h"
#import "VIewDadaGet.h"
#import "MainViewController.h"

#define  numCount  5
static NSString *const MJTableViewCellIdentifier = @"TakePlayCell";
@interface TakePlayView ()<TakePlayCellDelegate>
{
    NSInteger page;//当前页面
}
@end

@implementation TakePlayView

-(void)showView{
    [super showView];
    dayFlag = 0;
    timeFlag = YES;;
    priceFlag = YES;
    flagStop = YES;
    btnState = 1;
    page = 0;
    self.fakeData = [NSMutableArray array];
    [self showColorButtonList:@"ColorButton" index:0];
    UIView*   t = (UIButton*)[self viewWithTag:14002];
    [Utility AddRoundedCorners:t size:5 type:UIRectCornerBottomRight | UIRectCornerTopRight];
    [self ShowImageViewList:@"UIImageView" index:0 uiview:[self viewWithTag:14001]];
    [self ShowImageViewList:@"UIImageView" index:0 uiview:[self viewWithTag:14002]];
    self.posDict = [NSMutableDictionary dictionaryWithCapacity:100];
    self.backgroundColor = [UIColor whiteColor];
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 90, self.size.width, self.size.height - 134) style:UITableViewStyleGrouped]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView registerClass:[TakePlayCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    
    // 2.集成刷新控件
    [self setupRefresh];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self showIGLDropDownMenuList:@"IGLDropDownMenu" index:0];
      IGLDropDownMenu* menu = (IGLDropDownMenu*)[self viewWithTag:13001];
     [Utility AddRoundedCorners:menu.menuButton.textLabel size:5 type:UIRectCornerBottomLeft | UIRectCornerTopLeft];
    UIButton *btn = (UIButton *)[self viewWithTag:14001];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
//    [[MainViewController sharedViewController] showLoad:self];
//    [[VIewDadaGet sharedGameModel] TakePlayData:dayFlag time_order:timeFlag?@"ASC":@"DESC" price_order:priceFlag?@"ASC":@"DESC" page:page+1 delegate:self];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

#pragma mark 下拉刷新状态
- (void)footerRereshing{
    if (!flagStop) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        [self.tableView footerEndRefreshing];
        return;
    }
    [[VIewDadaGet sharedGameModel] TakePlayData:dayFlag time_order:timeFlag?@"ASC":@"DESC" price_order:priceFlag?@"ASC":@"DESC" order_first:btnState page:page+1 delegate:self];
    if (self.fakeData.count == 0) {
        [[MainViewController sharedViewController] showLoad:self];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fakeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakePlayCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [self.fakeData objectAtIndex:indexPath.row];
    [cell setDict:dic];
    cell.delegate = self;
    cell.row = indexPath.row;
    [cell resetOff];
    return cell;
}

- (void)takePlayCellDidSelected:(NSInteger)indexPath{
    NSDictionary *dic = [self.fakeData objectAtIndex:indexPath];
    TakePlayInsidePages*t = (TakePlayInsidePages*)[Utility getViewToId:@"TakePlayInsidePages" tag:[dic intValue:@"id"] rect:self.bounds];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YGLY_VIEW_FLOAT(250 + 20);
}



-(CATransition*)getReplace{
    return nil;
}

#pragma mark 菜单回调
- (void)selectedItemAtIndex:(NSInteger)index{
   
    if (dayFlag == index) {
        return;
    }
    page = 0;
    flagStop = YES;
    dayFlag = index;
    [self.posDict removeAllObjects];
    [self.fakeData removeAllObjects];
    [self.tableView reloadData];
    [[MainViewController sharedViewController] showLoad:self];
    [[VIewDadaGet sharedGameModel] TakePlayData:dayFlag time_order:timeFlag?@"ASC":@"DESC" price_order:priceFlag?@"ASC":@"DESC" order_first:btnState page:page+1 delegate:self];
}
-(void)btnClicked:(UIButton*)sender{
    
    page = 0;
    [self.posDict removeAllObjects];
    [self.fakeData removeAllObjects];
    [self.tableView reloadData];
    if (sender.tag <= 13003) {
        [sender fadeOut];
        NSInteger tag = sender.tag+1 ;
        if (tag >= 13004) {
            tag = 13001;
        }
        dayFlag = tag - 13000;
        UIView*t = [self viewWithTag:tag];
        [t fadeIn];
    }else {
        UIView*t1 = [sender viewWithTag:50001];
        UIView*t2 = [sender viewWithTag:50002];
        t2.hidden = !t2.hidden;
        t1.hidden = !t1.hidden;
        if (sender.tag == 14001 ) {
            btnState = 1;
            timeFlag = !timeFlag;
        }else{
            btnState = 2;
            priceFlag = !priceFlag;
        }
        [sender fadeIn];
    }
    flagStop = YES;
    [[MainViewController sharedViewController] showLoad:self];
   [[VIewDadaGet sharedGameModel] TakePlayData:dayFlag time_order:timeFlag?@"ASC":@"DESC" price_order:priceFlag?@"ASC":@"DESC" order_first:btnState page:page+1 delegate:self];
   //--设置不范围的一个索引
}

-(void)dealloc{
    [self.posDict removeAllObjects];
    self.posDict = nil;
    self.tableView = nil;
    [self.fakeData removeLastObject];
    self.fakeData = nil;
    [super dealloc];
}

#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    flagStop = [dict intValue:@"page_next"];
    page = [dict intValue:@"page"];
    [self.tableView beginUpdates];
    NSInteger num = self.fakeData.count;
    int i = 0;
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrays = [dict objectForKey:@"value"];
    for (NSDictionary*dic in arrays) {
        [self.fakeData addObject:dic];
        [array addObject:[NSIndexPath indexPathForRow:num+i++ inSection:0]];
    }

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

#pragma mark cell滑动
-(void)cellWillBeginDecelerating:(id)nowCell{
    for (NSString*key in self.posDict.allKeys) {
        TakePlayCell *cell = ( TakePlayCell *)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[key integerValue] inSection:0]];
        [self.posDict removeObjectForKey:key];
        if (cell && ![cell isEqual:nowCell]) {
            [cell resetAni];
        }
        
    }
}

#pragma mark- reciveNotice
-(void)receiveNotifications:(NSInteger)type{
    
    if (type == YGLYNoticeTypeLocationDidChange) {
        
        flagStop = YES;
        page = 0;
        [self.posDict removeAllObjects];
        [self.fakeData removeAllObjects];
        [self.tableView reloadData];
        [[MainViewController sharedViewController] showLoad:self];
        [[VIewDadaGet sharedGameModel] TakePlayData:dayFlag time_order:timeFlag?@"ASC":@"DESC" price_order:priceFlag?@"ASC":@"DESC" order_first:btnState page:page+1 delegate:self];
        [super receiveNotifications:type];
    }
}

@end
