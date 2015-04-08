//
//  LeaderAndFriendCell.h
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaderAndFriendButton.h"

@interface LeaderAndFriendCell : UICollectionViewCell

@property(nonatomic, retain)NSString *imageUrl;
@property(nonatomic, retain)NSString *defaultImage;
@property(nonatomic, retain)NSString *title;
@property(nonatomic, assign, readonly)LeaderAndFriendButton *button;

@end
