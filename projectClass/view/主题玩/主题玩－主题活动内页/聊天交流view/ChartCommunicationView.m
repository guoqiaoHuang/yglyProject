//
//  ChartCommunicationView.m
//  yglyProject
//
//  Created by 枫 on 14-11-3.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 NSDictionary *dict = @{
 @"headImageUrl":@"",
 @"topLabelText":@"",
 @"bellowBodayDict":@"",
 @"method":@"",
 @"target":@"",
 @"tagDic":@"",
 @"date":@""};
 
NSDictionary *tagDic = @{@"用户名":@"用户的标识符"}
 */
#import "ChartCommunicationView.h"
#import "Utility.h"
#import "BaseUIImageView.h"
@implementation ChartCommunicationView

-(void)dealloc{
    
    self.indexPath = nil;
    [super dealloc];
}


-(void)setWithDict:(NSDictionary *)dict{
    
    //用户头像
    if (!headImageView) {
        headImageView = [DownloadUIButton Create:@"" defauleImage:@"leader.png"];
        headImageView.userInteractionEnabled = NO;
        headImageView.clipsToBounds = YES;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = CGRectGetWidth(headImageView.frame)/2.0;
        CGRect rect = headImageView.frame;
        rect.origin.x = YGLY_VIEW_FLOAT(33);
        rect.origin.y = YGLY_VIEW_FLOAT(22);
        headImageView.frame = rect;
        [self.contentView addSubview:headImageView];
        
        //用户评论背景图片
        if (!topLabeBGImageView) {
            UIImage *image = [Utility getImageByName:@"对话框.png"];
            CGRect imageRect = {{135,22},{CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE - 135 - 32,70}};
            topLabeBGImageView = [[[UIImageView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(imageRect)] autorelease];
            topLabeBGImageView.layer.masksToBounds = YES;
            topLabeBGImageView.layer.cornerRadius = YGLY_VIEW_FLOAT(5.0);
            topLabeBGImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(47, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
            
            [self.contentView addSubview:topLabeBGImageView];
            
        }
        //用来点击后调出键盘，以回复用户
        if (!msgBtn) {
            CGRect btnRect = {{CGRectGetWidth(topLabeBGImageView.frame)/YGLY_SIZE_SCALE - 80,0},{80,80}};
            msgBtn = [[[UIButton alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(btnRect)]autorelease];;
            [msgBtn setImage:[Utility getImageByName:@"replyMsgBtn.png"] forState:UIControlStateNormal];
            msgBtn.backgroundColor = [Utility hexStringToColor:@"#efefef"];
            [msgBtn addTarget:self action:@selector(callKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
            [topLabeBGImageView addSubview:msgBtn];
            topLabeBGImageView.userInteractionEnabled = YES;
        }
        
        
        //用户评论label
        if (!topLabel) {
            topLabel = [[[LHMLEmojiLabel alloc] init] autorelease];
            topLabel.textAlignment = NSTextAlignmentLeft;
            topLabel.lineBreakMode = NSLineBreakByCharWrapping;
            topLabel.backgroundColor = [UIColor clearColor];
            topLabel.isNeedAtAndPoundSign = YES;
            topLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            topLabel.customEmojiPlistName = @"expressionImage_custom.plist";
            
            topLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
            topLabel.textColor = [UIColor blackColor];
            topLabel.numberOfLines = 0;
            [topLabeBGImageView addSubview:topLabel];
        }
        
        //回复背景视图
        if (!bellowBodyBGView) {
            
            CGRect imageRect = {{165,CGRectGetMaxY(topLabeBGImageView.frame) + 2},{CGRectGetWidth(self.frame)/YGLY_SIZE_SCALE - 165 - 32,70}};
            bellowBodyBGView = [[[UIView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(imageRect)] autorelease];
            bellowBodyBGView.backgroundColor = [Utility hexStringToColor:@"#ececec"];
            bellowBodyBGView.layer.masksToBounds = YES;
            bellowBodyBGView.layer.cornerRadius = YGLY_VIEW_FLOAT(5.0);
            [self.contentView addSubview:bellowBodyBGView];
        }
        //回复内容展示
        if (!bellowBody) {
            
            CGRect bellowBodyRect = {{10,10},{CGRectGetWidth(bellowBodyBGView.frame)/YGLY_SIZE_SCALE - 20,30}};
            bellowBody = [[[ReplyMsgView alloc] initWithFrame:YGLY_VIEW_FRAME_ALL(bellowBodyRect)] autorelease];
            bellowBody.clipsToBounds = YES;
            [bellowBodyBGView addSubview:bellowBody];
        }
        if (!timeLabel) {
            
            timeLabel = [[[UILabel alloc] init] autorelease];
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.textColor = [Utility hexStringToColor:@"#afafaf"];
            timeLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(22)];
            timeLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:timeLabel];
        }
    }
    self.size = CGSizeMake(self.width, self.cellHeight);
    if (_cellHeight > 0.0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadContentWithDict:dict isAsync:YES];
        });
    }else{
        [self loadContentWithDict:dict isAsync:NO];
    }
}
-(void)loadContentWithDict:(NSDictionary *)dict isAsync:(BOOL)isAsync{
    
    // set head image
    if ([dict strValue:@"headImageUrl"]) {
        [headImageView setNewUrl:[dict strValue:@"headImageUrl"] defauleImage:@"leader.png"];
    }
    // set topLabelText
    if ([dict strValue:@"topLabelText"]) {
        
        [topLabel setEmojiText:[dict strValue:@"topLabelText"]];
        
        CGRect labelRect = {{22.5,10},{CGRectGetWidth(topLabeBGImageView.frame) - 55, 30}};
        topLabel.frame = labelRect;
        [topLabel sizeToFit];
        
        CGRect imageRect = topLabeBGImageView.frame;
        imageRect.size.height = CGRectGetMaxY(topLabel.frame) + YGLY_VIEW_FLOAT(20);
        topLabeBGImageView.frame = imageRect;
        
        CGRect bellowImageRect = bellowBodyBGView.frame;
        bellowImageRect.origin.y = CGRectGetMaxY(topLabeBGImageView.frame) + YGLY_VIEW_FLOAT(2);
        bellowBodyBGView.frame = bellowImageRect;
    }
    
    //设置时间label相对比的view
    //如果下边有评论 则为bellowBodyBGImageView
    UIView *referenceView = nil;
    if ([dict objectForKey:@"bellowBodayDict"] &&
        ((NSArray *)[dict objectForKey:@"bellowBodayDict"]).count > 0){
        
        [bellowBody setWithDict:[dict objectForKey:@"bellowBodayDict"] method:[dict strValue:@"method"] target:[dict valueForKey:@"target"] ];
        CGRect frame = bellowBodyBGView.frame;
        frame.size.height = CGRectGetMaxY(bellowBody.frame);
        bellowBodyBGView.frame = frame;
        [bellowBodyBGView addSubview:bellowBody];
        
        referenceView = bellowBodyBGView;
        bellowBodyBGView.hidden = NO;
    }else{//下边没有评论 则为topLabeBGImageView
        
        referenceView = topLabeBGImageView;
        bellowBodyBGView.hidden = YES;
    }
    
    //set timeLabel
    if ([dict strValue:@"date"]) {
        
        CGFloat maxY = CGRectGetMaxY(referenceView.frame);
        timeLabel.text = [dict strValue:@"date"];
        [timeLabel sizeToFit];
        CGRect labelRect = timeLabel.frame;
        labelRect.origin.y = maxY+YGLY_VIEW_FLOAT(10);
        labelRect.origin.x = CGRectGetWidth(self.frame)-YGLY_VIEW_FLOAT(32)-CGRectGetWidth(timeLabel.frame);
        timeLabel.frame = labelRect;
        
    }
    
    if (!isAsync) {
        
        CGRect cellRect = self.frame;
        cellRect.size.height = CGRectGetMaxY(timeLabel.frame)+YGLY_VIEW_FLOAT(10);
        self.size = cellRect.size;
    }
}

-(void)callKeyBoard:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(callKeyBoardBtn:atIndexPath:)]) {
        [_delegate callKeyBoardBtn:sender atIndexPath:_indexPath];
    }
}

@end
