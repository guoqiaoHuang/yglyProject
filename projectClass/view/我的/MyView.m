#import "MyView.h"
#import "GLIRViewController.h"
#import "Utility.h"
#import "LoginView.h"
#import "ScanQrCodeUIImageView.h"
#import "AppKeFuLib.h"
#import "GlobalModel.h"
#import "LhSelfKeyboard.h"
#import "XCDSView.h"
#import "UtilityExt.h"
#import "LhNoticeMsg.h"
#import "FindPassword.h"
#import "ResetPassword.h"
#import "FavouriteView.h"
#import "HBJNSString.h"
static  GLIRViewController*waterPlay = nil;
@implementation MyView


-(void)SevenSwitchClicked:(SevenSwitch*)sender{
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1"
                                                  forKey:@"yglyProjectwifi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0"
                                                  forKey:@"yglyProjectwifi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
-(id)initWithFrame:(CGRect)frame{
    [super initWithFrame: frame];
    
    return self;
}
-(void)createAni{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.8];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.4];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.2];
    animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2.3f;
    [animationGroup setAnimations:[NSArray arrayWithObjects: opacityAnimation,scaleAnimation, nil]];
    [animationGroup retain];

}
-(void)createLayer{
    CGRect rect =CGRectMake(photo.point.x , photo.point.y,photo.size.width, photo.size.height);
    waveLaye1=[CALayer layer];
    waveLaye1.frame = rect;
    [self.layer addSublayer:waveLaye1];
    
    waveLaye2=[CALayer layer];
    waveLaye2.frame = rect;
    [self.layer addSublayer:waveLaye2];
    
    waveLaye3=[CALayer layer];
    waveLaye3.frame = rect;
    [self.layer addSublayer:waveLaye3];
    
}
-(void)showView{
    [super showView];
    self.backgroundColor = [UIColor whiteColor];
    waterPlay.view.frame = CGRectMake(0, 0, self.frame.size.width+2, 240-50);
    [self addSubview:waterPlay.view];
    photo = (DownloadUIButton*)[DownloadUIButton Create:[[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"avatar"] defauleImage:@"头像默认.png"];
    photo.point = [ProjectPositionTransformation getMyViewPhotoPos];
    [photo addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [photo.layer setCornerRadius: (photo.size.height/2)];
    [photo.layer setMasksToBounds:YES];
    photo.layer.borderWidth = 3.0f;
    photo.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self createAni];
    [self createLayer];
    [self addSubview:photo];
    
    rippleEffect= [[Utility CATransitionEffect:photo Function:kCAMediaTimingFunctionEaseIn Duration:1.0 Type:@"rippleEffect" Subtype:kCATransitionFade]retain];;
    [self performSelector:@selector(pohotoAni) withObject:nil afterDelay:0.6];
    
    [self showUILabelList:@"UILabel" index:1 uiview:self];
    [self showUITextFieldList:@"TextField" index:0];
    
    UIView*tView  =  [self viewWithTag:90612];
    UITextField*textField = (UITextField*)[self viewWithTag:90611];
    textField.backgroundColor = [UIColor clearColor];
    if ([GlobalModel isLogin]) {
        textField.text = [[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"nickname"];
        textField.hidden = NO;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = [Utility hexStringToColor:@"#DDA0DD"];
        tView.hidden = YES;
    }else{
        tView.hidden = NO;
        textField.hidden = YES;
    }
    [self showColorButtonList:@"ColorButtons" index:0 uiview:self];
    lspt=[[[UIScrollView alloc]initWithFrame: CGRectMake(0, waterPlay.view.frame.origin.y+waterPlay.view.frame.size.height, self.frame.size.width, self.frame.size.height)]autorelease];
    lspt.backgroundColor =  [UIColor clearColor];
    lspt.contentSize=(CGSize){self.size.width,self.frame.size.height*1.2};
    [lspt setShowsHorizontalScrollIndicator:NO];
    [lspt setShowsVerticalScrollIndicator:NO];
    [self addSubview:lspt];
    [self.viewArray addObject:lspt];
    [self showUILabelList:@"UILabel" index:2 uiview:lspt];
    [self showColorButtonList:@"ColorButtons" index:1 uiview:lspt];
    [self ShowImageViewList:@"UImageViews" index:0 uiview:lspt];
    [self showUIViewList:@"UIViews" index:0 uiview:lspt];
    
    [self showSevenSwitchList:@"SevenSwitch" index:0 uiview:lspt];
    
    [self updateButonState:[GlobalModel isLogin]];
    SevenSwitch*sn = (SevenSwitch*)[lspt viewWithTag:889801];
    
    NSString*wifi =  [[NSUserDefaults standardUserDefaults] objectForKey:@"yglyProjectwifi"];
    
    if (!wifi || [wifi isEqualToString:@"0"]) {
        sn.on = NO;
    }else{
        sn.on = YES;
    }
    
    [self isLogin];
    [self initToolBar];
    
}

-(void)isLogin{
    UIView*t1 = [self viewWithTag:99001];
    t1.hidden =[GlobalModel isLogin];
    UIView*t2 = [self viewWithTag:99002];
    t2.hidden = ![GlobalModel isLogin];
}
+(void)statWater:(NSString*)name{
    if (!waterPlay) {
        waterPlay = [[GLIRViewController alloc] init:name];
    }
    
}


-(CATransition*)getReplace{
    return nil;
}
-(void)dealloc{
    if (waterPlay) {
        [waterPlay.view removeFromSuperview];
        [waterPlay cleanRipple];
    }
    if (animationGroup) {
        [animationGroup release];
    }
    [super dealloc];
}

#pragma mark 注销/登陆
-(void)logoutClicked:(UIButton*)sender{
    [[GlobalModel sharedGameModel]userLogout];
}
-(void)loginClicked:(UIButton*)sender{
    LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
    t.controller = self.controller;
    [t.controller push:t atindex:6];
}
-(void)btnClicked:(UIButton*)sender{
    
    UITextField*textField = (UITextField*)[self viewWithTag:90611];
    [textField resignFirstResponder];
    
    if (sender.tag == 1) {//我的收藏
        
        if (![GlobalModel isLogin]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"未登录。请您请登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            alert.tag = -9988;
            [alert show];
            [alert release];
        }else{
            FavouriteView *t = [[[FavouriteView alloc]initWithFrame:self.frame] autorelease];
            t.controller = self.controller;
            [self.controller push:t atindex:6];
        }
    }else if(sender.tag == 99001){//找回密码
        FindPassword *t = [[[FindPassword alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }else if(sender.tag == 99002){//密码重置
        ResetPassword *t = [[[ResetPassword alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [self.controller push:t atindex:6];
    }else if(sender.tag == 4){//清除缓存
        NSString *documentPath = [Utility GetCachePath:YangGuangDownloadPath];
        float size = [self folderSizeAtPath:documentPath];
        [Utility alertMsg:@"提示" msg:[NSString stringWithFormat:@"已清除%.2fM缓存文件",size]];
    }else if(sender.tag == 5){
        aletView = [AlerView createAlerView:CGRectMake(0, 0, 290, 352.5) delegate:self plist:@"意见反馈.plist"];
        textF = (UITextView *)[aletView viewWithTag:1611];
        textF.backgroundColor = [UIColor whiteColor];
        textF.returnKeyType = UIReturnKeyDone;
        textF.delegate = self;
        [self.controller addAlertView:aletView type:0];
    }

   
}



-(void)closeBtnClicked:(id)sender{
    [self.controller handleSingleTap:nil];
}
-(void)confirmBookingClicked:(id)sender{
    if (textF.text.length > 3) {
        [[GlobalModel sharedGameModel]appYjfk:[textF.text copy] delegate:nil];
    }
    [textF resignFirstResponder];
    [self closeBtnClicked:nil];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"意见提交成功"];
}


///计算缓存文件的大小的M
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    long long size = 0;
    if ([manager fileExistsAtPath:filePath]){
        size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        [manager removeItemAtPath:filePath error:nil];
    }
    return size;
}

- (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -9988 && buttonIndex == 1) {
        LoginView*t = [[[LoginView alloc]initWithFrame:self.frame] autorelease];
        t.controller = self.controller;
        [t.controller push:t atindex:6];
    }
}

#pragma mark 头像点击
-(void)photoClick:(UIButton*)sender{
    if (![GlobalModel isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未登录。请您请登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = -9988;
        [alert show];
        return;
    }
   [self performSelector:@selector(popChooseProfilePhoto) withObject:nil];
}


//弹出 选择宝宝 头像
-(void)popChooseProfilePhoto
{
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc]init]autorelease];
    [imagePicker setNavigationBarHidden:YES];
    imagePicker.navigationBar.hidden = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    imagePicker.allowsEditing = YES;
    imagePicker.toolbarHidden = YES;
    imagePicker.delegate = self;
    [self.controller presentViewController:imagePicker animated:YES completion:nil];
    
}
//选择照片回调
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [photo setImage:image];
        [self performSelector:@selector(changeAvatar) withObject:nil];
    }
    
}

-(void)changeAvatar{
    NSString *avatarPath = [Utility GetCachePath:YangGuangDownloadPath];
    avatarPath = [avatarPath stringByAppendingString:AvactorImage];
    [UIImageJPEGRepresentation(photo.imageView.image,1.0) writeToFile:avatarPath atomically:YES];
    [self showLoadMsg:@"头像保存中..."];
    [[GlobalModel sharedGameModel]accountManageAvatar:avatarPath delegate:self];
    EBLog(@"avatarPath:%@",avatarPath);
}

-(void)getSuccesFinished:(NSString*)apiKey{
    if ([apiKey isEqualToString:app_account_manage_avatar]) {
        [self dismissLoadMsg];
        NSString *avatarPath = [Utility GetCachePath:YangGuangDownloadPath];
        avatarPath = [avatarPath stringByAppendingString:AvactorImage];
        NSString*avatarurl = [[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"avatar"];
        NSString*turl = [Utility hdGetFullUrl :avatarurl];
        NSString *path = [Utility getUrlPath:turl];
        if([[NSFileManager defaultManager] fileExistsAtPath:avatarPath]){
            [[NSFileManager defaultManager] moveItemAtPath:avatarPath toPath:path  error:nil];
        }
        [[LhNoticeMsg sharedInstance]ShowMsg:@"头像保存成功"];
    }
   

}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey;{
    if ([apiKey isEqualToString:app_account_manage_avatar]) {
        [self dismissLoadMsg];
        [[LhNoticeMsg sharedInstance]ShowMsg:@"头像保存失败"];
        photo = (DownloadUIButton*)[DownloadUIButton Create:[[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"avatar"] defauleImage:@"头像默认.png"];
    }
}


#pragma mark 头像不定时水滴特效
-(void)pohotoAni{
    [self scaleBegin:waveLaye1];
    [photo.layer addAnimation:rippleEffect forKey:@"animation"];
    [self performSelector:@selector(pohotoAni) withObject:nil afterDelay:7];
    [self performSelector:@selector(setWavLayer2) withObject:nil afterDelay:0.8];
}

-(void)setWavLayer2{
    [self scaleBegin:waveLaye2];
    [self performSelector:@selector(setWavLayer3) withObject:nil afterDelay:0.8];
}

-(void)setWavLayer3{
    [self scaleBegin:waveLaye3];
}
-(void)scaleBegin:(CALayer *)aLayer{
    aLayer.borderColor = [[UIColor whiteColor]CGColor];
    aLayer.borderWidth =1.2;
    aLayer.cornerRadius =aLayer.frame.size.width*0.5;
    [aLayer addAnimation:animationGroup forKey:@"animationGroup"];
    
}

-(void)removeFromSuperview{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [rippleEffect release];
    rippleEffect = nil;
    [animationGroup release];
    animationGroup = nil;
    [super removeFromSuperview];
}

#pragma mark 事件回调通知
-(void)receiveNotifications:(NSInteger)type{
    if (type == YGLYNoticeTypeLogoutSuccess) {
        [photo setImage:[Utility getImageByName:@"头像默认.png"]];
        [self updateButonState:NO];
    }else if(type == YGLYNoticeTypeLoginSuccess){
        [photo setNewUrl:[[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"avatar"] defauleImage:@"头像默认.png"];
        [self updateButonState:YES];
    }
    [self isLogin];
    UIView*tView  =  [self viewWithTag:90612];
    UITextField*textField = (UITextField*)[self viewWithTag:90611];
    textField.backgroundColor = [UIColor clearColor];
    if ([GlobalModel isLogin]) {
        textField.text = [[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"nickname"];
        textField.hidden = NO;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = [Utility hexStringToColor:@"#DDA0DD"];
        tView.hidden = YES;
    }else{
        tView.hidden = NO;
        textField.hidden = YES;
    }

}
-(void)updateButonState:(BOOL)flag{
    UIView*t = [self viewWithTag:99802];
    t.hidden = !flag;
    t = [self viewWithTag:99801];
    t.hidden = flag;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
        textField.text =  [textField.text deleteWhiteSpaceBothEnds];
        if (textField.text .length <= 1) {
            return NO;
        }else if([textField.text isEqualToString:[[GlobalModel sharedGameModel].selfUserProfile objectForKey:@"nickname"]]){
            return NO;
        }
        [[GlobalModel sharedGameModel] accountManageInfo:textField.text info:nil delegate:self];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if([textField.text length] != 0){ //点击了非删除键
        
        NSString *newtxt = textField.text;
        if(([newtxt length]+[string length]) > 15){
            textField.text = [newtxt substringToIndex:15-1];
            return NO;
        }
    }
    return YES;
}


- (void)initToolBar{
    UIToolbar*toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)]autorelease];
    
    //左侧空白按钮
    UIBarButtonItem *spaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //完成按钮
    UIBarButtonItem *completeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doComplete)];
    
    toolbar.items = [NSArray arrayWithObjects:spaceBarButton, completeBarButton, nil];
    [spaceBarButton release];
    [completeBarButton release];
    
    UITextField *textField = (UITextField *)[self viewWithTag:90611];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = toolbar;
}

-(void)doComplete{

    UITextField *textField = (UITextField *)[self viewWithTag:90611];
    [textField resignFirstResponder];

}

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_textView resignFirstResponder];
       
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    NSString *newtxt = _textView.text;
    if(([newtxt length]+[text length]) > 51){
        
        _textView.text = [newtxt substringToIndex:50];
        return NO;
    }
    return YES;
}
@end
