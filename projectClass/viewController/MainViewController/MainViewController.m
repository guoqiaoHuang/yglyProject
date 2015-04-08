#import "MainViewController.h"
#import "MainUIImageView.h"
#import "TakePlayView.h"
#import "MyView.h"
#import "OrderView.h"
#import "SubjectToPlayView.h"
#import "PostView.h"
#import "LhNoticeMsg.h"
#import "IpadMainUIImageView.h"

#import "FeaturePlayInnerView.h"
#import "ThematicPlayInnerView.h"
#import "TakePlayInsidePages.h"
@implementation MainViewController
static MainViewController *mainViewController = nil;

#pragma mark 单例
+ (MainViewController*)sharedViewController{
    if (!mainViewController){
        mainViewController = [[MainViewController alloc] init];
    }
    return mainViewController;
}
#pragma mark 当前view层
+(BaseUIImageView*)getNowView{
    return [[MainViewController sharedViewController] getNowView];
}
-(void)showLoad:(UIView*)t{
    [t addSubview:loadAni];
    [loadAni startAnimating];
    [loadAni fadeIn];
}
-(void)endLoad{
    [loadAni startAnimating];
    [loadAni fadeOut];
}


#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/lh"] ) {
        [myWebView fadeOut:0.5 complete:^{
            [myWebView removeFromSuperview];
            myWebView = nil;
        }];
        return false;
    }
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.hidden = NO;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //钱包报警标记
    BOOL isfirstLogin = [userDefaults boolForKey:@"isFirstOne"];
    isfirstLogin = NO;
    if (!isfirstLogin) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:!isfirstLogin forKey:@"isFirstOne"];
        [userDefaults synchronize];
        myWebView= [[[UIWebView alloc]initWithFrame:self.view.bounds]autorelease];
        [self.view addSubview:myWebView];
        myWebView.delegate=self;
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [myWebView loadRequest:request];
        [self.view addSubview:myWebView];
        [myWebView setScalesPageToFit:YES];
        myWebView.hidden = YES;
    }
     viewRect = self.view.bounds;
    adEffec = [Utility getUIImageViewByName:@"ffff.jpeg"];
    adEffec.frame = self.view.bounds;
    adEffec.userInteractionEnabled = !adEffec.userInteractionEnabled;
    [self.view  addSubview:adEffec];
    firsttime = [[NSDate date] timeIntervalSince1970];
    loadAni = [Utility getAnimationWithDict:[self.dictionary objectForKey:@"loadAni"]];
    loadAni.center = self.view.center;
    loadAni.hidden = YES;
    [loadAni retain];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([Utility getNode].isIpad) {
            [self showIpad];
        }else{
            [self showIphone];
        }
    });
}
#pragma mark---
#pragma mark ipad_begin
-(void)showIpad{
    self.view.backgroundColor = [UIColor blackColor];
    [self showUILabelList:@"BackTitleUILabel_ipad" index:0];
    [self showRadioButtonList:@"RadioButton_ipad" index:0];
    IpadMainUIImageView*t = [[[IpadMainUIImageView alloc]initWithFrame:CGRectMake(128, 80, 1024-128, 768-80)] autorelease];
    t.controller = self;
    [self replace:t];
    [self.view bringSubviewToFront:adEffec];
    firsttime = [[NSDate date] timeIntervalSince1970] - firsttime;
    if (firsttime <= adEffecTime) {
        [self performSelector:@selector(test) withObject:nil afterDelay:adEffecTime-firsttime];
    }else{
        [self test];
    }
}
-(void)test{
    if (myWebView) {
        [myWebView fadeIn];
    }
    [adEffec fadeOut];
    
}
#pragma mark---
#pragma mark iphone_begin

-(void)showIphone{
    [self showEffectRadioList:@"EffectRadio" index:0];
    MainUIImageView*t = [[[MainUIImageView alloc]initWithFrame:viewRect] autorelease];
    t.controller = self;
    [self replace:t];
    if (myWebView) {
        [self.view bringSubviewToFront:myWebView];
    }
    [self.view bringSubviewToFront:adEffec];
    firsttime = [[NSDate date] timeIntervalSince1970] - firsttime;
    if (firsttime <= adEffecTime) {
        [self performSelector:@selector(test) withObject:nil afterDelay:adEffecTime-firsttime];
    }else{
        [self test];
    }
}
- (void)didSelectedRadioButton:(EffectRadio *)radio groupId:(NSString *)groupId{
    if ([Utility getNode].isIpad) {
        EBLog(@"tag:%ld",(long)radio.tag);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (radio.tag == 1) {
            MainUIImageView*t = [[[MainUIImageView alloc]initWithFrame:viewRect] autorelease];
            t.controller = self;
            [self replace:t];
        }else if(radio.tag == 2){
            TakePlayView*t = [[[TakePlayView alloc]initWithFrame:viewRect] autorelease];
            t.controller = self;
            [self replace:t];
        }else if(radio.tag == 3){
            SubjectToPlayView*t = [[[SubjectToPlayView alloc]initWithFrame:viewRect] autorelease];
            t.controller = self;
            [self replace:t];
        }else if(radio.tag == 4){
            OrderView*t = [[[OrderView alloc]initWithFrame:viewRect] autorelease];
            t.controller = self;
            [self replace:t];
        }else if(radio.tag == 5){
            MyView*t = [[[MyView alloc]initWithFrame:viewRect] autorelease];
            t.controller = self;
            [self replace:t];
        }

    });
    
}

-(void)postViewByMsg:(NSString*)msg{
    PostView*t = [[[PostView alloc]initWithFrame:self.view.frame msg:msg] autorelease];
    t.controller = self;
    [self push:t atindex:10];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
}


-(void)showViewByIdAndType:(NSInteger)idValue typeValue:(NSInteger)typeValue{
    BaseUIImageView *t = nil;
    switch (typeValue) {
        case 114://特色玩法
        {
            FeaturePlayInnerView *view = [FeaturePlayInnerView alloc];
            view.tag = idValue;
            view.selfCatid= typeValue;
            [[view initWithFrame:self.view.bounds] autorelease];
            t = view;
        }
            break;
        case 23://主题活动
        {
            ThematicPlayInnerView*view = [ThematicPlayInnerView alloc];
            view.tag = idValue;
            view.selfCatid= 23;
            [[view initWithFrame:self.view.bounds] autorelease];
            t = view;
        }
            break;
        case 76://带你玩页面
        {
            TakePlayInsidePages*view = (TakePlayInsidePages*)[Utility getViewToId:@"TakePlayInsidePages" tag:idValue rect:self.view.bounds];
            t = view;
        }
            break;
        default:
            break;
    }
    if (t) {
        t.controller = self;
        [self push:t atindex:6];
    }
    
    
}

@end
