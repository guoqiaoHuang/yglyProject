#import "MyView.h"
#import "FindPassword.h"
#import "Utility.h"
#import "DeclareWebVeiw.h"
#import "GlobalModel.h"
@interface FindPassword ()<UITextFieldDelegate>

{
    BOOL isAgree;//是否已经同意使用条款。。
}
@property(nonatomic, retain)UIToolbar *toolbar;
@property(nonatomic, assign)CGFloat keyboardHeight;

@end

@implementation FindPassword

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



#pragma mark 确定
- (void)btnClicked:(UIButton *)button{
   //注册
    
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
    
    UITextField *password = (UITextField*)[self viewWithTag:614];
    UITextField *password1 = (UITextField*)[self viewWithTag:615];
    
    if(![password.text isEqualToString:password1.text]){
        [Utility alertMsg:@"密码无效" msg:@"密码不一致"];
        return;
    }
    
    if(password.text.length < minPasswordLength){
        [Utility alertMsg:@"密码无效" msg:[NSString stringWithFormat:@"长度小于%d",minUserNameLength]];
        return;
    }
    
    if(password.text.length > maxPasswordLength){
        [Utility alertMsg:@"密码无效" msg:[NSString stringWithFormat:@"长度大于于%d",minUserNameLength]];
        return;
    }
    
    
    UITextField *codeM = (UITextField*)[self viewWithTag:613];
    [Utility verifyCodeByPhoneNumber:codeM.text result:^(NSInteger state){
        if (1==state) {
            [self showLoadMsg:@"修改中..."];
            [[GlobalModel sharedGameModel] publicChecknameAjax:phoneNumber.text delegate:self];
        }else{
            [self dismissLoadMsg];
            [Utility alertMsg:@"验证提示" msg:@"短信码验证失败"];
        }
    }];
    
   
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
    
    if ([apiKey isEqualToString:app_public_checkname_ajax]) {
        [self dismissLoadMsg];
        [Utility alertMsg:@"提示" msg:@"用户名不存在"];
    }else if([apiKey isEqualToString:app_account_manage_password_lost]){
        [self dismissLoadMsg];
        [self.controller popo];
    }
}

-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    if([apiKey isEqualToString:app_public_checkname_ajax] && errNo == -1){//用户名存在
        UITextField *phoneNumber = (UITextField*)[self viewWithTag:611];
        UITextField *password = (UITextField*)[self viewWithTag:614];
        NSString*mt =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSString*mkey =[NSString stringWithFormat:@"375162873%@",mt];
        [[GlobalModel sharedGameModel] accountManagePasswordLost:@{@"tel":phoneNumber.text ,@"mkey":[Utility md5:mkey],@"mt":mt,@"newpassword":password.text}  delegate:self];
    }else{
        [self dismissLoadMsg];
        [Utility alertMsg:@"提示" msg:msg];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
