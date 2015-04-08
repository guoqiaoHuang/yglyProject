//
//  BusinessOrderDetailCell.m
//  yglyProject
//
//  Created by 枫 on 14-11-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

/*
 NSDictionary *dict = @{@"photo":@"",
 @"defaultImageName":@"",
 @"dingdanhao":@"",
 @"number":@"",
 @"price":@"",
 @"validateState":@"",
 @"phoneNumber":@""};
 */

#import "BusinessOrderDetailCell.h"
#import "BaseUIImageView.h"
#import "AlerView.h"
#import "MainViewController.h"
#import "APService.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"

@interface BusinessOrderDetailCell ()<UIAlertViewDelegate,VIewDadaGetDelegate>
{
    AlerView *t;
}
@end

@implementation BusinessOrderDetailCell

-(void)dealloc{
    
    self.indexPath = nil;
    [super dealloc];
}
-(void)setDict:(NSDictionary*)dict{
    
    if (!self.bgView) {
        
        _bgView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        CGFloat topDistance = 20;//px
        userImageView = (DownloadUIImageView*)[DownloadUIImageView Create:nil defauleImage:[dict objectForKey:@"defaultImageName"]];
        userImageView.layer.masksToBounds = YES;
        CGPoint center = userImageView.center;
        center.y = _bgView.center.y;
        userImageView.center = center;
        userImageView.layer.cornerRadius = userImageView.size.width/2.0;
        [_bgView addSubview:userImageView];
        
        CGFloat photoW = CGRectGetMaxX(userImageView.frame)/YGLY_SIZE_SCALE + 20;//(px)
        dingdanhaoLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(CGRectMake(photoW, topDistance, 400, 50))]autorelease];
        dingdanhaoLabel.textColor = [UIColor blackColor];
        dingdanhaoLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        dingdanhaoLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [Utility addBevel:dingdanhaoLabel ahScale:0.5];
        [_bgView addSubview:dingdanhaoLabel];
        
        CGRect numberRect = {{photoW,topDistance+50},{180,50}};
        numberLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(numberRect)]autorelease];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [_bgView addSubview:numberLabel];
        
        CGRect priceRect = {{photoW+180,topDistance+50},{180,50}};
        priceLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(priceRect)]autorelease];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [_bgView addSubview:priceLabel];
        
        NSDictionary *colorBtnDict = @{@"title":@"",
                                       @"method":@"colorBtnClicked:",
                                       @"size":@"{148,44}",
                                       @"size_Iphone4":@"{100,22}",
                                       @"size_Iphone5":@"{100,22}",
                                       @"size_Iphone6":@"{100,22}",
                                       @"position":[NSString stringWithFormat:@"{%f,%f}",photoW,topDistance+50*2],
                                       @"position_Iphone4":[NSString stringWithFormat:@"{%f,%f}",photoW,topDistance+50*2],
                                       @"position_Iphone5":[NSString stringWithFormat:@"{%f,%f}",photoW,topDistance+50*2],
                                       @"position_Iphone6":[NSString stringWithFormat:@"{%f,%f}",photoW,topDistance+50*2],
                                       @"fontsize":@"26",
                                       @"fontsize_Iphone4":@"13",
                                       @"fontsize_Iphone5":@"13",
                                       @"fontsize_Iphone6":@"13",
                                       @"highlightcolor":@"#b40000",
                                       @"color":@"#ff9933",
                                       @"textcolor":@"#ffffff",
                                       @"texthighlightcolor":@"#ffffff",
                                       @"cornerradius":@"5",
                                       @"tag":@"13001"};
        stateButton = (ACPButton *)[BaseUIImageView setColorButtonWithDict:colorBtnDict target:self];
        [_bgView addSubview:stateButton];
        
        colorBtnDict = @{@"title":@"",
                                       @"method":@"colorBtnClicked:",
                                       @"size":@"{148,44}",
                                       @"size_Iphone4":@"{74,22}",
                                       @"size_Iphone5":@"{74,22}",
                                       @"size_Iphone6":@"{74,22}",
                                       @"position":[NSString stringWithFormat:@"{%f,%f}",photoW+200+25,topDistance+50*2],
                                       @"position_Iphone4":[NSString stringWithFormat:@"{%f,%f}",photoW+200+25,topDistance+50*2],
                                       @"position_Iphone5":[NSString stringWithFormat:@"{%f,%f}",photoW+200+25,topDistance+50*2],
                                       @"position_Iphone6":[NSString stringWithFormat:@"{%f,%f}",photoW+200+25,topDistance+50*2],
                                       @"fontsize":@"26",
                                       @"fontsize_Iphone4":@"13",
                                       @"fontsize_Iphone5":@"13",
                                       @"fontsize_Iphone6":@"13",
                                       @"highlightcolor":@"#b40000",
                                       @"color":@"#ff9933",
                                       @"textcolor":@"#ffffff",
                                       @"texthighlightcolor":@"#ffffff",
                                       @"cornerradius":@"5",
                                       @"tag":@"13002"};
        callHe = (ACPButton *)[BaseUIImageView setColorButtonWithDict:colorBtnDict target:self];
        [_bgView addSubview:callHe];
        
        NSDictionary *btnDict = @{@"title":@"",
                                  @"image":@"拨打电话默认.png",
                                  @"highlighted":@"拨打电话按下.png",
                                  @"method":@"colorBtnClicked:",
                                  @"position":[NSString stringWithFormat:@"{%f,%f}",540.0,0.0],
                                  @"position_Iphone4":[NSString stringWithFormat:@"{%f,%f}",540.0,0.0],
                                  @"position_Iphone5":[NSString stringWithFormat:@"{%f,%f}",540.0,0.0],
                                  @"position_Iphone6":[NSString stringWithFormat:@"{%f,%f}",540.0,0.0],
                                  @"tag":@"",
                                  @"hidden":@""};

        UIButton *button = [BaseUIImageView setButtonWithDict:btnDict target:self];
        center = button.center;
        center.y = _bgView.center.y;
        button.center = center;
        [_bgView addSubview:button];
    }
    
    [userImageView setNewUrl:[dict strValue:@"photo" default:@""]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger state = [dict intValue:@"validateState"];
        if (state == 1) {
            dingdanhaoLabel.backgroundColor = [Utility hexStringToColor:@"#e8e8e8"];
        }else{
            dingdanhaoLabel.backgroundColor = [Utility hexStringToColor:@"#ff9933"];
        }
       
        NSString *dingdanhaoStr = [dict strValue:@"dingdanhao" default:@""];
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (NSInteger i = 0; i < dingdanhaoStr.length; i++) {
            
            if (i % 4 == 0) {
                
                NSRange range = NSMakeRange(i, 4);
                if ((range.location + range.length) > dingdanhaoStr.length) {
                    
                    range.length = dingdanhaoStr.length - range.location;
                }
                [tmpArray addObject:[dingdanhaoStr substringWithRange:range]];
            }
        }
        dingdanhaoStr = [tmpArray componentsJoinedByString:@" "];
        dingdanhaoLabel.text = [NSString stringWithFormat:@"订单号：%@",dingdanhaoStr];
        
        numberLabel.text = @"数量：";
        NSMutableString *tmpStr = [NSMutableString stringWithString:numberLabel.text];
        [tmpStr appendFormat:@"%@/%@",[dict strValue:@"yz_num" default:@"0"],[dict strValue:@"number" default:@"0"]];
        numberLabel.text = tmpStr;
        
        priceLabel.text = @"价格：";
        tmpStr = [NSMutableString stringWithString:priceLabel.text];
        [tmpStr appendString:[dict strValue:@"price" default:@"0"]];
        priceLabel.text = tmpStr;
        
        stateButton.hidden = YES;
        callHe.hidden = YES;
        if ([dict intValue:@"validateState"] == 1) {//验证状态－－已验证
            
            [stateButton setFlatStyle:[Utility hexStringToColor:@"#e8e8e8"] andHighlightedColor:[Utility hexStringToColor:@"#e8e8e8"]];
            [stateButton setTitle:@"已联系" forState:UIControlStateNormal];
            [stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            stateButton.userInteractionEnabled = NO;
            stateButton.layer.masksToBounds = YES;
            stateButton.layer.cornerRadius = 5;
            stateButton.hidden = NO;
        }else{//未验证
            stateButton.userInteractionEnabled = YES;
            [stateButton setFlatStyle:[Utility hexStringToColor:@"#b40000"] andHighlightedColor:[Utility hexStringToColor:@"#ff9933"]];
            [stateButton setTitle:@"是否已联系" forState:UIControlStateNormal];
            [stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            stateButton.layer.masksToBounds = YES;
            stateButton.layer.cornerRadius = 5;
            stateButton.hidden = NO;
            
            if ([dict intValue:@"isNotice"] == 1) {//是否通知过了，0-未提醒 1-提醒过了
                
                [callHe setFlatStyle:[Utility hexStringToColor:@"#e8e8e8"] andHighlightedColor:[Utility hexStringToColor:@"#e8e8e8"]];
                [callHe setTitle:@"已提醒" forState:UIControlStateNormal];
                [callHe setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                callHe.userInteractionEnabled = NO;
                callHe.layer.masksToBounds = YES;
                callHe.layer.cornerRadius = 5;
                callHe.hidden = NO;
            }else{
                
                [callHe setFlatStyle:[Utility hexStringToColor:@"#b40000"] andHighlightedColor:[Utility hexStringToColor:@"#ff9933"]];
                [callHe setTitle:@"提醒TA" forState:UIControlStateNormal];
                [callHe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                callHe.userInteractionEnabled = YES;
                 callHe.layer.masksToBounds = YES;
                callHe.layer.cornerRadius = 5;
                callHe.hidden = NO;
            }
        }
        
        phoneNumber = [dict strValue:@"phoneNumber" default:@""];
    });
    
}

-(void)colorBtnClicked:(UIButton *)sender{
    
    if([sender isKindOfClass:[ACPButton class]]){
        
        if (sender.tag == 13001) {//是否已联系
            
            UIAlertView *alterView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请按确认按钮，确认您已经通知了用户！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
            [alterView show];
        }else if (sender.tag == 13002){
           
            if (t == nil) {
                
                t = [[AlerView createAlerView:CGRectMake(0, 0, 290, 352.5) delegate:self plist:@"提醒用户.plist"] retain];
                if (_delegate && _indexPath) {
                    
                    NSMutableDictionary *dict = [_delegate.orderTmpArray objectAtIndex:_indexPath.row];
                    UILabel *label = (UILabel *)[t viewWithTag:1512];
                    label.lineBreakMode = NSLineBreakByTruncatingTail;
                    label.text = dict[@"mobile_title"];
                   
                    label = (UILabel *)[t viewWithTag:1514];
                    label.text = dict[@"order_sn"];
                }
            }
            [[MainViewController sharedViewController] addAlertView:t type:2];
        }
    }else{
        /*
         [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:10]
         alertBody:@"嗨！我们都准备好了\n【抱龙峪纳凉、看瀑布二日游】\n记得不要迟到哦~\n订单号：3244 4324 4344 980"
         badge:[UIApplication sharedApplication].applicationIconBadgeNumber++
         alertAction:@"好的"
         identifierKey:@""
         userInfo:@{}
         soundName:nil];
         */
        [Utility callPhone:phoneNumber];
    }
}

-(void)closeBtnClicked:(UIButton *)sender{
    
    [[MainViewController sharedViewController] handleSingleTap:nil];
}
-(void)confirmBtnClicked:(UIButton *)sender{
    
    [self closeBtnClicked:nil];
    if (_delegate && _indexPath) {
        
         NSMutableDictionary *dict = [_delegate.orderTmpArray objectAtIndex:_indexPath.row];
        [[LhNoticeMsg sharedInstance] ShowMsg:@"消息发送中..."];
        NSString *msg = [NSString stringWithFormat:@"嗨！我们都准备好了\n[%@]\n记得不要迟到哦～\n%@",dict[@"mobile_title"],dict[@"order_sn"]];
        [[VIewDadaGet sharedGameModel] DingDanForTiXi:dict[@"userid"] orderNumber:dict[@"order_sn"] content:msg delegate:self];
    }
}

#pragma mark - alterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        return;
    }else if (buttonIndex == 1){
        
        if (_delegate && _indexPath) {
            
            NSMutableDictionary *dict = [_delegate.orderTmpArray objectAtIndex:_indexPath.row];
            [[LhNoticeMsg sharedInstance] ShowMsg:@"与服务器通信中..."];
            [[VIewDadaGet sharedGameModel] DingDanForLianXi:dict[@"order_sn"] delegate:self];
            
        }
    }
}

#pragma mark -数据请求回调
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_dingdan_shanghu_lianxi]) {
        
        [LhNoticeMsg hideView];
        NSMutableDictionary *dict = [_delegate.orderTmpArray objectAtIndex:_indexPath.row];
        [dict setValue:@"1" forKey:@"is_sure"];
        if ([_delegate getOrderState] == 0) {//未验证
            
            [_delegate.seg sendActionsForControlEvents:UIControlEventValueChanged];
        }else{
             [_delegate.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([apiKey isEqualToString:app_dingdan_shanghu_tixi]){
        
        [[LhNoticeMsg sharedInstance] ShowMsg:@"发送成功"];
        NSMutableDictionary *dict = [_delegate.orderTmpArray objectAtIndex:_indexPath.row];
        [dict setValue:@"1" forKey:@"status"];
        [_delegate.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [[LhNoticeMsg sharedInstance] ShowMsg:@"失败，请重试"];
}
@end
