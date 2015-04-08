#import "MyView.h"
#import "ResetPassword.h"
#import "Utility.h"
#import "DeclareWebVeiw.h"
#import "GlobalModel.h"
#import "LoginView.h"
@implementation ResetPassword

- (void)showView{
    
    [super showView];
    self.backgroundColor = [UIColor whiteColor];
    [self showUILabelList:@"UILabel" index:0];
    [self showUITextFieldList:@"TextField" index:0];
    [self showColorButtonList:@"ColorButtons" index:0];
}



#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [t.controller push:t atindex:6];
    }
}

- (void)btnClicked:(UIButton *)button{
    if(![GlobalModel isLogin]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        return;

    }
    UITextField *pa = (UITextField*)[self viewWithTag:611];
    if(pa.text.length < minPasswordLength || pa.text.length>maxPasswordLength){
        [Utility alertMsg:@"提示" msg:@"老密码无效"];
        return;
    }
    
    UITextField *password = (UITextField*)[self viewWithTag:612];
    UITextField *password1 = (UITextField*)[self viewWithTag:613];
    if(![password.text isEqualToString:password1.text]){
        [Utility alertMsg:@"密码无效" msg:@"密码不一致"];
        return;
    }
    
    if(password.text.length < minPasswordLength){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新密码无效"
                                                        message:[NSString stringWithFormat:@"长度小于%d",minUserNameLength]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(password.text.length > maxPasswordLength){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新密码无效"
                                                        message:[NSString stringWithFormat:@"长度大于于%d",minUserNameLength]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //密码重置
    [[GlobalModel sharedGameModel] accountManagePassword:@{@"password":pa.text ,@"newpassword":password.text} delegate:self];
    [self showLoadMsg:@"修改中"];
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
    if([apiKey isEqualToString:app_account_manage_password]){
        [self dismissLoadMsg];
        [self.controller popo];
    }
}

-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    if([apiKey isEqualToString:app_account_manage_password]){
        [self dismissLoadMsg];
        [Utility alertMsg:@"提示" msg:msg];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
@end
