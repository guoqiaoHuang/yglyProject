//
//  LeaderAndFriendFlowLayout.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ActivityFlowLayout.h"
#import "Utility.h"

@implementation ActivityFlowLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = YGLY_VIEW_SIZE(CGSizeMake(186, 186));
    self.minimumInteritemSpacing = YGLY_VIEW_FLOAT(20);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
