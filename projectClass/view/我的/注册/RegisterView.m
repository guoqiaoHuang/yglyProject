#import "MyView.h"
#import "RegisterView.h"
#import "Utility.h"
#import "DeclareWebVeiw.h"
#import "GlobalModel.h"
#import "LoginView.h"
@interface RegisterView ()<UITextFieldDelegate>

{
    BOOL isAgree;//是否已经同意使用条款。。
}
@property(nonatomic, retain)UIToolbar *toolbar;
@property(nonatomic, assign)CGFloat keyboardHeight;

@end

@implementation RegisterView

- (void)dealloc{
    
    self.toolbar = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [super dealloc];
}

- (void)showView{
    
    [super showView];
    isAgree = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [self showUILabelList:@"UILabel" index:0];
    [self showUITextFieldList:@"TextField" index:0];
    [self showColorButtonList:@"ColorButtons" index:0];
    [self showButtonList:@"Buttons" index:0];
    
    
    [self initToolBar];
    
    
    for (int i = 611; i <= 613; i++) {
        UITextField *textField = (UITextField *)[self viewWithTag:i];
        textField.rightView = [self viewWithTag:112];
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
//点击完成按钮
-(void)doComplete{
    for (int i = 611; i <= 613; i++) {
        UITextField *textField = (UITextField *)[self viewWithTag:i];
        [textField resignFirstResponder];
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
    
    return YES;
}

- (void)clearnTextField:(UIButton *)button{
    
    UITextField *textF = (UITextField *)button.superview;
    textF.text = nil;
}

- (void)gotoDeclaration:(UIButton *)button{
    [Utility openUrl:app_registration_statement controller:self.controller flag:NO];
}

- (void)registerClicked:(UIButton *)button{
   //注册
    if (isAgree) {
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
        
        
        UITextField *codeM = (UITextField*)[self viewWithTag:613];
        [Utility verifyCodeByPhoneNumber:codeM.text result:^(NSInteger state){
            if (1==state) {
                [self showLoadMsg:@"登录中..."];
                [[GlobalModel sharedGameModel] userRegister:phoneNumber.text password:password.text delegate:self];
            }else{
                [Utility alertMsg:@"验证提示" msg:@"短信码验证失败"];
            }
        }];
        
        
    }else{
        [Utility alertMsg:@"提示" msg:@"请同意并勾选协议"];
    }
       
    
}

- (void)agreeClicked:(UIButton *)button{
    isAgree = !isAgree;
    if (isAgree) {
        [button setImage:[UIImage imageNamed:@"注册同意按下.png"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"注册同意默认.png"] forState:UIControlStateNormal];
        
    }



}


#pragma mark 获取push特效
-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}



#pragma mark 注册回调
-(void)getSuccesFinished:(NSString*)apiKey{
    if([apiKey isEqualToString:app_register]){
        [self dismissLoadMsg];
        [self.controller popo];
    }
}

-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    if([apiKey isEqualToString:app_register]){
        [self dismissLoadMsg];
        [Utility alertMsg:@"登录提示" msg:msg];
    }
}

-(void)getCodeClicked:(ACPButton*)sender{
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
    
    
    [Utility sendVerifyCodeByPhoneNumber:phoneNumber.text AndZone:@"86" result:^(NSInteger state) {
        if (1==state) {
            colorBtnCode = sender;
            colorBtnCode.enabled = NO;
            num  = 60;
            if (timer) {
                
                [timer invalidate];timer = nil;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimes) userInfo:nil repeats:YES];
            [[NSRunLoop  currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }else{
            [Utility alertMsg:@"短信提示" msg:@"验证码发送失败"];
        }
    }];

    
    
   
}
-(void)updateTimes{
    num--;
    if (num <= 0) {
        if (timer) {
            [timer invalidate];timer = nil;
            colorBtnCode.enabled = YES;
            return;
        }
    }
    if (colorBtnCode) {
        [colorBtnCode setTitle:[NSString stringWithFormat:@"(%ds)重新获取",num] forState:UIControlStateDisabled];
    }
    
}
-(void)removeFromSuperview{
    if (timer) {
        [timer invalidate];timer = nil;
    }
    [super removeFromSuperview];
}

-(void)loginClicked:(UIButton*)sender{
    LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller replace :t atindex:6];
}
@end
