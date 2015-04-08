//
//  LineFeaturesView.m
//  yglyProject
//
//  Created by 枫 on 14-10-29.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "LineFeaturesView.h"
#import "MainViewController.h"
#import "WeixinShowUrlImage.h"
@implementation LineFeaturesView
@synthesize text;
#pragma mark 回调
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString *)msg forApi:(NSString *)apiKey{
    
    [self getSuccesFinished:apiKey dict:nil];
}
-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    NSURL *url =[NSURL URLWithString:_urlString];
    self.text=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [webt loadHTMLString:text baseURL:nil];
    [webt setScalesPageToFit:YES];
    webt.delegate = self;
    activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)]autorelease];
    [activityIndicator setCenter:self.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSURL *url = [request URL];
        NSString*str = [NSString stringWithFormat:@"%@",url];
        EBLog(@"%@",str);
        return NO;
    }else{
        NSURL *url = [request URL];
        NSString*str = [NSString stringWithFormat:@"%@",url];
        EBLog(@"%@",str);
    }
    return YES;
}




- (void)webViewDidFinishLoad:(UIWebView *)webView{
   //获取网页高度
   // CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    [activityIndicator stopAnimating];
    self.urlArrays = [Utility getHtmlImageArray:self.text];
    EBLog(@"%@",self.urlArrays);
    
}

-(void)showView{
    webt = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 50, self.size.width, self.size.height-50)]autorelease];
    webt.delegate = self;
    [self addSubview:webt];
    [super showView];
    [[VIewDadaGet sharedGameModel] TakeXlteInf:self.tag  delegate:self];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webt addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}


#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:webt];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [webt stringByEvaluatingJavaScriptFromString:imgURL];
    if (urlToSave.length > 0) {
        int i = 1;
        for (NSString*url in self.urlArrays) {
            if ([url isEqualToString:urlToSave]) {
                BaseUIImageView *view = [WeixinShowUrlImage Create:self.urlArrays nowI:i frame:self.bounds];
                view.controller = self.controller;
                [self.controller push:view atindex:10];
                break;
            }
            i++;
        }
    }
}


#pragma mark- pop动画
-(CATransition*)getPopo{
    
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.35 Type:kCATransitionReveal Subtype:kCATransitionFromLeft];
}

-(void)dealloc{
    
    self.urlString = nil;
    self.text = nil;
    self.urlArrays = nil;
    [super dealloc];
}
@end
