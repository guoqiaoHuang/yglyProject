

//商家订单中心－cell
#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
@interface BusinessOrderCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    DownloadUIImageView *photo;//头像
    UILabel *titleLabel;
    UILabel *numberLabel;
    UILabel *timeLabel;
    CGPoint scrollOffest;
    BOOL flagStop;
    
}
@property(nonatomic,assign)UIScrollView*scroll;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)id delegate;
-(void)setDict:(NSDictionary*)dict;
-(void)resetOff;
-(void)resetAni;
@end
