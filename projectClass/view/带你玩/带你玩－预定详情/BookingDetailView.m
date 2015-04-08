//
//  BookingDetailView.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BookingDetailView.h"
#import "SenceHeadView.h"
#import "MainViewController.h"
#import "BookingDetailCell.h"
#import "HBJNSString.h"
#import "AlerView.h"
#import "LhNoticeMsg.h"
#import "VIewDadaGet.h"
#import "LoginView.h"
#import "MapButton.h"
#import "GlobalModel.h"
#import "HBJScrollView+Extenstion.h"

static BOOL alertViewWillShow = NO;//alert将要出现 default is no
@interface BookingDetailView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,VIewDadaGetDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    AlerView *t;
    NSInteger kuCun;// 剩余票量
}
@property(nonatomic,retain)NSMutableDictionary *mutDict;// 存放订单详情
@property(nonatomic,retain)NSString *mobileNumber;//存放联系电话号码
@property(nonatomic,retain)NSString *title;//存放该线路的标题
@property(nonatomic,retain)NSString *mzsmStr;//存放免责声明

@end

@implementation BookingDetailView

-(void)dealloc{
    self.alerturl = nil;
    self.mutDict = nil;
    self.mobileNumber = nil;
    self.title = nil;
    self.mzsmStr = nil;
    [super dealloc];
}
-(void)loadView:(NSDictionary*)allDict{
    self.alerturl = [allDict objectForKey:@"touimg"];
    self.mutDict = [allDict objectForKey:@"xq"];
    kuCun = [allDict intValue:@"kucun"];
    self.mzsmStr = [allDict strValueDeleteReturn:@"mzsm"];
    self.mobileNumber = [allDict strValue:@"old_mobile"];
    self.title = [allDict strValue:@"mobile_title"];
    
    [self initTableView];
    [self showUIViewList:@"UIView" index:0];
    UIView *view = [self viewWithTag:611];
    CGPoint point = {0,self.size.height - view.size.height};
    [view makeInsetShadowWithRadius:3.0 Color:[[UIColor blackColor] colorWithAlphaComponent:0.6] Directions:@[@"top"]];
    view.point = point;
    [self showUILabelList:@"UILabel" index:0 uiview:view];

    MapButton *button = [MapButton createMapButtonWithDict:@{@"title":@"免责声明",@"imageName":@"i6060(1).png"} point:CGPointMake(0, 0) style:1];
    [button addTarget:self action:@selector(gotoMZSM:) forControlEvents:UIControlEventTouchUpInside];
   UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 100)];
    button.center = view1.center;
    [view1 addSubview:button];
    [_tableView addFootView:view1];
    
    UILabel *label = (UILabel *)[self viewWithTag:411];
    NSString *priceStr = [allDict objectForKey:@"title_price"];
    priceStr = [priceStr deleteUselessZero];
    NSMutableString *tmpStr = [NSMutableString stringWithString:label.text];
    [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:priceStr];
    label.text = tmpStr;
    [self showColorButtonList:@"ColorButtons" index:0 uiview:view];
    
}

#pragma mark -showView
-(void)showView{
    [super showView];
    [[MainViewController sharedViewController] showLoad:self];
    [[VIewDadaGet sharedGameModel] TakeYdxqInfo:self.tag  delegate:self];
    
}

#pragma mark 回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_order_chuli]) {
        
        //更改 立即预定 按钮的状态
//        ACPButton *button = (ACPButton *)[self viewWithTag:211];
//        [button setFlatStyle:[Utility hexStringToColor:@"#c8c8c8"] andHighlightedColor:[Utility hexStringToColor:@"#c8c8c8"]];
//        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius = 5.0;
//        button.userInteractionEnabled = NO;
        [self dismissLoadMsgWithSuccess:@"预定成功"];
        [Utility delay:1.0 action:^{
            [self dismissLoadMsg];
            [self backClicked:nil];
        }];
        
    }else{
        
        [self loadView:dict];
        [[MainViewController sharedViewController] endLoad];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    
    if ([apiKey isEqualToString:app_order_chuli]) {
        
        [self dismissLoadMsgWithError:@"订单提交失败，请重试"];
    }else{
        [[MainViewController sharedViewController] endLoad];
        if (errNo == 2) {//用户未登录
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"未登录。请您请登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            alert.tag = -9988;
            [alert show];
            [alert release];
        }
    }
}
#pragma mark-alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t1 = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t1.controller = self.controller;
        [t1.controller push:t1 atindex:6];
    }else if (alertView.tag == -9988 && buttonIndex == 0){
        
        [self backClicked:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 199102) {
        alertViewWillShow = NO;
    }
}

#pragma mark- initTableView
-(void)initTableView{
    
    CGFloat naviH = CGRectGetHeight(self.naviView.frame);
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, naviH, self.size.width, self.size.height - (naviH+YGLY_VIEW_FLOAT(100))) style:UITableViewStylePlain] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BookingDetailCell class] forCellReuseIdentifier:@"bookingCell"];
    [self insertSubview:_tableView belowSubview:self.naviView];
    
}

#pragma mark- tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_mutDict allKeys].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YGLY_VIEW_FLOAT(86);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *value=@{@"baoxian":@{@"bgColor":@"#d85525",
                                    @"labelText":@"保险",
                                    @"imageName":@"险.png"},
                          @"eat":@{@"bgColor":@"#e29bb6",
                                   @"labelText":@"吃",
                                   @"imageName":@"吃.png"},
                          @"live":@{@"bgColor":@"#a5c8ec",
                                    @"labelText":@"住",
                                    @"imageName":@"住.png"},
                          @"traffic":@{@"bgColor":@"#30629a",
                                       @"labelText":@"交通",
                                       @"imageName":@"交通.png"},
                          @"sence":@{@"bgColor":@"#ff9933",
                                         @"labelText":@"景点",
                                         @"imageName":@"玩.png"},
                          @"other":@{@"bgColor":@"#99ff33",
                                     @"labelText":@"其它",
                                     @"imageName":@"其它.png"}
                          };
    NSDictionary *headDic = [value dictValue:[_mutDict allKeys][section]];
    
    SenceHeadView *senceHeadView = [SenceHeadView createSenceHeadViewWithDict:headDic frame:YGLY_VIEW_FRAME_ALL(CGRectMake(0, 20, 250, 49))];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.size.width, YGLY_VIEW_FLOAT(86))] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:senceHeadView];
    
    return view;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[_mutDict objectForKey:[_mutDict allKeys][section]] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YGLY_VIEW_FLOAT(130);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    BookingDetailCell *cell = (BookingDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"bookingCell" forIndexPath:indexPath];
    NSDictionary *dict = dict = [[_mutDict valueForKey:[_mutDict allKeys][indexPath.section]] objectAtIndex:indexPath.row];
    [cell setWithDict:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
#pragma mark- tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)gotoBooking:(id)sender{
    
//    if ([[GlobalModel sharedGameModel].selfUserProfile intValue:@"usertype"] != 1) {//非用户
//        
//        [Utility alertMsg:@"提示" msg:@"只有用户才可以操作此项"];
//        
//        return;
//    }

    t = [AlerView createAlerView:CGRectMake(0, 0, 290, 352.5) delegate:self plist:@"确认订单.plist"];
    DownloadUIImageView *imageView = (DownloadUIImageView *)[t viewWithTag:1211];
    [imageView setNewUrl:self.alerturl];
    imageView.size = YGLY_VIEW_SIZE(CGSizeMake(540, 250));
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.mobileNumber = [[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"username"];
    UITextField *textF = (UITextField *)[t viewWithTag:1611];
    textF.text = self.mobileNumber;
    textF.placeholder = ((self.mobileNumber== nil||self.mobileNumber.length<2)? @"请输入电话号码":self.mobileNumber);
    textF.returnKeyType = UIReturnKeyDone;
    textF.delegate = self;
    
    UILabel *label = (UILabel *)[t viewWithTag:1512];
    label.text = self.title;
    [self.controller addAlertView:t type:0];
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]autorelease];;
    [t addGestureRecognizer:singleTap];
}
-(void)handleSingleTap:(UITapGestureRecognizer *)tap{
    
    UITextField *textF = (UITextField *)[t viewWithTag:1611];
    [textF resignFirstResponder];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        t.center = self.center;
    } completion:^(BOOL finished) {
        ;
    }];
    
}

-(void)closeBtnClicked:(id)sender{
    
    [self handleSingleTap:nil];
    [self.controller handleSingleTap:nil];
}

#pragma mark- 数量的增加或者减少
-(void)btnClicked:(UIButton *)sender{
    
    UILabel *label = (UILabel *)[t viewWithTag:1516];
    if (sender.tag == 1412) {
        //set phone number
        UITextField *textF = (UITextField *)[t viewWithTag:1611];
        [textF becomeFirstResponder];
    }else if (sender.tag == 1413){
        //sub
        if ([label.text intValue] > 1) {
            label.text = [NSString stringWithFormat:@"%d",[label.text intValue]-1];
        }
    }else if (sender.tag == 1414){
        //add
        NSInteger min = MIN(kuCun, 10);
        label.text = [NSString stringWithFormat:@"%ld",(long)([label.text intValue] >= min ? min:([label.text intValue]+1))];
    }
}
-(void)confirmBookingClicked:(id)sender{
    
    EBLog(@"确认预订");
    UITextField *textF = (UITextField *)[t viewWithTag:1611];
    UILabel *label = (UILabel *)[t viewWithTag:1516];
    if(![Utility checkPhoneNum:textF.text]){
       
        [[LhNoticeMsg sharedInstance] ClearBeforeShowNow:@"无效的手机号"];
        return;
    }
    
    [self closeBtnClicked:nil];
    [[VIewDadaGet sharedGameModel] YuDingTiJiaoWith:self.tag catId:76 tel:[textF.text deleteIncludeCharacterSet:[NSCharacterSet whitespaceCharacterSet]] yd_num:[label.text integerValue] delegate:self];
    [self showLoadMsg:@"订单提交中..."];
}

#pragma mark- textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
   // textField.text = @"";
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGPoint point = t.point;
        point.y -= YGLY_VIEW_FLOAT(250);
        t.point = point;
    } completion:^(BOOL finished) {
        ;
    }];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSRange tmpRange = NSMakeRange(0, textField.text.length+string.length);
    NSRange textRange = NSUnionRange(range, tmpRange);
    
    if (textRange.length <= 11) {//手机号不能超过十一位
        
        return YES;
    }
    return NO;
}

#pragma mark-  弹出免责声明
-(void)gotoMZSM:(UIButton *)sender{
 
    alertViewWillShow = YES;
    if ([Utility getSystemVersion] >= 8.0) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"免责声明" message:self.mzsmStr preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertViewWillShow = NO;
        }]];
        CGRect rect = alertVC.view.frame;
        if (rect.size.height > 468) {
            
            rect.origin.y = (rect.size.height - 468)/2.0 + rect.origin.y;
            rect.size.height = 468;
            alertVC.view.frame = rect;
        }
        
        [[MainViewController sharedViewController] presentViewController:alertVC animated:YES completion:nil];
        
    }else{
     
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"免责声明" message:self.mzsmStr delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        alterView.tag = 199102;
        [alterView show];
        [alterView release];
    }
}
#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}

#pragma mark
-(void)receiveNotifications:(NSInteger)type{
    
    if (type == YGLYNoticeTypeLoginSuccess) {
        
        [[VIewDadaGet sharedGameModel] TakeYdxqInfo:self.tag  delegate:self];
        [Utility delay:0.002 action:^{
            [[MainViewController sharedViewController] showLoad:self];
        }];
    }
}
@end

#pragma mark-   针对所有的UILabel－这里只针对免责声明（文本左对齐）

@implementation UILabel (ChangeTextAlignment)

-(void)layoutSubviews{

    for (UIView *view in [MainViewController sharedViewController].view.subviews) {

        if ([view isMemberOfClass:[BookingDetailView class]]) {

            if (alertViewWillShow) {

                //只针对免责声明作出局部调整
                if (self.text.length > 0 && ![self.text isEqualToString:@"我知道了"] && ![self.text isEqualToString:@"免责声明"]) {

                    self.textAlignment = NSTextAlignmentLeft;
                }
            }
        }
    }

    [super layoutSubviews];
}

@end

