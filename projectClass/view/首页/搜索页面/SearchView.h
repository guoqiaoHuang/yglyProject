//
//  SearchView.h
//  yglyProject
//
//  Created by 枫 on 14-10-30.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"


@interface SearchViewCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    DownloadUIImageView *photo;//头像
    UILabel *titleName;
}
-(void)setDict:(NSDictionary*)dict;
@end

@interface SearchView : BackTitleUIImageView<VIewDadaGetDelegate>
{
    BOOL flagStop;
    NSInteger page;
    UISearchBar *lhSearchBar;
}
@property(nonatomic,copy) NSString *oldSearchMsg;
@property(nonatomic,retain)NSDictionary*searchDict;
@end
