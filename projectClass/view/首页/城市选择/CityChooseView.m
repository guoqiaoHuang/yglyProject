
#import "Utility.h"
#import "CityChooseView.h"
#import "LhLocationModel.h"
#import "NstimerModel.h"
#import "ProvincesAndCitysControl.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "HBJTableView.h"
#import "ObserversNotice.h"

@interface CityChooseView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain)UITableView *leftTableView;
@property(nonatomic, retain)UITableView *rightTableView;
@property(nonatomic, retain)NSIndexPath *curIndexPath;//当前选中省份的indexPath
@property(nonatomic, retain)NSMutableArray *resultArray;//存放搜索结果
@property(nonatomic, retain)NSString *tmpSelectProvience;//存放当前选中的城市

@end

@implementation CityChooseView

- (void)dealloc{
    
    self.leftTableView = nil;
    self.rightTableView = nil;
    self.curIndexPath = nil;
    self.resultTableView = nil;
    self.tmpSelectProvience = nil;
    
    [super dealloc];
}

-(void)showView{
    
    _provinceAndCity = [ProvincesAndCitysControl shareInstance];
    self.curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self showButtonList:@"Buttons" index:1];
    [self showUIViewList:@"UIViews" index:1];
    [self showUILabelList:@"UILabel" index:0];
    [self initTableView];
    
    [super showView];
    self.backgroundColor = [UIColor whiteColor];
    [self showButtonList:@"Buttons" index:0];
    UIView *bgView = [self viewWithTag:511];
    UIButton *button = (UIButton *)[self viewWithTag:111];
    [bgView insertSubview:button belowSubview:[self viewWithTag:611]];
    
    button = (UIButton *)[self viewWithTag:211];
    button.userInteractionEnabled = NO;//关闭按钮的交互
    
    UIImageView *arrowView = (UIImageView *)[[self viewWithTag:511] viewWithTag:521];
    arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    
    //设置label上的文字
     UILabel *label = (UILabel *)[self viewWithTag:721];
    label.text = @"正在定位...";
    [self performSelector:@selector(updateAction) withObject:nil afterDelay:1.5];
}

#pragma mark updateAction--更新位置信息
- (void)updateAction{
    
    EBLog(@"updateLocation");
    UILabel *label = (UILabel *)[self viewWithTag:721];
    if (![LhLocationModel shareLocationModel].isLocationError) {
        label.text = @"定位失败";
    }else{
    
        label.text = [NSString stringWithFormat:@"%@ %@",[LhLocationModel shareLocationModel].provience,[LhLocationModel shareLocationModel].city];
        [self showCurrentProvince:[LhLocationModel shareLocationModel].selectedProvince city:([[LhLocationModel shareLocationModel].selectedCity isEqualToString:[LhLocationModel shareLocationModel].selectedProvince])?@"本省":[LhLocationModel shareLocationModel].selectedCity];
    }
    
}
#pragma mark 定位表示图显示到省份城市
- (void)showCurrentProvince:(NSString *)province city:(NSString *)city{
    
    //先显示出省份
    [self tableView:_leftTableView showCellWithCellTitle:province delay:0.002];
    //西安市城市
    [Utility delay:0.002 action:^{
        [self tableView:_rightTableView showCellWithCellTitle:city delay:0.002];
    }];
}
- (void)tableView:(UITableView *)tableView showCellWithCellTitle:(NSString *)text delay:(float)delay{
    
    NSIndexPath *indexPath = [tableView getTableViewWithtextLabelText:text type:1];
    if (indexPath == nil) {
        return;
    }
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark 左右表示图的初始化
- (void)initTableView{
    
    //left表示图的frame
    
    CGRect rect = CGRectMake( 0, 128.5, 100, CGRectGetHeight(self.frame) - 128.5);
    
    self.leftTableView = [[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain] autorelease];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.scrollEnabled = NO;
    _leftTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_leftTableView];
    [self.viewArray addObject:_leftTableView];
    
    //right tableView frame
    rect = CGRectMake( 101, 128.5, 320 - 101, CGRectGetHeight(self.frame) - 128.5);
    self.rightTableView = [[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain] autorelease];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_rightTableView];
    [self.viewArray addObject:_rightTableView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [super textFieldShouldReturn:textField];
    
    return YES;
}


-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}

#pragma mark- 重新定位
- (void)mapBtnClicked:(UIButton *)button{
    
    //获取当前位置
    [self updateAction];
}

#pragma mark- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([tableView isEqual:_leftTableView]) {
        return [_provinceAndCity.provinceArray count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:_leftTableView]) {
        return [[[_provinceAndCity.provinceArray objectAtIndex:section] objectForKey:[[[_provinceAndCity.provinceArray objectAtIndex:section] allKeys] objectAtIndex:0]] count];
        return 1;
    }else if ([tableView isEqual:_rightTableView]){//右侧表示图
        
        ProvinceModel *model = [[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] objectForKey:[[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] allKeys] objectAtIndex:0]] objectAtIndex:_curIndexPath.row];
        return model.cityArray.count;
    }else{//结果展示视图
        
        EBLog(@"---%@---",_resultArray);
        return _resultArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        
        static NSString *cellIndentifer = @"leftCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] init] autorelease];
        }
        // Configure the cell...
        ProvinceModel *model = [[[_provinceAndCity.provinceArray objectAtIndex:indexPath.section] objectForKey:[[[_provinceAndCity.provinceArray objectAtIndex:indexPath.section] allKeys] objectAtIndex:0]] objectAtIndex:indexPath.row];
        cell.textLabel.text = model.string;
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        if (indexPath.section == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
    }
    else if([tableView isEqual:_rightTableView]){
        
        static NSString *cellIndentifer = @"rightCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] init] autorelease];
        }
        // Configure the cell...
        ProvinceModel *model = [[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] objectForKey:[[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] allKeys] objectAtIndex:0]] objectAtIndex:_curIndexPath.row];
       CityModel *cityModel = [model.cityArray objectAtIndex:indexPath.row];

        cell.textLabel.text = cityModel.string;
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        if (indexPath.section == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
    }else{
        
        static NSString *cellIndentifer = @"resultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] init] autorelease];
        }
        // Configure the cell...
        CityModel *cityModel = [_resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cityModel.string;
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        if (indexPath.section == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:_leftTableView]) {
        return [[[_provinceAndCity.provinceArray objectAtIndex:section] allKeys] objectAtIndex:0];
    }
    return nil;
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_leftTableView]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_curIndexPath.row == indexPath.row
            && _curIndexPath.section == indexPath.section) {
            
            return;
        }
        self.tmpSelectProvience = cell.textLabel.text;
        self.curIndexPath = indexPath;
        [_rightTableView reloadData];
        
    }else if ([tableView isEqual:self.resultTableView]){
        
        CityModel *model = [_resultArray objectAtIndex:indexPath.row];
        [self showCurrentProvince:model.provience city:model.string];
        
    }else if([tableView isEqual:_rightTableView]){//右侧表示图cell选中
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
// 城市发生改变
        if (![cell.textLabel.text isEqualToString:[LhLocationModel shareLocationModel].selectedCity]){
            
            ProvinceModel *model = [[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] objectForKey:[[[_provinceAndCity.provinceArray objectAtIndex:_curIndexPath.section] allKeys] objectAtIndex:0]] objectAtIndex:_curIndexPath.row];
            CityModel *cityModel = [model.cityArray objectAtIndex:indexPath.row];
            
            [LhLocationModel shareLocationModel].selectedProvince = cityModel.provience;
            if ([cityModel.string isEqualToString:@"本省"]) {
                
                [LhLocationModel shareLocationModel].selectedCity = cityModel.provience;
            }else{
              
                [LhLocationModel shareLocationModel].selectedCity = cityModel.string;
            }
            [LhLocationModel shareLocationModel].selectedCityCode = cityModel.cityCode;
            [ObserversNotice TellViewNotice:YGLYNoticeTypeLocationDidChange];
            [self backClicked:nil];
        }
        
    }
}

-(void)removeFromSuperview{
    
    [NstimerModel removeObejct:self];
    self.rightTableView.delegate = nil;
    self.leftTableView.delegate = nil;
    [super removeFromSuperview];
}

#pragma mark search 搜索的时候会用到
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //当文本编辑的时候调用
    if ([self.controller.view.subviews containsObject:self.maskView] && ![self.maskView.subviews containsObject:self.resultTableView]) {
        
        self.resultTableView.frame = self.maskView.bounds;
        self.resultTableView.delegate = self;
        self.resultTableView.dataSource = self;
        [self.maskView addSubview:self.resultTableView];
    }
    
    if (searchText.length <= 0) {
        return;
    }
    self.resultArray = [_provinceAndCity searchByCityName:searchText type:3];
    
    [self.resultTableView reloadData];
    
}
@end
