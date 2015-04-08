#import <UIKit/UIKit.h>
#import"BaseViewController.h"
@interface MainViewController : BaseViewController<UIWebViewDelegate>
{
    long firsttime;
    UIView*adEffec;//广告
    CGRect viewRect;
    UIImageView *loadAni;
    UIWebView *myWebView;
}
+ (MainViewController*)sharedViewController;
+(BaseUIImageView*)getNowView;
-(void)showViewByIdAndType:(NSInteger)idValue typeValue:(NSInteger)typeValue;
-(void)postViewByMsg:(NSString*)msg;

-(void)showLoad:(UIView*)t;
-(void)endLoad;
@end
