#import "BaseBaseUIImageView.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"
@interface TakePlayView : BaseBaseUIImageView<UITableViewDelegate, UITableViewDataSource,VIewDadaGetDelegate>
{
    NSInteger dayFlag;
    BOOL timeFlag;
    BOOL priceFlag;
    BOOL flagStop;
    NSInteger btnState;//控制排序 1-时间优先 2-价格优先 默认是时间优先
}
@property(nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *fakeData;
@property (nonatomic,retain) NSMutableDictionary *posDict;
-(void)cellWillBeginDecelerating:(id)nowCell;
@end
