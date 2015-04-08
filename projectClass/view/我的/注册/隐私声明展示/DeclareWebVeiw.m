//
//  DeclareWebVeiw.m
//  yglyProject
//
//  Created by 枫 on 14-9-25.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DeclareWebVeiw.h"
#import "Utility.h"

@implementation DeclareWebVeiw

- (void)dealloc{
    
    
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
    
    self.webView = nil;
    [super dealloc];
}

- (void)showView{
    
   // self.clipsToBounds = NO;
     [super showView];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWebView];
    [self showButtonList:@"Buttons" index:0];
    
}

- (void)initWebView{
    
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(30, 30, CGRectGetWidth(self.frame) - 2 * 30, CGRectGetHeight(self.frame) - 2 *30)]autorelease];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.weibo.com/eachbaby"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
    
    self.webView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.webView.layer.shadowRadius = 5.0;
    self.webView.layer.shadowOpacity = 0.7;
    self.webView.layer.shadowOffset = CGSizeMake(3, 3);
    
    [self addSubview:self.webView];
}

#pragma mark 获取push特效
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    //   return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromBottom];
    return nil;
}


@end
