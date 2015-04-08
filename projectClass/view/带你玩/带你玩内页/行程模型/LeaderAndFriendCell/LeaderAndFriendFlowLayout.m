//
//  LeaderAndFriendFlowLayout.m
//  yglyProject
//
//  Created by 枫 on 14-10-17.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "LeaderAndFriendFlowLayout.h"
#import "Utility.h"

@implementation LeaderAndFriendFlowLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    //130
    self.itemSize = YGLY_VIEW_SIZE(CGSizeMake(130, 150));
    self.minimumInteritemSpacing = 1.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsZero;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

//用来设置其的水平间距
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 1.0;//自定义水平item之间的间距
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}
@end
