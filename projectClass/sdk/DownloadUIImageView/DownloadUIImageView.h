#import <UIKit/UIKit.h>
#import "DownloadModel.h"
@interface DownloadUIImageView : UIView{
    UIImageView*bgImage;
}
@property(nonatomic,copy) NSString* tmpNowUrl;
@property(nonatomic,assign) float sizeSacle;
@property(nonatomic,retain) ASIHTTPRequest*tmpRequest;
+(UIImageView*)Create:(NSString*)url defauleImage:(NSString*)imageName;
-(void)setImage:(UIImage *)timage;
-(void)setNewUrl:(NSString*)url;
-(void)setNewUrl:(NSString*)url defauleImage:(NSString*)imageName;
@end
