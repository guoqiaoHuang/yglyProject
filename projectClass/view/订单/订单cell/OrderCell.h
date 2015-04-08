

//用户订单中心－cell
#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
@interface OrderCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    DownloadUIImageView *photo;//头像
    UILabel *dingdanHao;
    UILabel *titleName;
    UILabel *numberLabel;
    UILabel *priceLabel;
    UIButton *button;
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
