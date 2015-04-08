#import "BaseBaseUIImageView.h"
#import "LHScrollNumView.h"

#import "VIewDadaGet.h"
@interface SubjectToPlayView : BaseBaseUIImageView<UITableViewDelegate, UITableViewDataSource,VIewDadaGetDelegate>{
    BOOL flagStop;
    NSInteger page;
    NSInteger type;
}
@property(nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *thematicFakeData;//存放 主题活动 数据
@property (nonatomic,retain) NSMutableArray *featureFakeData;//存放 特色玩法 数据
@end
