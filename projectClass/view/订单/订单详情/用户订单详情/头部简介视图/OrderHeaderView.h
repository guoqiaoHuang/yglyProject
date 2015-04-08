

#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
#import "StrikeThroughLabel.h"

@protocol OrderHeaderViewDelegate <NSObject>

- (void)orderHeaderViewhadTap;

@end
@interface OrderHeaderView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    DownloadUIImageView *photo;//头像
    UILabel *titleLabel;
    UILabel *priceLabel;
    StrikeThroughLabel *originalPriceLabel;// 中划线label 原价
    UIImageView *imageView;//
    CGPoint scrollOffest;
    
}
@property(nonatomic,assign)UIScrollView*scroll;
@property(nonatomic,assign)id<OrderHeaderViewDelegate> delegate;

-(void)setDict:(NSDictionary*)dict;

@end
