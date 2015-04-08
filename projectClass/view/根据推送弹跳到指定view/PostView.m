#import "PostView.h"

@implementation PostView


-(id)initWithFrame:(CGRect)frame msg:(NSString*)msg{
    [super initWithFrame: frame];
    
    [self showLoadMsg:@"加载中..."];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMsg:msg];
        
    });

    return self;
}

-(void)showView{
    [super showView];
    self.backgroundColor = [UIColor blueColor];
    [self showColorButtonList:@"ColorButton" index:0];
}

-(void)showMsg:(NSString*)msg{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissLoadMsg];
    });
}
-(CATransition*)getReplace{
    return nil;
}

@end
