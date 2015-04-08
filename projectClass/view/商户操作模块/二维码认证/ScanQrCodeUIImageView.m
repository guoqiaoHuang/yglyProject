#import "ScanQrCodeUIImageView.h"
#import "Utility.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"

@interface ScanQrCodeUIImageView ()<VIewDadaGetDelegate>

@end
@implementation ScanQrCodeUIImageView

-(void)getSuccesFinished:(NSString*)apiKey dict:(NSDictionary*)dict{
    
    if ([apiKey isEqualToString:app_dingdan_shanghu_yanzheng]) {
        
        [self dismissLoadMsg];
        [[LhNoticeMsg sharedInstance] ShowMsg:@"验证成功"];
        
        [Utility delay:0.5 action:^{
            self.tmpValue = nil;
            [self.session startRunning];
            if (!timer) {
                timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
            }
        }];
    }
}
-(void)getErrorFinished:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)apiKey{
    
    [self dismissLoadMsg];
    [[LhNoticeMsg sharedInstance] ShowMsg:@"验证失败"];
    
    [Utility delay:0.5 action:^{
         self.tmpValue = nil;
        [self.session startRunning];
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        }
    }];
}

-(void)showView{
    rect = CGRectMake(0.25, 0.25, 1, 0.8);
    scanCropRect = CGRectMake(0, 50, rect.size.width*self.size.width, rect.size.height*self.size.height);
    if([Utility getSystemVersion] >= 7.0){
        if(SIMULATOR){
            [Utility alertMsg:@"运行错误" msg:@"模拟器不支持"];
        }else{
            [self setupCamera];
        }
        
       
    }else{
        [Utility alertMsg:@"ios版本问题" msg:@"不支持ios7以下"];
    }
    [super showView];
    
}

-(void)dealloc{
    self.device = nil;
    self.input = nil;
    self.output = nil;
    self.session = nil;
    self.preview = nil;
    [super dealloc];
}

- (void)setupCamera
{
    // Device
    
    self.session = [[[AVCaptureSession alloc]init]autorelease];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (self.input) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    // Output
    self.output = [[[AVCaptureMetadataOutput alloc]init]autorelease];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    [self.session addOutput:self.output];
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame =scanCropRect;
    [self.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
    
    UIImage*image = [Utility getImageByName:@"pick_bg@2x.png"];
    UIImageView*imageView = [[[UIImageView alloc] initWithImage:image ] autorelease];
    imageView.center = self.center;
    imageView.point = CGPointMake(0, 20);
    [self addSubview:imageView];
    image = [Utility getImageByName:@"line@2x.png"];
    line = [[[UIImageView alloc] initWithImage:image ] autorelease];
    line.point = CGPointMake(46, 95);
    [imageView addSubview:line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    

}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    EBLog(@"callback 二维码");
    NSString *stringValue;
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if ([self.tmpValue isEqualToString:stringValue]) {
            [self.session stopRunning];
            return;
        }else{
            self.tmpValue = metadataObject.stringValue;
            if(timer){
                [timer invalidate];
                timer = nil;
            }
            [self.session stopRunning];
        }
        [self playSound:@"qrcode_sound.wav"];
       // [Utility alertMsg:@"二维码" msg: self.tmpValue];
        [[VIewDadaGet sharedGameModel] DingDanForYanZheng:self.tmpValue type:1 delegate:self];
        [self showLoadMsg:@"正在验证..."];
    }
    
    
}


-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        line.point = CGPointMake(line.point.x, 90+num);
        if (num == 220) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        line.point = CGPointMake(line.point.x, 90+num);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)removeFromSuperview{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    self.tmpValue = nil;
    [super removeFromSuperview];
}
-(CATransition*)getReplace{
    
    return  nil;
}

-(CATransition*)getPush{
    return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseIn Duration:0.6 Type:kCATransitionMoveIn Subtype:kCATransitionFromTop];
}
#pragma mark 获取popo特效
-(CATransition*)getPopo{
     return  [Utility CATransitionEffect:self Function:kCAMediaTimingFunctionEaseOut Duration:0.6 Type:kCATransitionReveal Subtype:kCATransitionFromBottom];
}

@end
