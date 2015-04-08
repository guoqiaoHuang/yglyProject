//
//  BusinessOrderDetailView.h
//  yglyProject
//
//  Created by 枫 on 14-11-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"

@interface BusinessOrderDetailView : BackTitleUIImageView
{
    NSInteger orderState;//2－全部 0-未验证 1-已验证
}
@property(nonatomic,retain) UIView *checkView;//用于验证的view
@property(nonatomic,retain) UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *fakeData;//全部
@property (nonatomic,retain) NSMutableArray *invalidateData;//未验证数据数组
@property (nonatomic,retain) NSMutableArray *validateData;//已验证数据数组
@property (nonatomic,assign) NSMutableArray *orderTmpArray;//存放临时数据

@property (nonatomic,retain)NSString *productId;
@property (nonatomic,retain)NSString *catId;
@property (nonatomic,readonly)UISegmentedControl *seg;

-(NSInteger)getOrderState;
@end
