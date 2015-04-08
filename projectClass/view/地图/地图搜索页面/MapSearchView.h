//
//  SearchView.h
//  yglyProject
//
//  Created by 枫 on 14-10-30.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "MapView.h"


@interface MapSearchView : BackTitleUIImageView<UISearchBarDelegate>
{
    UISearchBar *lhSearchBar;
    UITableView *_tableView;
}
@property(nonatomic,assign) NSInteger type; //0-有搜索条 1-没有搜索条
@property(nonatomic,assign) MapView *delegate;

@end
