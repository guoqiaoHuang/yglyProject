//
//  DownLoadimageView.m
//  yglyProject
//
//  Created by 枫 on 14-11-28.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DownLoadimageView.h"
#import "Utility.h"
#import "UtilityExt.h"
#import "LhUIView.h"

@implementation DownLoadimageView
@synthesize completeBlock = _completeBlock;
-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    self.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)setImage:(UIImage *)image{
   
    [super setImage:image];
    if (self.tmpRequest) {
        [DownloadModel deleteRequest:self.tmpRequest];
        self.tmpRequest = nil;
    }
    if (image) {
        if (_superView) {
            
            float sw = _superView.width;
            float sh = _superView.height;
            float iw = image.size.width/image.scale;
            float ih = image.size.height/image.scale;
            if (self.contentMode == UIViewContentModeScaleAspectFit) {
                
                
                if (sh/ih > sw/iw) {
                    if(sh/ih <= 1.0){
                        self.size = CGSizeMake(iw*sh/ih,sh);
                        self.point = CGPointMake(-0.5*(self.width-sw), 0);
                    }else{
                        self.size = CGSizeMake(sw,ih*sw/iw);
                        self.point = CGPointMake(0, -0.5*(self.height-sh));
                    }
                    
                }else{
                    if(sw/iw <= 1.0){
                        self.size = CGSizeMake(sw,ih*sw/iw);
                        self.point = CGPointMake( 0,-0.5*(self.height-sh));
                    }else{
                        self.size = CGSizeMake(iw*sh/ih,sh);
                        self.point = CGPointMake( -0.5*(self.width-sw),0);
                    }
                    
                }
            }else if (self.contentMode == UIViewContentModeScaleAspectFill){
                //以高度
                CGFloat tmpW = sh/ih*iw;
                if(tmpW >= _superView.width){
                    
                    self.size = CGSizeMake(tmpW, sh);
                    self.point = CGPointMake(0, 0);
                }else{
                CGFloat tmpH = sw/iw*ih;
                   self.size = CGSizeMake(sw, tmpH);
                   self.point = CGPointMake(0, 0);
                }
                
            }
        }
    }
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}
-(id)init:(UIImage*)image{
    self = [super init];
    if ((self)) {
        self.backgroundColor = [UIColor clearColor];
        [self setImage:image];
        
    }
    return self;
}


+(id)Create:(NSString*)url defauleImage:(NSString*)imageName{
    UIImage*image = [Utility getImageByName:imageName];
    DownLoadimageView*view = [[[DownLoadimageView alloc]init:image]autorelease];
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
    self.completeBlock = nil; _completeBlock = NULL;
    [super dealloc];
    
}

-(void)removeFromSuperview{
    [DownloadModel deleteRequest:self.tmpRequest];
    [super removeFromSuperview];
}
@end
