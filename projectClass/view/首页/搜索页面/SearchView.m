//
//  SearchView.m
//  yglyProject
//
//  Created by 枫 on 14-10-30.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "SearchView.h"
#import "CityModel.h"
#import "LhLocationModel.h"
#import "ProvincesAndCitysControl.h"
#import "HBJTableView.h"
#import "CityChooseView.h"
#import "MainViewController.h"
#import "MJRefresh.h"
#import "LhNoticeMsg.h"
#import "ThematicPlayInnerView.h"



@implementation SearchViewCell

-(void)setDict:(NSDictionary*)dict{
    
    if (!photo) {
        photo = (DownloadUIImageView*)[DownloadUIImageView Create:nil defauleImage:@"leader.png"];
        photo.point = CGPointMake(10,5);
        [self addSubview:photo];
        titleName =[[[UILabel alloc]init]autorelease];
        titleName.point = CGPointMake(photo.size.width+15, 5);
        titleName.textColor = [UIColor blackColor];
        titleName.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        titleName.textAlignment = NSTextAlignmentLeft;
        titleName.lineBreakMode = NSLineBreakByCharWrapping;
        titleName.numberOfLines = 0;
        [self addSubview:titleName];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [photo setNewUrl:[dict objectForKey:@"listimg"] defauleImage:@"leader.png"];
        titleName.text = [dict strValue:@"mobile_title"];
        titleName.size = CGSizeMake(self.width-photo.size.width-photo.point.x-10, self.size.height-10);
        [titleName sizeToFit];
    });
    
}
-(void)dealloc{
    EBLog(@"dealloc %@",[self class]);
    [super dealloc];
}
@end

@interface SearchView ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
}
@property(nonatomic, retain)UITableView *resultTableView;//存放搜索结果
@property(nonatomic, retain)NSMutableArray *resultArray;//存放搜索结果

@end

@implementation SearchView
static NSString *const MJTableViewCellIdentifier = @"SearchViewCell";
- (void)dealloc{
    self.oldSearchMsg = nil;
    self.resultTableView = nil;
    self.resultArray = nil;
    self.searchDict = nil;
    [super dealloc];
}
- (void)showView{
    
    [super showView];
    
    [self showUISearchBarList:@"BaseUISearchBar" index:0];
    lhSearchBar = (UISearchBar *)[self viewWithTag:611];
    lhSearchBar.delegate = self;
    //searchBar的裁剪，请保证searchBar的默认宽度 44
    [Utility AddRoundedCorners:lhSearchBar rect:[self getSearchFieldFrame] size:15 type:UIRectCornerAllCorners];
    self.resultArray = [NSMutableArray array];
    [self initResultTableView];
    [lhSearchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
}
#pragma mark -获取searchBar textField的frame
- (CGRect)getSearchFieldFrame{
    CGFloat width = CGRectGetWidth(lhSearchBar.frame);
    CGFloat heigh = CGRectGetHeight(lhSearchBar.frame);
    CGRect rect = lhSearchBar.frame;
    rect.origin.x = 8;
    rect.origin.y = 7;
    rect.size.width = width - 16;
    rect.size.height = heigh - 14;
    
    return rect;
}
#pragma mark 初始化一个用来显示搜索结果的tableView
- (void)initResultTableView{
    self.resultTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 17, self.size.width, self.size.height-15) style:UITableViewStyleGrouped]autorelease];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    [self.resultTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.resultTableView registerClass:[SearchViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    [self insertSubview:_resultTableView belowSubview:self.naviView];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.resultArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary*dict = [self.resultArray objectAtIndex:indexPath.row];
    [cell setDict:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSDictionary*dict = [self.resultArray objectAtIndex:indexPath.row];
 
    [(MainViewController*)self.controller showViewByIdAndType:[dict intValue:@"id"] typeValue:[dict intValue:@"catid"]];
}



#pragma mark searchDelegate


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (searchBar.text.length <= 0) {
        return YES;;
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self beginSearch];
        [searchBar resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


#pragma mark push popo
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}




#pragma mark 开始进入刷新状态
- (void)footerRereshing{
    if (!flagStop) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        [self.resultTableView footerEndRefreshing];
        return;
    }
    [self searchApi];
    [[MainViewController sharedViewController] showLoad:self];
}


-(void)searchApi{
    if ([[self.searchDict objectForKey:@"class"] isEqualToString:@"SubjectToPlayView"]) {
        NSInteger type = [self.searchDict intValue:@"type"];
        if (type == 1) {
            [[VIewDadaGet sharedGameModel]ZhuTiSearchTswf:lhSearchBar.text  page:++page delegate:self];
        }else{
            [[VIewDadaGet sharedGameModel]ZhuTiSearchZthd:lhSearchBar.text  page:++page delegate:self];
        }
    }else{
        [[VIewDadaGet sharedGameModel]ZhuTiSearchXl:lhSearchBar.text  page:++page delegate:self];
    }
}
#pragma mark 开始搜索
-(void)beginSearch{
    if (self.oldSearchMsg && [self.oldSearchMsg isEqualToString:lhSearchBar.text]) {
        return;
    }
    self.oldSearchMsg = lhSearchBar.text;
    page = 0;
    flagStop = NO;
    [self searchApi];
    [[MainViewController sharedViewController] showLoad:self];
    [self.resultArray removeAllObjects];
    [self.resultTableView reloadData];
}

#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    flagStop = [dict intValue:@"page_next"];
    page = [dict intValue:@"page"];
    [self.resultTableView beginUpdates];
    NSInteger num = self.resultArray.count;
    NSInteger i = 0;
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arrays = [dict objectForKey:@"info"];
    for (NSDictionary*dic in arrays) {
        [self.resultArray addObject:dic];
        [array addObject:[NSIndexPath indexPathForRow:num+++i inSection:0]];
    }
    [self.resultTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.resultTableView endUpdates];
    [self.resultTableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
    if(array.count < 1 ){
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    [self.resultTableView footerEndRefreshing];
    [[MainViewController sharedViewController] endLoad];
    [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
}

@end
