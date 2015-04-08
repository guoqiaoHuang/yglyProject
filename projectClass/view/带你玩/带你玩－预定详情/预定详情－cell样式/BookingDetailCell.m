//
//  BookingDetailCell.m
//  yglyProject
//
//  Created by 枫 on 14-11-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//
/*
 
 NSDictionary *dict = @{@"imgUrl":@"",@"defaultImage":@"",
 @"title":@"",
 @"price":@""};
 */
#import "BookingDetailCell.h"

@implementation BookingDetailCell

-(void)setWithDict:(NSDictionary *)dict{
    
    if (!imageView) {
        //
        imageView = (DownloadUIImageView *)[DownloadUIImageView Create:nil defauleImage:[dict strValue:@"defaultImage"]];
        CGRect imageRect = {{self.size.width - YGLY_VIEW_FLOAT(100+20),YGLY_VIEW_FLOAT(15)},{YGLY_VIEW_FLOAT(100),YGLY_VIEW_FLOAT(100)}};
        imageView.frame = imageRect;
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
        //
      //  CGRect titleRect = {{YGLY_VIEW_FLOAT(20),YGLY_VIEW_FLOAT(15)},{CGRectGetMinX(imageRect)-YGLY_VIEW_FLOAT(20),YGLY_VIEW_FLOAT(50)}};
        CGRect titleRect = {{YGLY_VIEW_FLOAT(20),YGLY_VIEW_FLOAT(15)},{self.size.width-YGLY_VIEW_FLOAT(40),YGLY_VIEW_FLOAT(50)}};
        titleLabel = [[[UILabel alloc] initWithFrame:titleRect] autorelease];
        titleLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLabel];
        //
        CGRect subTitleRect = {{YGLY_VIEW_FLOAT(20),YGLY_VIEW_FLOAT(15+50)},titleRect.size};
        subTitleLabel = [[[UILabel alloc] initWithFrame:subTitleRect] autorelease];
        subTitleLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:subTitleLabel];
        
        [self clearAllLine];
        [self insertValue:CGPointMake(self.width*0.05, self.size.height-1) end:CGPointMake(self.width*0.95, self.size.height-1) color:@"#949494" width:1];
        self.backgroundColor = [UIColor clearColor];
    }

  //  [imageView setNewUrl:[dict strValue:@"imgUrl"] defauleImage:@"预定详情默认图片.png"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        titleLabel.text = [dict strValue:@"title"];
        
        subTitleLabel.text = @"价值：¥ - 元";
        NSMutableAttributedString *atrString = [[[NSMutableAttributedString alloc] initWithString:subTitleLabel.text] autorelease];
        [atrString replaceCharactersInRange:[subTitleLabel.text rangeOfString:@"-"] withString:[dict strValue:@"price"]];
        [atrString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[atrString.string rangeOfString:[dict strValue:@"price"]]];
        subTitleLabel.attributedText = atrString;
    });
    
}

@end
