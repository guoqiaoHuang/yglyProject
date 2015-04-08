//
//  FavourateCell.m
//  yglyProject
//
//  Created by 枫 on 15-1-5.
//  Copyright (c) 2015年 雷海. All rights reserved.
//

#import "FavourateCell.h"
#import "Utility.h"

/*
 NSDictionary *dic = @{@"defaultImage":@"",
 @"imgUrl":@"",
 @"title":@"",
 @"zhuban":@"",
 @"address":@"",
 @"time":@""};
 */
@implementation FavourateCell

-(void)setWithDict:(NSDictionary *)dict{
   
    if (!_leftImageView) {
        
        CGFloat imageW;
        _leftImageView = (DownloadUIImageView *)[DownloadUIImageView Create:nil defauleImage:[dict strValue:@"defaultImage"]];
        _leftImageView.point = CGPointMake(5, (self.height - _leftImageView.height)/2.0);
        [Utility AddRoundedCorners:_leftImageView size:10 type:UIRectCornerAllCorners];
        [self.contentView addSubview:_leftImageView];
        imageW = CGRectGetMaxX(_leftImageView.frame) + 10;
        
        _titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.frame = CGRectMake(imageW, self.height*0/4, 193, self.height/4.0);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _zhubanLabel = [[[UILabel alloc] init] autorelease];
        _zhubanLabel.frame = CGRectMake(imageW, self.height*1/4, 193, self.height/4.0);
        _zhubanLabel.backgroundColor = [UIColor clearColor];
        _zhubanLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_zhubanLabel];
       
        _addressLabel = [[[UILabel alloc] init] autorelease];
        _addressLabel.frame = CGRectMake(imageW, self.height*2/4, 193, self.height/4.0);
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_addressLabel];
        
        _lockImageView = [Utility getUIImageViewByName:@"zhongbiao.png"];
        _lockImageView.point = CGPointMake(imageW, self.height*3/4+(self.height*1/4-_lockImageView.height)/2.0);
        [self.contentView addSubview:_lockImageView];
        
        _timeLabel = [[[UILabel alloc] init] autorelease];
        _timeLabel.frame = CGRectMake(imageW+_lockImageView.width+1, self.height*3/4, 120, self.height/4.0);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        _makeLabel = [[[UILabel alloc] init] autorelease];
        _makeLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+10, self.height*3/4, 50, 14);
        _makeLabel.backgroundColor = [UIColor clearColor];
        _makeLabel.font = [UIFont systemFontOfSize:12];
        _makeLabel.text = @"浪游快报";
        _makeLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_makeLabel];
        
        _rightImageVeiw = [Utility getUIImageViewByName:@"箭头默认.png"];
        _rightImageVeiw.point = CGPointMake(CGRectGetMaxX(_titleLabel.frame)-5,(self.height-_rightImageVeiw.height)/2.0);
        [self.contentView addSubview:_rightImageVeiw];
    }
    
    [_leftImageView setNewUrl:[dict strValue:@"imgUrl"]];
    //[Utility delay:0.0 action:^{
       
        _titleLabel.text = [dict strValue:@"title"];
        _zhubanLabel.text = [dict strValue:@"zhuban"];
        NSMutableAttributedString *atrString = [[[NSMutableAttributedString alloc] initWithString:[dict strValue:@"address"]] autorelease];
        [atrString addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(1, 1)];
        _addressLabel.attributedText = atrString;
        _timeLabel.text = [dict strValue:@"time"];
  //  }];
}
@end
