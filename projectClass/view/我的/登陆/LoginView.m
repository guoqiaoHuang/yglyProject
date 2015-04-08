#import "MyView.h"
#import "LoginView.h"
#import "Utility.h"
#import "GlobalModel.h"
#import "AlerView.h"
#import "RegisterView.h"
@interface LoginView ()<UITextFieldDelegate>

@property(nonatomic, retain)UIToolbar *toolbar;
@property(nonatomic, assign)CGFloat keyboardHeight;

@end

@implementation LoginView

-(void)registerClicked:(UIButton*)sender{
    RegisterView*t = [[[RegisterView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller replace :t atindex:6];
}

- (void)dealloc{
    
    self.toolbar = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    
    return self;
}

- (void)showView{
    
    [super showView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self showUILabelList:@"UILabel" index:0];
    [self showUITextFieldList:@"TextField" index:0];
    [self showColorButtonList:@"ColorButtons" index:0];
    [self showButtonList:@"Buttons" index:0];
    
    [self initToolBar];
    
    
    for (int i = 611; i <= 612; i++) {
        UITextField *textField = (UITextField *)[self viewWithTag:i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.inputAccessoryView = _toolbar;
    }
}

- (void)initToolBar{
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
    
    //左侧空白按钮
    UIBarButtonItem *spaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //完成按钮
    UIBarButtonItem *completeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doComplete)];
    
    _toolbar.items = [NSArray arrayWithObjects:spaceBarButton, completeBarButton, nil];
    [spaceBarButton release];
    [completeBarButton release];
    
}

//点击完成按钮
-(void)doComplete{
 
     UITextField *textField = (UITextField *)[self viewWithTag:611];
    [textField resignFirstResponder];
    textField = (UITextField *)[self viewWithTag:612];
    [textField resignFirstResponder];
    if (alerttextField) {
        [alerttextField resignFirstResponder];
    }

}

#pragma mark 键盘高度获取
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight= keyboardRect.size.height;
    
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (alerttextField) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint point = alertView.point;
            point.y -= YGLY_VIEW_FLOAT(200);
            alertView.point = point;
        } completion:^(BOOL finished) {
            ;
        }];
    }
    return YES;
}

- (void)clearnTextField:(UIButton *)button{
    
    UITextField *textF = (UITextField *)button.superview;
    textF.text = nil;
}

- (void)loginClicked:(UIButton *)button{

    UITextField *phoneNumber = (UITextField*)[self viewWithTag:611];
    if(![Utility checkPhoneNum:phoneNumber.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"无效手机号"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UITextField *password = (UITextField*)[self viewWithTag:612];
    if(password.text.length < minPasswordLength){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码无效"
                                                        message:[NSString stringWithFormat:@"长度小于%d",minUserNameLength]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(password.text.length > maxPasswordLength){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码无效"
                                                        message:[NSString stringWithFormat:@"长度大于于%d",minUserNameLength]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self showLoadMsg:@"登录中..."];

    //测试商户 zh1211 a123456
//   [[GlobalModel sharedGameModel] userLogin:@"zh1211" password:@"a123456" delegate:self];
    //测试用户 huiyuan a123456
    //[[GlobalModel sharedGameModel] userLogin:@"huiyuan" password:@"a123456" delegate:self];
    [[GlobalModel sharedGameModel] userLogin:phoneNumber.text password:password.text delegate:self];

}
#pragma mark 找回密码
- (void)forgetPasswordClicked:(UIButton *)button{
    alertView = [AlerView createAlerView:CGRectMake(0, 0, 290, 222) delegate:self plist:@"密码找回.plist"];
    alerttextField = (UITextField *)[alertView viewWithTag:1611];
    alerttextField.inputAccessoryView = _toolbar;
    alerttextField.delegate = self;
    [self.controller addAlertView:alertView type:0];
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (alerttextField) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint point = alertView.point;
            point.y += YGLY_VIEW_FLOAT(200);
            alertView.point = point;
        } completion:^(BOOL finished) {
            ;
        }];
    }

}
#pragma mark 关闭
-(void)closeBtnClicked:(id)sender{
    if (alerttextField) {
        [alerttextField resignFirstResponder];
        alerttextField = nil;
    }
    [self.controller handleSingleTap:nil];
}
#pragma mark 确定
-(void)btnClicked:(id)sender{
    if (alerttextField) {
        [alerttextField resignFirstResponder];
        alerttextField = nil;
    }
    [self.controller handleSingleTap:nil];
}


-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}


#pragma mark 登陆回调
-(void)getSuccesFinished:(NSString*)apiKey{
    if([apiKey isEqualToString:app_login]){
        [self dismissLoadMsg];
        [self.controller popo];
    }
}

-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    if([apiKey isEqualToString:app_login]){
        [self dismissLoadMsg];
        [Utility alertMsg:@"登录提示" msg:msg];
    }
}
@end
