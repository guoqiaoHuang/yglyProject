#import "BaseUIImageView.h"
#import "DownloadUIButton.h"
#import "AlerView.h"
#import "LhUITextView.h"
@interface MyView : BaseUIImageView<UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView*lspt;
    DownloadUIButton *photo;//头像
    CATransition* rippleEffect;
    
    CAAnimationGroup *animationGroup;
    
    
    CALayer *waveLaye1;
    CALayer *waveLaye2;
    CALayer *waveLaye3;
    UITextView*textF;
    AlerView*aletView;
}
+(void)statWater:(NSString*)name;
@end
