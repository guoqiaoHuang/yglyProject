//
//  ThematicPlayInnerView.m
//  yglyProject
//
//  Created by 枫 on 14-11-3.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
#import "LoginView.h"
#import "ThematicPlayInnerView.h"
#import "ChartCommunicationView.h"
#import "MJRefresh.h"
#import "HBJTableView.h"
#import "MainViewController.h"
#import "LeaderAndFriendFlowLayout.h"
#import "LeaderAndFriendCell.h"
#import "LhSelfKeyboard.h"
#import "TableHeaderView.h"
#import "SenceImageView.h"
#import "GlobalModel.h"
#import "LineFeaturesView.h"

#define  numCount  6

static NSString *const MJTableViewCellIdentifier = @"chartViewCell";

@interface ThematicPlayInnerView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,ChartCommunicationViewDelegate>
{
    CGFloat diff;//存放当回复的时候，视图的偏移量
    CGFloat diffAll;//存放总的偏移量
    TableHeaderView *_headerView;
    CGFloat lastHeight;//存放上一次表示图的高度
    CGSize normalContentSize;//存放最初的scrollView的contentsize
    CGFloat djsOffsetY;//存放大家说所在位置的偏移量
    CGFloat djsFixedOffsetY;//存放大家说所在位置的偏移量(这个值是永远不会变的)
    BOOL isCommentaryBtnClick;//是否是评论按钮被点击
}

@property(nonatomic, retain)NSString *jianJieUrl;//路线特色点进去后的网页链接
@property(nonatomic,retain)ChartCommunicationView *propertyCell;
@property(nonatomic,retain)NSMutableArray *cellLengthArray;//用来保存cell的长度，于indexPath.row相对应

@end

@implementation ThematicPlayInnerView


-(void)setIsLove:(BOOL)tisLove{
    _isLove = tisLove;
     UIButton*t = (UIButton*)[self viewWithTag:900001];
    if (_isLove) {
        t.userInteractionEnabled = NO;
        UIImage *image = [Utility getImageByName:@"收藏按下.png"];
        [t setImage:image forState:UIControlStateNormal];
    }
    t.hidden = NO;
    
}
#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{

    if ([apiKey isEqualToString:app_zhuti_djs_add]) {
        if (nowIndexMsgRow == -1) {
            flagStop = [dict intValue:@"page_next"];
            NSArray*arrays = [dict objectForKey:@"info"];
            self.cellLengthArray = [NSMutableArray arrayWithCapacity:1000];
            self.chatMsgArray = [NSMutableArray arrayWithCapacity:100];
            for (NSDictionary*djsDic in arrays) {
                NSMutableDictionary*hdic = [NSMutableDictionary dictionaryWithCapacity:10];
                NSDictionary*tw = [djsDic objectForKey:@"tw"];
                NSDictionary*hf = [djsDic objectForKey:@"hf"];
                [hdic setObject:[tw objectForKey:@"app_pic"] forKey:@"headImageUrl"];
                [hdic setObject:[tw objectForKey:@"content"]  forKey:@"topLabelText"];
                [hdic setObject:[tw objectForKey:@"id"]  forKey:@"id"];
                [hdic setObject:hf forKey:@"bellowBodayDict"];
                NSString*date = [Utility getDateBytims:(long)[tw floatValue:@"add_time"] key:@"yy-MM-dd HH:mm" style:NSDateFormatterNoStyle];
                [hdic setObject:date forKey:@"date"];
                [hdic setObject:self forKey:@"target"];
                [self.chatMsgArray addObject:hdic];
            }
            [self.tableView reloadData];
        
        }else{
            
            NSDictionary*djsDic = dict;
            NSMutableDictionary*hdic = [NSMutableDictionary dictionaryWithCapacity:10];
            NSDictionary*tw = [djsDic objectForKey:@"tw"];
            NSDictionary*hf = [djsDic objectForKey:@"hf"];
            [hdic setObject:[tw objectForKey:@"app_pic"] forKey:@"headImageUrl"];
            [hdic setObject:[tw objectForKey:@"content"]  forKey:@"topLabelText"];
            [hdic setObject:[tw objectForKey:@"id"]  forKey:@"id"];
            [hdic setObject:hf forKey:@"bellowBodayDict"];
            NSString*date = [Utility getDateBytims:(long)[tw floatValue:@"add_time"] key:@"yy-MM-dd HH:mm" style:NSDateFormatterNoStyle];
            [hdic setObject:date forKey:@"date"];
            [hdic setObject:self forKey:@"target"];
            [self.chatMsgArray replaceObjectAtIndex:nowIndexMsgRow withObject:hdic];
            [self.cellLengthArray replaceObjectAtIndex:nowIndexMsgRow withObject:@"0"];
            [self.tableView reloadData];
        }
        [self playSound:@"sendMsg.wav"];
        return;
        
    }else if([apiKey isEqualToString:app_zhuti_yxtype_add]){
        self.isLove = YES;
        [self dismissLoadMsg];
        [[LhNoticeMsg sharedInstance]ShowMsg:@"收藏成功"];
        xhNum = [dict intValue:@"xp_num"];
        self.taLove = [dict objectForKey:@"xh_arr"];
        [_collectionView reloadData];
        return;
    }else if([apiKey isEqualToString:app_zhuti_djs_list]){
        flagStop = [dict intValue:@"page_next"];
        
        [self.tableView beginUpdates];
        NSInteger num = self.chatMsgArray.count;
        NSInteger i = 0;
        NSMutableArray *array = [NSMutableArray array];
        NSArray *arrays = [dict objectForKey:@"info"];
        for (NSDictionary*djsDic in arrays) {
            NSMutableDictionary*hdic = [NSMutableDictionary dictionaryWithCapacity:10];
            NSDictionary*tw = [djsDic dictValue:@"tw"];
            NSDictionary*hf = [djsDic dictValue:@"hf"];
            [hdic setObject:[tw strValue:@"app_pic" default:@""] forKey:@"headImageUrl"];
            [hdic setObject:[tw strValue:@"content" default:@""]  forKey:@"topLabelText"];
            [hdic setObject:[tw strValue:@"id" default:@""]  forKey:@"id"];
            
            [hdic setObject:hf forKey:@"bellowBodayDict"];
            NSString*date = [Utility getDateBytims:(long)[tw floatValue:@"add_time"] key:@"yy-MM-dd HH:mm" style:NSDateFormatterNoStyle];
            [hdic setObject:date forKey:@"date"];
            [hdic setObject:self forKey:@"target"];
            [self.chatMsgArray addObject:hdic];
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
    if ([apiKey isEqualToString:app_zhuti_info]) {
        [self loadView:[dict objectForKey:@"info"]];
    }else{
        [self.tableView footerEndRefreshing];
    }
    [[MainViewController sharedViewController] endLoad];

}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    if ([apiKey isEqualToString:app_zhuti_djs_add]) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"数据发送失败"];
    }else{
        [self.tableView footerEndRefreshing];
        [[MainViewController sharedViewController] endLoad];
        [[LhNoticeMsg sharedInstance]ShowMsg:@"数据加载失败"];
        [self dismissLoadMsg];
    }
    
}

#pragma mark - dealloc
-(void)dealloc{
    self.chatMsgArray = nil;
    self.propertyCell = nil;
    self.tableView = nil;
    self.cellLengthArray = nil;
    self.jianJieUrl = nil;
    if (_headerView) {
        [_headerView release];_headerView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark - 用来给页面加载已经获取到的数据
-(void)loadView:(NSDictionary*)allDict{
    xhNum = [allDict intValue:@"xh_num"];
    flagStop = [allDict intValue:@"page_next"];
    [self initScrollViewWithBottomHeight:0];
    self.scrollView.delegate = nil;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    NSMutableDictionary*dataDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [dataDict setObject:[allDict objectForKey:@"mobile_img"] forKey:@"senceUrl"];
    [dataDict setObject:@"640x250默认图片.png" forKey:@"defaultSence"];
    [dataDict setObject:@"#ffffff" forKey:@"timeTextColor"];
    [dataDict setObject:@"#99ccff" forKey:@"timeBGColor"];
    [dataDict setObject:@"景色图黑底衬.png" forKey:@"belloImageName"];
    [dataDict setObject:[allDict objectForKey:@"mobile_title"] forKey:@"bellowTitle"];
    [dataDict setObject:@"2" forKey:@"bellowLabelStyle"];
    [self addSenceImageViewWithDic:dataDict bSpace:0 eSpace:0];
    _headerView = [[TableHeaderView alloc] init];
    [_headerView stretchHeaderForTableView:self.scrollView withView:self.scrollView.subviews.lastObject];
    [self showUIViewList:@"UIView" index:0 uiview:self.scrollView];
    //设置scrollView的contentSize
    UIView *view = [self viewWithTag:611];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(view.frame));
    
    [self showUILabelList:@"UILabel" index:0 uiview:self.scrollView];
    [self showButtonList:@"Buttons" index:0 uiview:self.scrollView];
    
    NSArray *array = [[allDict objectForKey:@"s_time"] componentsSeparatedByString:@"-"];
    NSString*s_time = [NSString stringWithFormat:@"活动时间: %@月%@日-%@月%@日",array[1],[array[2] substringWithRange:NSMakeRange(0,2)],array[3],array[4]];
    UILabel*lable = (UILabel*)[self viewWithTag:1233411];
    lable.text = s_time;
    lable = (UILabel*)[self viewWithTag:1233412];
    lable.text = [NSString stringWithFormat:@"活动地点: %@",[allDict objectForKey:@"js_address"]];
    UIButton *button = (UIButton *)[self viewWithTag:711];
    [button setTitle:[NSString stringWithFormat:@"%@|%@",allDict[@"js_address"],allDict[@"zuobiao"]] forState:UIControlStateNormal];
    button.titleLabel.hidden = YES;
    //zuobiao
    lable = (UILabel*)[self viewWithTag:1233413];
    NSArray*dddd = [allDict objectForKey:@"js_zhuban"];

    NSString*t =@"活动主办: ";
    NSRange rangeArray[9] = {NSMakeRange(0, 0)};//最多十个主办方
    int ti = 0;
    for (NSString*msg in dddd) {
        if (ti) {
            t = [t stringByAppendingString:@"\r\n"];
            NSRange range = NSMakeRange(t.length, 6);//6是 @“活动主办: ” 这个字符串的长度
            rangeArray[ti] = range;
            t = [t stringByAppendingString:[NSString stringWithFormat:@"活动主办: %@",msg]];
        }else{
            t = [t stringByAppendingString:msg];
        }
        ti++;
    }
    NSMutableAttributedString *mutAtrString = [[[NSMutableAttributedString alloc] initWithString:t] autorelease];
    for (int i = 0; i < 9; i++) {
        [mutAtrString setAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:rangeArray[i]];
    }
    lable.attributedText = mutAtrString;
    
    
   NSDictionary *headDic = [NSDictionary dictionaryWithObjects:@[@"#e19bb6",
                                                    @"活动详情",
                                                    @""]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:30 eSpace:0];
    
    [dataDict removeAllObjects];
    [dataDict setObject: [allDict strValue:@"luodong_xq" default:@""] forKey:@"text"];
    self.jianJieUrl = [allDict strValue:@"jianjie_url" default:@""];
    [self addTextAndPhotoViewWithDic:dataDict bSpace:20 eSpace:0 addGesture:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLineFeaturesView)] autorelease]];

    self.lineDatas = [allDict objectForKey:@"tuijian"];
    if (self.lineDatas.count) {
        headDic = [NSDictionary dictionaryWithObjects:@[@"#d85525",
                                                        @"相关线路",
                                                        @""]
                   
                                              forKeys:@[  @"bgColor",
                                                          @"labelText",
                                                          @"imageName"]];
        [self addSenceHeadViewWithDic:headDic bSpace:10 eSpace:20];
        [dataDict removeAllObjects];
        [dataDict setObject:@"tuiJianLine:" forKey:@"method"];
    }
    
    
    
    for (NSDictionary*lineDic in self.lineDatas) {
        [dataDict setObject:[lineDic objectForKey:@"productid"] forKey:@"tag"];
        [dataDict setObject:[lineDic objectForKey:@"mobile_title"] forKey:@"routeLine"];
        [dataDict setObject:[lineDic objectForKey:@"price"] forKey:@"routePrice"];
        [self addRouteRecommendationViewWithDic:dataDict bSpace:0 eSpace:0];
    }
    
    
    headDic = [NSDictionary dictionaryWithObjects:@[@"#a5c8ec",
                                                    @"TA也喜欢",
                                                    @""]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:30 eSpace:20];
    self.taLove =  [allDict objectForKey:@"xh_arr"];
    _collectionView = [self addCollectionViewWithReuseIdentifier:@"LeaderCell" collectionViewFlowLayout:[[[LeaderAndFriendFlowLayout alloc] init] autorelease]collectionViewCellClass:[LeaderAndFriendCell class] bSpace:0 eSpace:20];
    _collectionView.userInteractionEnabled = NO;
    [self setCollectionViewCenter:_collectionView];
    
    djsOffsetY = self.scrollView.contentSize.height;
    djsFixedOffsetY = djsOffsetY;
    headDic = [NSDictionary dictionaryWithObjects:@[@"#30629a",
                                                    @"大家说",
                                                    @""]
               
                                          forKeys:@[  @"bgColor",
                                                      @"labelText",
                                                      @"imageName"]];
    [self addSenceHeadViewWithDic:headDic bSpace:10 eSpace:20];
  
    
    
    
    self.cellLengthArray = [NSMutableArray arrayWithCapacity:1000];
    self.chatMsgArray = [NSMutableArray arrayWithCapacity:100];
    
    NSArray *djs = [allDict objectForKey:@"djs"];
    for (NSDictionary*djsDic in djs) {
        NSMutableDictionary*hdic = [NSMutableDictionary dictionaryWithCapacity:10];
        NSDictionary*tw = [djsDic objectForKey:@"tw"];
        NSDictionary*hf = [djsDic objectForKey:@"hf"];
        [hdic setObject:[tw objectForKey:@"app_pic"] forKey:@"headImageUrl"];
        [hdic setObject:[tw objectForKey:@"id"]  forKey:@"id"];
        [hdic setObject:[tw objectForKey:@"content"]  forKey:@"topLabelText"];
        [hdic setObject:hf forKey:@"bellowBodayDict"];
        NSString*date = [Utility getDateBytims:(long)[tw floatValue:@"add_time"] key:@"yy-MM-dd HH:mm" style:NSDateFormatterNoStyle];
        [hdic setObject:date forKey:@"date"];
        [hdic setObject:self forKey:@"target"];
        [self.chatMsgArray addObject:hdic];
    }

    self.propertyCell = [[[ChartCommunicationView alloc] init] autorelease];
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, self.scrollView.contentSize.height, self.size.width, YGLY_VIEW_FLOAT(700)) style:UITableViewStyleGrouped]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    [self.scrollView addSubview:_tableView];
    [self.tableView registerClass:[ChartCommunicationView class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:_tableView.panGestureRecognizer];
    lastHeight = YGLY_VIEW_FLOAT(700);
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += YGLY_VIEW_FLOAT(700);
    self.scrollView.contentSize = contentSize;
    //最下边的用户评论button
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect btnRect = {{0,self.height-YGLY_VIEW_FLOAT(88)},{CGRectGetWidth(self.frame),YGLY_VIEW_FLOAT(88)}};
    button.frame = btnRect;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"说点儿什么吧..." forState:UIControlStateNormal];
    [button setTitleColor:[Utility hexStringToColor:@"#30629a"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doCommentary) forControlEvents:UIControlEventTouchUpInside];
    [button makeInsetShadowWithRadius:3.0 Color:[[UIColor grayColor] colorWithAlphaComponent:0.8] Directions:@[@"top"]];
    [self addSubview:button];

    contentSize = self.scrollView.contentSize;
    contentSize.height += YGLY_VIEW_FLOAT(88);
    self.scrollView.contentSize = contentSize;
    normalContentSize = contentSize;
     self.tableView.dataSource = self;
    // 2.集成刷新控件
    [self setupRefresh];
    self.isLove = [allDict intValue:@"xh_type"];
    diffAll = 0.0;
    
}


#pragma mark -
-(void)showView{
    
    [super showView];
    [[VIewDadaGet sharedGameModel]ZhuTiInfo:self.tag catid:self.selfCatid delegate:self];
    [[MainViewController sharedViewController] showLoad:self];
    //键盘隐藏监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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


#pragma mark 开始进入聊天列表刷新
- (void)footerRereshing{
    if (!flagStop) {
        [[LhNoticeMsg sharedInstance]ShowMsg:@"没有要加载的数据"];
        [self.tableView footerEndRefreshing];
        return;
    }
    NSDictionary*dic = [self.chatMsgArray lastObject];
    [[VIewDadaGet sharedGameModel]ZhuTiDjsList:self.tag catid:self.selfCatid pageid:[dic intValue:@"id"] delegate:self];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [Utility delay:0.0 action:^{
        [self checkMaxHeight];
    }];
    return self.chatMsgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row >= _cellLengthArray.count) {
        ChartCommunicationView *cell = self.propertyCell;
        cell.cellHeight = 0;
        [cell setWithDict:[self.chatMsgArray objectAtIndex:indexPath.row]];
        _cellLengthArray[indexPath.row] = [NSString stringWithFormat:@"%f",cell.frame.size.height+1];
 
    }else{
        NSInteger hight =[[self.cellLengthArray objectAtIndex:indexPath.row]integerValue];;
        if (hight <= 0) {
            ChartCommunicationView *cell = self.propertyCell;
            cell.cellHeight = 0;
            [cell setWithDict:[self.chatMsgArray objectAtIndex:indexPath.row]];
            _cellLengthArray[indexPath.row] = [NSString stringWithFormat:@"%f",cell.frame.size.height+1];
        }
    }
       [Utility delay:0.0 action:^{
           [self checkMaxHeight];
       }];
    return  [_cellLengthArray[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCommunicationView *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.chatMsgArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.cellHeight = [[self.cellLengthArray objectAtIndex:indexPath.row]floatValue];
    [cell setWithDict:dic];
    return cell;
}
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //键盘消失
    [self keyboardHidden];
}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.taLove) {
        return 0;
    }
    return self.taLove.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LeaderAndFriendCell *cell = nil;
    
    cell = (LeaderAndFriendCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LeaderCell" forIndexPath:indexPath];
    if (self.taLove.count > indexPath.row) {
        NSDictionary *dic = self.taLove[indexPath.row];
        cell.defaultImage = @"leader.png";
        cell.title = [dic objectForKey:@"username"];
        [cell setImageUrl:[dic objectForKey:@"app_pic"]];
        cell.button.tag = [dic intValue:@"uid"];
        cell.button.userInteractionEnabled = NO;//按钮点击回调需要设置 yes
        [cell.button addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.button setImage:[Utility getImageByName:@"我喜欢默认.png"] forState:UIControlStateNormal];
        [cell.button setImage:[Utility getImageByName:@"我喜欢按下.png"] forState:UIControlStateSelected];
        cell.title = [NSString stringWithFormat:@"%zi",xhNum];
        cell.button.imageTitleLabel.text = @"...";
        cell.button.userInteractionEnabled = NO;
    }

    return cell;
}

#pragma mark- scrollviewDelegate-tableview使用
//重新计算scrollview终点的坐标
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.height-2.0;
    
    if (scrollView.contentOffset.y >= maxOffsetY) {
        if (!decelerate) {
            [scrollView setContentOffset:CGPointMake(0, maxOffsetY-2.0) animated:YES];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.height-2.0;
    if (scrollView.contentOffset.y >= maxOffsetY) {
        
        [scrollView setContentOffset:CGPointMake(0, maxOffsetY-2.0) animated:YES];
    }
}

-(void)removeFromSuperview{
    //由于 self 作为了 值放在字典中 故需要在移除视图的时候释放对其的引用
    [LhSelfKeyboard sharedModel].delegate = nil;
    [self.chatMsgArray removeAllObjects];
    [super removeFromSuperview];
}
#pragma mark- 预留项，点击用户昵称，后调用该方法
-(void)photoClicked:(UIButton *)sender{
    
    EBLog(@"---btn tg ---%zi",sender.tag);
    
}
#pragma mark 推荐线路回调
-(void)tuiJianLine:(UIButton*)sender{
    EBLog(@"tuiJianLine:%zi",sender.tag);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [t.controller push:t atindex:6];
    }
}


#pragma mark- 该事件是用来调用键盘事件，如果
-(void)callKeyBoardBtn:(UIButton *)sender atIndexPath:(NSIndexPath *)indexPath{
    
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
    
    isCommentaryBtnClick = NO;
    //让按钮所在的cell滚动到表示图的顶部
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //转化坐标上移 self
    CGPoint point = [sender convertPoint:sender.frame.origin toView:self.scrollView];
    diff = point.y - self.scrollView.contentOffset.y;
    diffAll += diff;
    [UIView animateWithDuration:0.35 animations:^{
        CGPoint offset = self.scrollView.contentOffset;
        offset.y += diff;
        self.scrollView.contentOffset = offset;
    }];
    
    [LhSelfKeyboard sharedModel].delegate = self;
    nowIndexMsgRow = indexPath.row;
    EBLog(@"--callkeyBoard-%@---",indexPath);
}

- (void)keyboardShow{
    
    self.tableView.userInteractionEnabled = NO;
}
- (void)keyboardHidden{
    
    [UIView animateWithDuration:0.35 animations:^{
        CGPoint offset = self.scrollView.contentOffset;
        
        if (isCommentaryBtnClick) {
           //  offset.y = djsOffsetY;
        }else{
            offset.y -= diffAll;
        }
        self.scrollView.contentOffset = offset;
        diffAll = 0.0;
    }completion:^(BOOL flage){
        self.tableView.userInteractionEnabled = YES;
    }];
    
    diff = 0.0;
}

#pragma mark- 评论
-(void)doCommentary{
    isCommentaryBtnClick = YES;
    
    djsOffsetY = self.scrollView.contentOffset.y;
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
    [self.scrollView setContentOffset:CGPointMake(0, djsFixedOffsetY) animated:YES];
    nowIndexMsgRow = -1;
    [LhSelfKeyboard sharedModel].delegate = self;
}
#pragma mark- 发送消息
-(void)keyBoardSendMsg:(NSString*)msg{
    [self keyboardHidden];
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (msg.length < 1) {
        return;
    }
    
    if (nowIndexMsgRow == -1) {
        [[VIewDadaGet sharedGameModel]ZhuTiDjsAdd:self.tag catid:self.selfCatid parentid:0 content:msg delegate:self];
    }else{
        NSDictionary*dict =   [self.chatMsgArray objectAtIndex:nowIndexMsgRow];
        if (dict) {
            [[VIewDadaGet sharedGameModel]ZhuTiDjsAdd:self.tag catid:self.selfCatid parentid:[dict intValue:@"id"] content:msg delegate:self];
        }
    }
    
    
}
#pragma mark- 我喜欢
-(void)favouriteBtnClicked:(UIButton*)sender{
    if ([GlobalModel isLogin]) {
        [[VIewDadaGet sharedGameModel]ZhuTiYxtypeAdd:self.tag catid:self.selfCatid yxtype:3 delegate:self];
        [self showLoadMsg:@"请求中"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];

    }
}

#pragma mark 进入特色详情页
- (void)gotoLineFeaturesView{
    
    
    LineFeaturesView*t = [LineFeaturesView alloc];
    t.urlString = self.jianJieUrl;
    [[t initWithFrame:self.bounds] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}

#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}

#pragma mark- 计算可见cell的最大高度是否出了tableView的最大高度
-(void)checkMaxHeight{
    
    if (_cellLengthArray.count > 0) {
        
        self.tableView.backgroundView = nil;
        //计算可见cell的高度
        float height = 0.0;
        for (NSString *str in _cellLengthArray) {
            
            height += [str floatValue];
            if (height > CGRectGetHeight(_tableView.frame)) {
                
                break;
            }
        }
        
        if (height <  CGRectGetHeight(_tableView.frame)) {
            
            CGSize contentSize = normalContentSize;
            contentSize.height -= (CGRectGetHeight(_tableView.frame)-height);
            self.scrollView.contentSize = contentSize;
            self.tableView.panGestureRecognizer.enabled = NO;
            
        }else{
            self.scrollView.contentSize = normalContentSize;
            self.tableView.panGestureRecognizer.enabled = YES;
        }
    }else{
        
        CGSize contentSize = normalContentSize;
        contentSize.height -= (CGRectGetHeight(_tableView.frame)-150);
        self.tableView.backgroundView = [Utility getUIImageViewByName:@"抢沙发.jpg"];
        self.tableView.panGestureRecognizer.enabled = NO;
        self.scrollView.contentSize = contentSize;
    }
    
}

@end
