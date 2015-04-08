//
//  BaseBaseUIImageView.m
//  yglyProject
//
//  Created by 枫 on 14-9-24.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BaseBaseUIImageView.h"
#import "Utility.h"
#import "CityChooseView.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "ObserversNotice.h"
#import "LhLocationModel.h"
#import "SearchView.h"
#import "MapView.h"

@interface BaseBaseUIImageView ()
{
    NSInteger searchBarTag;
}
@property (nonatomic, assign)CGFloat keyboardHeight;
@property (nonatomic, assign)BOOL isMaskViewShow;//判断遮罩是否出现 默认为no

@end

@implementation BaseBaseUIImageView

- (void)dealloc{
    
    self.resultTableView = nil;
    self.maskView = nil;
    
    [super dealloc];
}

-(void)showView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self showUIViewList:@"BaseUIViews" index:0];
    [super showView];
    
    [self.naviView makeInsetShadowWithRadius:3 Color:[UIColor grayColor] Directions:@[@"bottom"]];
    //加载箭头图片
    [self showColorButtonList:@"BaseColorButtons" index:0 uiview:self.naviView];
    
    UIButton *button = (UIButton *)[self viewWithTag:211];
    [button setTitle:[LhLocationModel shareLocationModel].selectedCity?:@"西安" forState:UIControlStateNormal];
    [self ShowImageViewList:@"BaseUIImageView" index:0 uiview:[self viewWithTag:211]];
    
    [self showUISearchBarList:@"BaseUISearchBar" index:0 uiview:self.naviView];
    UISearchBar *searchBar = (UISearchBar *)[self viewWithTag:611];
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = searchBar.frame;
    [button addTarget:self action:@selector(gotoSearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:button];
    
    searchBar.delegate = self;
    searchBarTag = 611;
    
    //searchBar的裁剪，请保证searchBar的默认宽度 44
    [Utility AddRoundedCorners:searchBar rect:[self getSearchFieldFrame] size:15 type:UIRectCornerAllCorners];
    
    [self initMaskView];
    [self initResultTableView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    _isMaskViewShow = NO;
    
}

- (void)initResultTableView{
    
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.naviView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(self.naviView.frame)) style:UITableViewStylePlain];
}


- (void)initMaskView{
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.naviView.frame)+3, CGRectGetWidth(self.frame), 1)];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    //轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMask)];
    tap.cancelsTouchesInView = NO;
    [_maskView addGestureRecognizer:tap];
    [tap release];
    
    //托拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMask:)];
    pan.cancelsTouchesInView = NO;
    [_maskView addGestureRecognizer:pan];
    [pan release];
    
}

#pragma mark -获取searchBar textField的frame
- (CGRect)getSearchFieldFrame{
    
    UISearchBar *searchBar = (UISearchBar *)[self viewWithTag:611];
    
    CGFloat width = CGRectGetWidth(searchBar.frame);
    CGFloat heigh = CGRectGetHeight(searchBar.frame);
    
    CGRect rect = searchBar.frame;
    rect.origin.x = 8;
    rect.origin.y = 7;
    rect.size.width = width - 16;
    rect.size.height = heigh - 14;
    
    return rect;
}

#pragma mark -搜索条变成第一响应动画
-(void)searchFieldBecomeFirstResponseAnimation{
    
    UISearchBar *searchBar = (UISearchBar *)[self viewWithTag:searchBarTag];
    
    if (![searchBar isFirstResponder]) {
        
        [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect rect = searchBar.frame;
            rect.size.width += 107.0f;
            searchBar.frame = rect;

            [Utility AddRoundedCorners:searchBar rect:[self getSearchFieldFrame] size:15 type:UIRectCornerAllCorners];
            
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

#pragma mark -搜索条回归正常动画
-(void)searchFieldNormalAnimation{
    
   UISearchBar *searchBar = (UISearchBar *)[self viewWithTag:searchBarTag];
    
    if ([searchBar isFirstResponder]) {//判断是否已经是第一响应
        
        [searchBar resignFirstResponder];
        [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect rect = searchBar.frame;
            rect.size.width -= 107.0f;
            searchBar.frame = rect;
            
            [Utility AddRoundedCorners:searchBar rect:[self getSearchFieldFrame] size:15 type:UIRectCornerAllCorners];
            
        } completion:^(BOOL finished) {
            
            ;
        }];
    }
}

#pragma mark -遮罩回归正常动画
- (void)maskViewNormalAnimation{
    
    if ([self.controller.view.subviews containsObject:_maskView]) {
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect rect = _maskView.frame;
            rect.size.height = 1;
            _maskView.frame = rect;
            
        } completion:^(BOOL finished) {
            
            [_maskView removeFromSuperview] ;
        }];
    }
}

#pragma mark -遮罩变成第一响应动画
- (void)maskViewBecomeFirstResponseAnimation{
    
    if (![self.controller.view.subviews containsObject:_maskView]) {
        
        [self.controller.view addSubview:_maskView];
    }
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect rect = _maskView.frame;
        rect.size.height = CGRectGetHeight(self.frame) - CGRectGetHeight(self.naviView.frame);
        _maskView.frame = rect;
        
    } completion:^(BOOL finished) {
        
        ;
    }];
}

#pragma mark - searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self searchFieldBecomeFirstResponseAnimation];
    if (!_isMaskViewShow) {
        
        [self maskViewBecomeFirstResponseAnimation];
    }
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _isMaskViewShow = NO;
    [self searchFieldNormalAnimation];
    if (!_isMaskViewShow) {
        
        [self maskViewNormalAnimation];
    }
    
}

#pragma mark 键盘高度获取
//当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification{
//    //获取键盘的高度
////    NSDictionary *userInfo = [aNotification userInfo];
////    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
////    NSNumber *bValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
////    UIViewAnimationCurve cValue = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
////    CGRect keyboardRect = [aValue CGRectValue];
//    //_keyboardHeight= keyboardRect.size.height;
//    
//    if (!_isMaskViewShow) {
//        
//        [self maskViewBecomeFirstResponseAnimation];
//    }
//    
//    
//}
//- (void)keyboardWillHide:(NSNotification *)aNotification{
//    
//    if (!_isMaskViewShow) {
//         
//        [self maskViewNormalAnimation];
//    }
//}


- (void)hiddenKeyBoard{
    
    _isMaskViewShow = NO;
    [self searchFieldNormalAnimation];
    [self maskViewNormalAnimation];
    
}

- (void)hideMask{
    
    _isMaskViewShow = NO;
    [self searchFieldNormalAnimation];
    [self maskViewNormalAnimation];
}
- (void)dragMask:(UIPanGestureRecognizer *)pan{
    
    _isMaskViewShow = YES;
    [self searchFieldNormalAnimation];
}

- (void)backClicked:(id)sender{//视图返回的时候
    
    [_maskView removeFromSuperview];
    [super backClicked:sender];
}

#pragma mark -顶部三个按钮对应的功能
-(void)cityChooseClicked:(UIButton *)button
{
    [self hiddenKeyBoard];
    CityChooseView *t = [[[CityChooseView alloc] initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:6];
}

- (void)loginClicked:(UIButton *)button{
    
    [self hiddenKeyBoard];
    LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}

-(void)registerClicked:(id)sender{
    
    [self hiddenKeyBoard];
    RegisterView *t = [[[RegisterView alloc] initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [self.controller push:t atindex:10];
}

#pragma mark-改变当前城市
#pragma mark 接收通知id
-(void)removeFromSuperview{
    
    [ObserversNotice removeView:self];
    [super removeFromSuperview];
}
-(void)receiveNotifications:(NSInteger)type{
 
    if (type == YGLYNoticeTypeLocationDidChange) {
        
        //改变当前的城市名称
        UIButton *button = (UIButton *)[self viewWithTag:211];
        [button setTitle:[LhLocationModel shareLocationModel].selectedCity forState:UIControlStateNormal];
    }
}
#pragma mark- 进入搜索页面
-(void)gotoSearchView{
    
    SearchView *t = [[[SearchView alloc] initWithFrame:self.frame] autorelease];
    t.searchDict = [self getSearchDict];
    t.controller = self.controller;
    [self.controller push:t atindex:10];
}
#pragma mark 搜索添加返回数据key
-(NSDictionary*)getSearchDict{
    return nil;
}
#pragma mark- 进入地图
-(void)gotoMapBtn:(UIButton *)sender{
    
    MapView*t = [[[MapView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}
@end
