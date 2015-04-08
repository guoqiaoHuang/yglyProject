#import "DownloadUIButton.h"
#import "Utility.h"
#import "UtilityExt.h"
#import "LhUIView.h"
@implementation DownloadUIButton
@synthesize sizeSacle;
@synthesize tmpRequest;
@synthesize tmpNowUrl;
-(void)setImage:(UIImage *)image{
    if (self.tmpRequest) {
        [DownloadModel deleteRequest:self.tmpRequest];
        self.tmpRequest = nil;
    }
    [self setImage:image forState:UIControlStateNormal];
   
}
-(id)init:(UIImage*)image{
    self = [super init];
    if ((self)) {
        self.size = [Utility getSize:image.size];
        self.backgroundColor = [UIColor blackColor];
        [self setImage:image];
       
    }
    return self;
}


+(DownloadUIButton*)Create:(NSString*)url defauleImage:(NSString*)imageName{
    UIImage*image = [Utility getImageByName:imageName];
    DownloadUIButton*view = [[[DownloadUIButton alloc]init:image]autorelease];
    if(!url){
        return view;
    }
    
    NSString*turl = [Utility hdGetFullUrl :url];
    NSString *path = [Utility getUrlPath:turl];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        image = [UIImage imageWithContentsOfFile:path];
        [view setImage:image];
    }else{
        if(url){
            view.tmpRequest = [[DownloadModel sharedDownloadModel]downloadImage:view url:url tag:10 validator:view];
            view.tmpNowUrl = url;
        }
    }
    return view;
}
- (void)didImageDownloaded:(NSString*)path url:(NSString*)url{
    self.tmpRequest = nil;
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    [self setImage:image];
    [self fadeIn];
    
}

-(void)setNewUrl:(NSString*)url{
    [self setNewUrl:url defauleImage:nil];
}

-(void)setNewUrl:(NSString*)url defauleImage:(NSString*)imageName{
    if(imageName){
        UIImage*image = [Utility getImageByName:imageName];//初始化默认下载图片
        self.size = [Utility getSize:image.size];
        [self setImage:image];
    }
    
    if(!url || [url isKindOfClass:[NSNull class]] ||  url.length<=1){//下载链接不存在
        return;
    }
    if ([self.tmpNowUrl isEqualToString:url] && self.tmpRequest) {//下载链接存在与当前对象重复 且没有完成下载
        return;
    }else{//重新构造下载
        self.tmpNowUrl = url;
        NSString*turl = [Utility hdGetFullUrl :url];
        NSString *path = [Utility getUrlPath:turl];
        if([[NSFileManager defaultManager] fileExistsAtPath:path]){
            UIImage*timage = [UIImage imageWithContentsOfFile:path];
            if (timage) {
                [self setImage:timage ];
                return;
            }else {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
        self.tmpRequest = [[DownloadModel sharedDownloadModel]downloadImage:self url:url tag:10 validator:self];
    }

}
-(void)dealloc{
    EBLog(@"dealloc:%@",[self class]);
    self.tmpRequest = nil;
    self.tmpNowUrl = nil;
    [super dealloc];
    
}
-(void)removeFromSuperview{
    [DownloadModel deleteRequest:self.tmpRequest];
    [super removeFromSuperview];
}
@end
