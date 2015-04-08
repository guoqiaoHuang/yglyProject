//
//  BusinessOrderDetailView.m
//  yglyProject
//
//  Created by 枫 on 14-11-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BusinessOrderDetailView.h"
#import "MainViewController.h"
#import "BusinessOrderDetailCell.h"
#import "MJRefresh.h"
#import "ScanQrCodeUIImageView.h"
#import "VerificationCodeCheckView.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"
#define  numCount  5

static NSString *const businessOrderDetailCellIdentifier = @"businessOrderDetailCellIdentifier";
@interface BusinessOrderDetailView ()<UITableViewDataSource,UITableViewDelegate,VIewDadaGetDelegate>

@end
@implementation BusinessOrderDetailView
{
    NSInteger currentPage;
    NSInteger pageNext;
}
-(void)dealloc{
    
    self.checkView = nil;
    self.tableView = nil;
    self.fakeData = nil;
    self.invalidateData = nil;
    self.validateData = nil;
    self.productId = nil;
    self.catId = nil;
    [super dealloc];
}
#pragma mark get OrderState
-(NSInteger)getOrderState{
    return orderState;
}

#pragma mark - VIewDadaGetDelegate
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_dingdan_shanghu_detail]) {
        
            switch (orderState) {
                case 2:
                {
                    [self.fakeData addObjectsFromArray:dict[@"info"]];
                    _orderTmpArray = self.fakeData;
                }
                    break;
                case 0:
                {
                    [self.invalidateData addObjectsFromArray:dict[@"info"]];
                    _orderTmpArray = self.invalidateData;
                }
                    break;
                case 1:
                {
                    [self.validateData addObjectsFromArray:dict[@"info"]];
                    _orderTmpArray = self.validateData;
                }
                    break;
                    
                default:
                    break;
            }
        
        
        currentPage = [dict[@"page"] intValue];
        pageNext = [dict[@"page_next"] intValue];
        __block UISegmentedControl *seg = (UISegmentedControl *)[self viewWithTag:13001];
        seg.userInteractionEnabled = NO;//刷新开始前关闭用户交互
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 刷新表格
            [self.tableView beginUpdates];
            // [self.tableView reloadData];
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = [self.tableView numberOfRowsInSection:0]; i < _orderTmpArray.count; i++) {
                
                [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [[MainViewController sharedViewController] endLoad];
            [self.tableView footerEndRefreshing];
            
            seg.userInteractionEnabled = YES;//刷新结束打开用户交互
        });
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [[MainViewController sharedViewController] endLoad];
    [self.tableView footerEndRefreshing];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"数据加载失败"];
}

#pragma mark -
-(void)showView{
    
    [super showView];
    self.invalidateData = [NSMutableArray array];
    self.validateData = [NSMutableArray array];
    self.fakeData = [[[NSMutableArray alloc] init] autorelease];
    self.invalidateData = [[[NSMutableArray alloc] init] autorelease];
    self.validateData = [[[NSMutableArray alloc] init] autorelease];
    pageNext = 1;
    orderState = 2;
    
    [self showUISegmentedControlList :@"UISegmentedControl" index:0];
    _seg = (UISegmentedControl *)[self viewWithTag:13001];
    //[seg sendActionsForControlEvents:UIControlEventValueChanged];
    
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.size.height+YGLY_VIEW_FLOAT(80), self.size.width, self.size.height - (self.naviView.size.height+YGLY_VIEW_FLOAT(80))) style:UITableViewStyleGrouped]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self insertSubview:self.tableView belowSubview:self.naviView];
    [self.tableView registerClass:[BusinessOrderDetailCell class] forCellReuseIdentifier:businessOrderDetailCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 2.集成刷新控件
    [self setupRefresh];
    [self.tableView footerBeginRefreshing];
    
    
}

- (void)setupRefresh{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}


#pragma mark 开始进入刷新状态
- (void)footerRereshing{
    
    if (pageNext == 0) {
        [[LhNoticeMsg sharedInstance] ShowMsg:@"没有要加载的数据"];
        [self.tableView footerEndRefreshing];
    }else{
        [[VIewDadaGet sharedGameModel] DingDanDetailForShangHu:_productId catId:[_catId integerValue] userType:orderState page:currentPage+1 delegate:self];
        if (_orderTmpArray.count == 0) {
            [[MainViewController sharedViewController] showLoad:self];
        }
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderTmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // @"photo":[listDict[@"app_pic"] isKindOfClass:[NSString class]]?listDict[@"app_pic"]:@""
     BusinessOrderDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:businessOrderDetailCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *listDict = [_orderTmpArray objectAtIndex:indexPath.row];
    NSDictionary *dic = @{@"photo":[listDict strValue:@"app_pic" default:@""],
                           @"defaultImageName":@"leader.png",
                           @"dingdanhao":[listDict strValue:@"order_sn" default:@""],
                           @"number":[listDict strValue:@"quantity" default:@""],
                           @"yz_num":[listDict strValue:@"yz_num" default:@""],
                           @"price":[listDict strValue:@"money" default:@""],
                           @"validateState":[listDict strValue:@"is_sure" default:@""],
                           @"phoneNumber":[listDict strValue:@"youke_telephone" default:@""],
                           @"isNotice":[listDict strValue:@"status" default:@""]};
    
        [cell setDict:dic];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YGLY_VIEW_FLOAT(190);
}

#pragma mark- 数据初始化

-(UIView *)checkView{
    if (!_checkView) {
        
        CGRect checkRect = {{0 ,self.naviView.size.height},{self.size.width ,self.size.height - self.naviView.size.height}};
        self.checkView = [[[UIView alloc] initWithFrame:checkRect] autorelease];
        _checkView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_checkView action:@selector(removeFromSuperview)];
        [_checkView addGestureRecognizer:tap];
        [self showUIViewList:@"MaskUIView" index:0 uiview:_checkView];
        UIView *view = [_checkView viewWithTag:712];
        [self showButtonList:@"MaskButton" index:0 uiview:view];
        [self showUILabelList:@"MaskUILabel" index:0 uiview:view];
    }
    return _checkView;
}
#pragma mark- 商户验证按钮按下
-(void)businessScanningClicked:(UIButton *)sender{
    
    if (_checkView.superview == nil) {
        
        [self addSubview:self.checkView];
        _checkView.alpha = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            _checkView.alpha = 1.0;
        }];
    }
}
#pragma mark-
-(void)checkBtnClick:(UIButton *)sender{
    
    if (sender.tag == 811) {
        //扫二维码
        ScanQrCodeUIImageView*t = [[[ScanQrCodeUIImageView alloc]initWithFrame:self.frame]autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }else if (sender.tag == 812){
        //验证码验证
        VerificationCodeCheckView*t = [[[VerificationCodeCheckView alloc]initWithFrame:self.frame]autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }
}
#pragma mark- 分段按钮值变事件发生后调用
-(void)segClicked:(UISegmentedControl *)seg{
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            orderState = 2;
            _orderTmpArray = self.fakeData;
            break;
        case 1:
            orderState = 0;
            _orderTmpArray = self.invalidateData;
            break;
        case 2:
            orderState = 1;
            _orderTmpArray = self.validateData;
            break;
            
        default:
            break;
    }
    [_orderTmpArray removeAllObjects];
    currentPage = 0;
    pageNext = 1;
    [self.tableView reloadData];
    [self.tableView footerBeginRefreshing];
}

#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}
@end
