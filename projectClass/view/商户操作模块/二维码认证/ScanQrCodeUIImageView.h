#import "BackTitleUIImageView.h"
@interface ScanQrCodeUIImageView : BackTitleUIImageView<UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CGRect rect;
    CGRect scanCropRect;
    UIImageView * line;

}
@property (nonatomic,copy)NSString * tmpValue;
@property (retain,nonatomic)AVCaptureDevice * device;
@property (retain,nonatomic)AVCaptureDeviceInput * input;
@property (retain,nonatomic)AVCaptureMetadataOutput * output;
@property (retain,nonatomic)AVCaptureSession * session;
@property (retain,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end
