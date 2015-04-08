#import "OrderView.h"
#import "BusinessOrderCell.h"
#import "Utility.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "OrderDetailsView.h"
#import "BusinessOrderDetailView.h"
#import "VIewDadaGet.h"
#import "MainViewController.h"
#import "LhNoticeMsg.h"
#import "LoginView.h"
#import "GlobalModel.h"
#define  numCount  5
static NSString *const MJTableViewCellIdentifier = @"OrderViewCell";
static NSString *const businessCellIdentifier = @"BusinessOrderViewCell";

@implementation OrderView
{
    NSInteger userPageNext;//是否还有下一页
    NSInteger userPage;//用户当前页面
    NSInteger businessPage;//商户
    NSInteger businessPageNext;//是否还有下一页
    UISegmentedControl *seg;
}



#pragma mark 事件回调通知
-(void)receiveNotifications:(NSInteger)type{
    if(type == YGLYNoticeTypeLoginSuccess){
        [self footerRereshing];
    }
}


-(void)cellWillBeginDecelerating:(id)nowCell{
    for (NSString*key in self.posDict.allKeys) {
        
        OrderCell *cell = ( OrderCell *)[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[key integerValue] inSection:0]];
        [self.posDict removeObjectForKey:key];
        if (cell && ![cell isEqual:nowCell]) {
            [cell resetAni];
        }
        
    }
}
#pragma mark-数据获取成功
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    [[MainViewController sharedViewController] endLoad];
    [self.tableView footerEndRefreshing];
    
    if ([apiKey isEqualToString:app_dingdan_yonghu_list]) {
        
        //0－全部 1-未过期 2-已过期 3-已完成
        switch (orderState) {
            case 0:// qubu
            {
                orderTmpArray = self.fakeData;
            }
                break;
            case 1:
            {
                orderTmpArray = self.notExpiredData;
            }
                break;
            case 2:
            {
                orderTmpArray = self.expiredData;
            }
                break;
            case 3:
            {
                orderTmpArray = self.completeData;
            }
                break;
            default:
                break;
        }
        userPageNext = [dict[@"page_next"] integerValue];
        userPage = [dict[@"page"] integerValue];
        if (dict[@"info"] && [dict[@"info"] isKindOfClass:[NSArray class]]) {
            [orderTmpArray addObjectsFromArray:dict[@"info"]];
        }else{
            [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];return;
        }
    }else if ([apiKey isEqualToString:app_dingdan_shanghu_list]){
        
        businessPage = [dict[@"page"] integerValue];
        businessPageNext = [dict[@"page_next"] integerValue];
        if (dict[@"info"] && [dict[@"info"] isKindOfClass:[NSArray class]]) {
            
            [self.businessData addObjectsFromArray:dict[@"info"]];
        }else{
            [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];return;
        }
    }
    
    // 2.2秒后刷新表格UI
    __block UISegmentedControl *btn = (UISegmentedControl *)[self viewWithTag:14001];
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView beginUpdates];
        // [self.tableView reloadData];
        
        NSMutableArray *array = [NSMutableArray array];
        if (isbusiness) {
            for (NSInteger i = [self.tableView numberOfRowsInSection:0]; i < _businessData.count; i++) {
                
                [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }else{
            for (NSInteger i = [self.tableView numberOfRowsInSection:0]; i < orderTmpArray.count; i++) {
                
                [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        
        
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        btn.userInteractionEnabled = YES;
    });
   
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [[MainViewController sharedViewController] endLoad];
    [self.tableView footerEndRefreshing];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"数据加载失败"];
}
#pragma mark- alterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [t.controller push:t atindex:6];
    }
}

-(void)showView{
    [super showView];
    orderState = 0;
    userPageNext = 1;
    businessPageNext = 1;
    self.fakeData = [[[NSMutableArray alloc] init] autorelease];
    self.notExpiredData = [[[NSMutableArray alloc] init] autorelease];
    self.expiredData = [[[NSMutableArray alloc] init] autorelease];
    self.completeData = [[[NSMutableArray alloc] init] autorelease];
    self.businessData = [[[NSMutableArray alloc] init] autorelease];
    
    self.posDict = [NSMutableDictionary dictionaryWithCapacity:100];
    self.backgroundColor = [UIColor whiteColor];
    orderTmpArray = self.fakeData;
    
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.size.height+YGLY_VIEW_FLOAT(80), self.size.width, self.size.height - (self.naviView.size.height+YGLY_VIEW_FLOAT(88+80))) style:UITableViewStyleGrouped]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self insertSubview:self.tableView belowSubview:self.naviView];
    [self.tableView registerClass:[OrderCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    [self.tableView registerClass:[BusinessOrderCell class] forCellReuseIdentifier:businessCellIdentifier];
    
    // 2.集成刷新控件
    [self setupRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self showUISegmentedControlList :@"UISegmentedControl" index:0];
    seg = (UISegmentedControl *)[self viewWithTag:13001];
    seg.hidden = YES;
  //  [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView footerBeginRefreshing];
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

#pragma mark 开始进入刷新状态

- (void)footerRereshing{
    if (![GlobalModel isLogin]) {
        [self.tableView footerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        [alert release];
        return;
    }

    if ([[GlobalModel sharedGameModel].selfUserProfile intValue:@"usertype"] == 1) {//用户
        isbusiness = NO;
    }else if ([[GlobalModel sharedGameModel].selfUserProfile intValue:@"usertype"] == 2) {//商户
        isbusiness = YES;
    }
    if (!isbusiness) {
        seg.hidden = NO;
        if (userPageNext == 0) {
            
            [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
            [self.tableView footerEndRefreshing];
            return;
        }
        [[VIewDadaGet sharedGameModel] DingDanListForYongHu:orderState+1 page:userPage+1 delegate:self];
        if (orderTmpArray.count == 0) {
             [[MainViewController sharedViewController] showLoad:self];
        }
    }else{
        CGRect rect = {{0,self.naviView.size.height},{self.size.width,self.size.height-self.naviView.size.height-YGLY_VIEW_FLOAT(88)}};
        self.tableView.frame = rect;
        if(businessPageNext == 0) {
            
            [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
            [self.tableView footerEndRefreshing];
            return;
        }
        [[VIewDadaGet sharedGameModel] DingDanListForShangHu:1 page:businessPage+1 delegate:self];
        if (self.businessData.count == 0) {
            [[MainViewController sharedViewController] showLoad:self];
        }
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isbusiness) {
        
        return self.businessData.count;
    }else{
        
        return orderTmpArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (isbusiness) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:businessCellIdentifier forIndexPath:indexPath];
        NSDictionary *listDict = [self.businessData objectAtIndex:indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:listDict[@"listimg"] forKey:@"photo"];
        [dic setObject:@"带你玩默认图片.png" forKey:@"defaultImageName"];
        [dic setObject:listDict[@"mobile_title"] forKey:@"title"];
        [dic setObject:listDict[@"bm_count"] forKey:@"number"];
        [dic setObject:listDict[@"act_time"] forKey:@"time"];
        [dic setObject:listDict[@"id"] forKey:@"id"];
        
        [((BusinessOrderCell *)cell) setDict:dic];
        ((BusinessOrderCell *)cell).row = indexPath.row;
        ((BusinessOrderCell *)cell).delegate = self;
        [((BusinessOrderCell *)cell) resetOff];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
            
        static NSString*btnTitle[3]={@"未过期",@"已过期",@"已完成"};
        NSDictionary *listDict = [orderTmpArray objectAtIndex:indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:listDict[@"listimg"] forKey:@"photo"];
        [dic setObject:@"带你玩默认图片.png" forKey:@"defaultImageName"];
        [dic setObject:listDict[@"order_sn"] forKey:@"dingdanHao"];
        [dic setObject:listDict[@"mobile_title"] forKey:@"titleName"];
        [dic setObject:listDict[@"quantity"] forKey:@"number"];
        [dic setObject:listDict[@"price"] forKey:@"price"];
        NSInteger btnState = [listDict[@"sfgq"] integerValue];
        [dic setObject:btnTitle[btnState] forKey:@"btnTitle"];
        [dic setObject:listDict[@"id"] forKey:@"id"];
        
        [((OrderCell *)cell) setDict:dic];
        ((OrderCell *)cell).row = indexPath.row;
        ((OrderCell *)cell).delegate = self;
        [((OrderCell *)cell) resetOff];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (isbusiness) {
        
        return YGLY_VIEW_FLOAT(250);
    }
    return YGLY_VIEW_FLOAT(270);
}

#pragma mark - 商家订单中心展示
-(void)businessBtnClicked:(UIButton *)sender{
    
    isbusiness = !isbusiness;
    [self viewWithTag:13001].hidden = isbusiness;
    [orderTmpArray removeAllObjects];
    userPage = 0;
    userPageNext = 1;
    [self.businessData removeAllObjects];
    businessPage = 0;
    businessPageNext = 1;
    [UIView animateWithDuration:0.15 animations:^{
        
        if (isbusiness) {
            CGRect rect = {{0,self.naviView.size.height},{self.size.width,self.size.height-self.naviView.size.height-YGLY_VIEW_FLOAT(88)}};
            self.tableView.frame = rect;
            [sender setTitle:@"用户" forState:UIControlStateNormal];
        }else{
            CGRect rect = {{0,self.naviView.size.height + YGLY_VIEW_FLOAT(80)},{self.size.width,self.tableView.size.height - YGLY_VIEW_FLOAT(80)}};
            self.tableView.frame = rect;
            [sender setTitle:@"商家" forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark 点击cell图片
-(void)clickCellButton:(NSInteger)row{
    
    if (isbusiness) {
        
        BusinessOrderDetailView *t = [BusinessOrderDetailView alloc];
        NSDictionary *listDict = [self.businessData objectAtIndex:row];
        t.catId = listDict[@"catid"];
        t.productId = listDict[@"id"];
                                       
        [[t initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }else{
        
        OrderDetailsView *t = [OrderDetailsView alloc];
        NSDictionary *listDict = [orderTmpArray objectAtIndex:row];
        t.orderId = listDict[@"id"];
        t.productId = listDict[@"productid"];
        t.catId = @"76";
        [[t initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }
    
    EBLog(@"clickCellButton:%ld",(long)row);
}
-(CATransition*)getReplace{
    return nil;
}
-(void)btnClicked:(UISegmentedControl *)Seg{
    
    if (![GlobalModel isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        return;
    }

    orderState = Seg.selectedSegmentIndex;
    [orderTmpArray removeAllObjects];
    userPageNext = 1;
    userPage = 0;
    [self.tableView reloadData];
    [self.tableView footerBeginRefreshing];
}

-(void)dealloc{
    [self.posDict removeAllObjects];
    self.posDict = nil;
    self.tableView = nil;
    [self.fakeData removeAllObjects];
    self.fakeData = nil;
    [self.businessData removeAllObjects];
    self.businessData = nil;
    [self.notExpiredData removeAllObjects];
    self.notExpiredData = nil;
    [self.expiredData removeAllObjects];
    self.expiredData = nil;
    [self.completeData removeAllObjects];
    self.completeData = nil;
    [super dealloc];
}
@end
