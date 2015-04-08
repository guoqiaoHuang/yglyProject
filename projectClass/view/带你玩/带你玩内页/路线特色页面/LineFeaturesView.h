//
//  LineFeaturesView.h
//  yglyProject
//
//  Created by 枫 on 14-10-29.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
@interface LineFeaturesView : BackTitleUIImageView<VIewDadaGetDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView*activityIndicator;
    UIWebView*webt;
    NSString *text;
}
@property(nonatomic,retain) NSString*urlString;
@property(nonatomic,retain) NSString*text;
@property(nonatomic,retain)NSMutableArray*urlArrays;
@end
