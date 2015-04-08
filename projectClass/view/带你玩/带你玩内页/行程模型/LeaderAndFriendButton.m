//
//  LeaderAndFriendButton.m
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "LeaderAndFriendButton.h"
#import "Utility.h"
#import "UtilityExt.h"
#import <CoreText/CoreText.h>
#import "HBJUIImage.h"

@implementation LeaderAndFriendButton

//该view的尺寸 130 * 150 px
//图片的尺寸为 100*100 px

-(id)init:(UIImage*)image{
    self = [super init];
    if (self) {
        
        self.frame = YGLY_VIEW_FRAME_ONLY_SIZE(CGRectMake(0, 0, 130, 150));
        self.titleLabel.font = [UIFont systemFontOfSize: YGLY_VIEW_FLOAT(30)];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = YGLY_VIEW_FLOAT(100)/2.0;
        
        self.backgroundColor = [UIColor whiteColor];
        [self setImage:image];
        
        _imageTitleLabel = [[UILabel alloc] initWithFrame:self.imageView.bounds];
        _imageTitleLabel.backgroundColor = [UIColor clearColor];
        _imageTitleLabel.textColor = [UIColor whiteColor];
        _imageTitleLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(30)];
        _imageTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageView addSubview:_imageTitleLabel];
        [_imageTitleLabel release];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+(LeaderAndFriendButton*)Create:(NSString*)url defauleImage:(NSString*)imageName{
    UIImage*image = [Utility getImageByName:imageName];
    LeaderAndFriendButton*view = [[[LeaderAndFriendButton alloc]init:image]autorelease];
    if(!url){
        return view;
    }
    
    NSString*turl = [Utility hdGetFullUrl :url];
    NSString *path = [Utility getUrlPath:turl];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [view setImage:image];
        }else{
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            if(url){
                view.tmpRequest = [[DownloadModel sharedDownloadModel]downloadImage:view url:url tag:10 validator:view];
                view.tmpNowUrl = url;
            }
        }
    }else{
        if(url){
            view.tmpRequest = [[DownloadModel sharedDownloadModel]downloadImage:view url:url tag:10 validator:view];
            view.tmpNowUrl = url;
        }
    }
    return view;
}

//重写text和imageView的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    contentRect.origin.x = 0;
    contentRect.origin.y = YGLY_VIEW_FLOAT(100);
    contentRect.size.height = YGLY_VIEW_FLOAT(50);
    contentRect.size.width = YGLY_VIEW_FLOAT(130);
    
    return contentRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    contentRect.size.height = YGLY_VIEW_FLOAT(100);
    contentRect.origin.x = YGLY_VIEW_FLOAT(30)/2.0;
    contentRect.size.width = YGLY_VIEW_FLOAT(100);
    return contentRect;
}

@end
