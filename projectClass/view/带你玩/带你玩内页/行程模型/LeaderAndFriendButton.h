//
//  LeaderAndFriendButton.h
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "DownloadUIButton.h"

@interface LeaderAndFriendButton : DownloadUIButton

@property(nonatomic,readonly)UILabel *imageTitleLabel;
+(LeaderAndFriendButton*)Create:(NSString*)url defauleImage:(NSString*)imageName;

@end
