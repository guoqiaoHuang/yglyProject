//
//  FeaturePlayInnerView.h
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BackTitleUIImageView.h"
#import "VIewDadaGet.h"
#import "LhNoticeMsg.h"
@interface FeaturePlayInnerView : BackTitleUIImageView<VIewDadaGetDelegate>{
    BOOL flagStop;
    
    
}
@property(nonatomic,assign)NSInteger selfCatid;
@property(nonatomic,retain)NSArray*xl_tuijian;
@property(nonatomic,assign)BOOL flagQuGuo;
@property(nonatomic,assign)BOOL flagXiangQu;
@end
