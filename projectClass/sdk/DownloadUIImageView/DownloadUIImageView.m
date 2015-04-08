#import "DownloadUIImageView.h"
#import "Utility.h"
#import "UtilityExt.h"
#import "LhUIView.h"
@implementation DownloadUIImageView
@synthesize sizeSacle;
@synthesize tmpRequest;
@synthesize tmpNowUrl;
-(void)setImage:(UIImage *)image{
    if (self.tmpRequest) {
        [DownloadModel deleteRequest:self.tmpRequest];
        self.tmpRequest = nil;
    }
    bgImage.image = image;
    bgImage.size = image.size;
    float sw = self.size.width;
    float sh = self.size.height;
    float iw = bgImage.size.width;
    float ih = bgImage.size.height;
    if (sh/ih > sw/iw) {
        if(sh/ih <= 1.0){
            bgImage.size = CGSizeMake(iw*sh/ih,sh);
            bgImage.point = CGPointMake(-0.5*(bgImage.size.width-self.size.width), 0);
        }else{
            bgImage.size = CGSizeMake(sw,ih*sw/iw);
            bgImage.point = CGPointMake(0, -0.5*(bgImage.size.height-self.size.height));
        }
        
    }else{
        if(sw/iw <= 1.0){
            bgImage.size = CGSizeMake(sw,ih*sw/iw);
            bgImage.point = CGPointMake( 0,-0.5*(bgImage.size.height-self.size.height));
        }else{
            bgImage.size = CGSizeMake(iw*sh/ih,sh);
            bgImage.point = CGPointMake( -0.5*(bgImage.size.width-self.size.width),0);
        }
        
    }
}

#pragma mark- setFrame
-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    bgImage.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    bgImage.clipsToBounds = YES;
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.frame = self.bounds;
}

-(id)init:(UIImage*)image{
    self = [super init];
    if ((self)) {
        bgImage = [[[UIImageView alloc] initWithImage:image ] autorelease];
        self.size = [Utility getSize:image.size];
        bgImage.frame = self.bounds;
        [self addSubview:bgImage];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+(UIView*)Create:(NSString*)url defauleImage:(NSString*)imageName{
    UIImage*image = [Utility getImageByName:imageName];
    DownloadUIImageView*view = [[[DownloadUIImageView alloc]init:image]autorelease];
    if(!url){
        return view;
    }
    
    NSString*turl = [Utility hdGetFullUrl :url];
    NSString *path = [Utility getUrlPath:turl];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [view setImage:image];
            return view;
        }else {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
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
    
    if (image) {
        [self setImage:image];
        [self fadeIn];
    }
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
