//
//  ChartCommunicationView.h
//  yglyProject
//
//  Created by 枫 on 14-11-3.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadUIButton.h"
#import "ReplyMsgView.h"
#import "LHMLEmojiLabel.h"

@protocol ChartCommunicationViewDelegate <NSObject>

-(void)callKeyBoardBtn:(UIButton *)sender atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChartCommunicationView : UITableViewCell
{
    DownloadUIButton *headImageView;
    UIImageView *topLabeBGImageView;
    UIButton *msgBtn;
    LHMLEmojiLabel *topLabel;
    UIView *bellowBodyBGView;
    ReplyMsgView *bellowBody;
    UILabel *timeLabel;
}
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)id<ChartCommunicationViewDelegate> delegate;

-(void)setWithDict:(NSDictionary *)dict;
@end
