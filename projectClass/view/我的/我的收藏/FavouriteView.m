
#import "FavouriteView.h"
#import "Utility.h"
#import "FavourateCell.h"
#import "VIewDadaGet.h"
#import "MJRefresh.h"
#import "LhNoticeMsg.h"
#import "MainViewController.h"
#import "ThematicPlayInnerView.h"

@interface FavouriteView ()<UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic,assign)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *fakeArray;
@property(nonatomic,retain)NSString *cellIdentifier;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger nextPage;

@end

@implementation FavouriteView

- (void)dealloc{
    
    self.fakeArray = nil;
    self.cellIdentifier = nil;
    [super dealloc];
}

- (void)showView{
    
    [super showView];
    self.fakeArray = [NSMutableArray array];
    self.cellIdentifier = @"favouriteCell";
    //UITableViewStylePlain cell上会有分割线的划过
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, self.naviView.height, self.width, self.height-self.naviView.height) style:UITableViewStyleGrouped] autorelease];
    [_tableView registerClass:[FavourateCell class] forCellReuseIdentifier:self.cellIdentifier];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self insertSubview:_tableView atIndex:0];
    _nextPage = 1;
    _currentPage = 0;
    [self setupRefresh];
    [self.tableView footerBeginRefreshing];
}

- (void)setupRefresh{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 下拉刷新状态
- (void)footerRereshing{
    if (!_nextPage) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        [self.tableView footerEndRefreshing];
        return;
    }else{
     
        [[VIewDadaGet sharedGameModel] ShouCangForYongHu:_currentPage+1 delegate:self];
        if (self.fakeArray.count == 0) {
            [[MainViewController sharedViewController] showLoad:self];
        }
    }
}

#pragma mark- tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _fakeArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavourateCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = self.fakeArray[indexPath.row];
    [cell setWithDict:@{@"defaultImage":@"favouriteImage.png",
                        @"imgUrl":[dict strValue:@"listimg" default:@""],
                        @"title":[dict strValue:@"mobile_title" default:@""],
                        @"zhuban":[NSString stringWithFormat:@"主办方：%@",[dict strValue:@"js_zhuban" default:@""]],
                        @"address":[NSString stringWithFormat:@"地值点：%@",[dict strValue:@"js_address" default:@""]],
                        @"time":[dict strValue:@"add_time" default:@""]}];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.fakeArray[indexPath.row];
    ThematicPlayInnerView*view = [ThematicPlayInnerView alloc];
    view.tag = [dict intValue:@"id"];
    view.selfCatid= 23;
    [[view initWithFrame:self.bounds] autorelease];
    view.controller = self.controller;
    [self.controller push:view atindex:6];
}


#pragma mark 获取push特效
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}



#pragma mark
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary *)dict{
    
    if ([apiKey isEqualToString:app_yonghu_shoucang]) {
        
        self.currentPage = [dict intValue:@"page"];
        self.nextPage = [dict intValue:@"page_next"];
        if ([dict objectForKey:@"info"] && [[dict objectForKey:@"info"] isKindOfClass:[NSArray class]]) {
            [self.fakeArray addObjectsFromArray:[dict objectForKey:@"info"]];
            
            [self.tableView beginUpdates];
            NSMutableArray *indexTmpArray = [NSMutableArray array];
            for (NSInteger i = [self.tableView numberOfRowsInSection:0]; i < self.fakeArray.count; i++) {
                
                [indexTmpArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexTmpArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
    [self.tableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
}

-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    
    [self.tableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"数据刷新失败"];
}


@end
