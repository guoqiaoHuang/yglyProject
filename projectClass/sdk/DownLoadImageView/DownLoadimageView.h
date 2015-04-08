//
//  DownLoadimageView.h
//  yglyProject
//
//  Created by 枫 on 14-11-28.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadModel.h"
@interface DownLoadimageView : UIImageView{
    
    
}
@property(nonatomic,copy) NSString* tmpNowUrl;
@property(nonatomic,assign) float sizeSacle;
@property(nonatomic,retain) ASIHTTPRequest*tmpRequest;
@property(nonatomic,copy) void(^completeBlock)(void);
@property(nonatomic,assign)UIView *superView;

+(id)Create:(NSString*)url defauleImage:(NSString*)imageName;
-(void)setImage:(UIImage *)timage;
-(void)setNewUrl:(NSString*)url;
-(void)setNewUrl:(NSString*)url defauleImage:(NSString*)imageName;
@end

