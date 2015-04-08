//
//  LeaderAndFriendCell.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "LeaderAndFriendCell.h"
#import "LeaderAndFriendButton.h"

//frame（0，0 130，150）px
@implementation LeaderAndFriendCell

-(void)dealloc{
    
    self.imageUrl = nil;
    self.defaultImage = nil;
    self.title = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化 LeaderAndFriendButton对象
        _button = [LeaderAndFriendButton Create:@"" defauleImage:@""];
        _button.userInteractionEnabled = NO;
        [self addSubview:_button];
        self.backgroundColor = [UIColor clearColor];
        self.frame = _button.bounds;
    }
    return self;
}

-(void)setImageUrl:(NSString *)imageUrl{
    
    [_imageUrl release];_imageUrl = nil;
    _imageUrl = [imageUrl retain];
    
    [_button setNewUrl:_imageUrl defauleImage:_defaultImage];
}
-(void)setDefaultImage:(NSString *)defaultImage{
    
    [_defaultImage release];_defaultImage = nil;
    _defaultImage = [defaultImage retain];
    
    if (_imageUrl == nil) {
        [_button setImage:[Utility getImageByName:_defaultImage]];
    }else{
        [_button setNewUrl:_imageUrl defauleImage:_defaultImage];
    }
}
-(void)setTitle:(NSString *)title{
    
    [_title release];_title = nil;
    _title = [title retain];
    
    [_button setTitle:title forState:UIControlStateNormal];
}

@end
