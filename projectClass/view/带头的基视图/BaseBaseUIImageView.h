//
//  BaseBaseUIImageView.h
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BaseUIImageView.h"
#import "BaseAllShowViewBaseView.h"

@interface BaseBaseUIImageView : BaseAllShowViewBaseView<UISearchBarDelegate>

@property (nonatomic, retain)UITableView *resultTableView;
@property (nonatomic, retain)UIView *maskView;
- (void)hiddenKeyBoard;
//进入地图调用
-(void)gotoMapBtn:(UIButton *)sender;
#pragma mark 搜索添加返回数据key
-(NSDictionary*)getSearchDict;
@end
