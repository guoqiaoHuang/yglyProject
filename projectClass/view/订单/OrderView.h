#import "BaseUIImageView.h"
#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
@interface OrderView : BackTitleUIImageView <UITableViewDelegate, UITableViewDataSource,VIewDadaGetDelegate,UIAlertViewDelegate>
{
    BOOL isbusiness;//是否是商户
    NSInteger orderState;//0－全部 1-未过期 2-已过期 3-已完成
    NSMutableArray *orderTmpArray;
}
@property(nonatomic,retain) UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *expiredData;
@property (nonatomic,retain) NSMutableArray *notExpiredData;
@property (nonatomic,retain) NSMutableArray *completeData;

@property (nonatomic,retain) NSMutableArray *fakeData;
@property (nonatomic,retain) NSMutableArray *businessData;
@property (nonatomic,retain) NSMutableDictionary *posDict;
-(void)clickCellButton:(NSInteger)row;
-(void)cellWillBeginDecelerating:(id)nowCell;
@end
