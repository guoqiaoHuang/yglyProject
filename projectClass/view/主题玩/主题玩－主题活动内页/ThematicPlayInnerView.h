//
//  ThematicPlayInnerView.h
//  yglyProject
//
//  Created by 枫 on 14-11-3.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"
@interface ThematicPlayInnerView : BackTitleUIImageView<VIewDadaGetDelegate>
{
    NSInteger xhNum;
    UICollectionView *_collectionView;
    BOOL flagStop;
    
    
    NSInteger nowIndexMsgRow;
}
@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain) NSMutableDictionary *posDict;
@property(nonatomic,retain)NSArray*lineDatas;//新路列表数据
@property(nonatomic,retain)NSArray*taLove;//喜欢列表数据
@property(nonatomic,assign)NSInteger selfCatid;
@property(nonatomic,assign)BOOL isLove;
@property(nonatomic,retain)NSMutableArray*chatMsgArray;
@end
