#import <UIKit/UIKit.h>
#import "DownloadUIImageView.h"
#import "LhLocationModel.h"
@protocol TakePlayCellDelegate <NSObject>

-(void)takePlayCellDidSelected:(NSInteger)indexPath;

@end

@interface TakePlayCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    DownloadUIImageView *senceImage;//景区风景图片
    UILabel *titleLabel;//景区标题
    UILabel *dateLabel;//时间
    UILabel *routeLabel;//行程天数
    UILabel *locationLabel;//景区地点
    UILabel *peoplesLabel;//参加人数
    UILabel *typesLabel[3];//存放一组标签，用来说明景区的类型
    UILabel *priceLabel;//景区价格
    BOOL flagStop;
    float cellwidth;
}
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,readonly)UIScrollView *scroll;
@property(nonatomic,assign)id<TakePlayCellDelegate> delegate;
-(void)setDict:(NSDictionary*)dict;
-(void)resetOff;
-(void)resetAni;
@end
