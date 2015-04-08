#import "OrderCell.h"
#import "Utility.h"
#import "OrderView.h"
#import "BaseUIImageView.h"
#import "ACPButton.h"

@implementation OrderCell
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate) {
        OrderView*order =   (OrderView*)self.delegate;
        [order clickCellButton:self.row];
    }
}


-(void)setDict:(NSDictionary*)dict{
    
    if (!self.scroll) {
        
        CGFloat topDistance = 20;//px
        photo = (DownloadUIImageView*)[DownloadUIImageView Create:nil defauleImage:[dict objectForKey:@"defaultImageName"]];
      //  CGRect imageRect = {{20,topDistance},{250,250}};
       // photo.frame = YGLY_VIEW_FRAME_ALL(imageRect);
        
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]autorelease];;
        [self addGestureRecognizer:singleTap];
        
        self.scroll=[[[UIScrollView alloc]initWithFrame: self.bounds]autorelease];
        [self.scroll setShowsHorizontalScrollIndicator:NO];
        [self.scroll setShowsVerticalScrollIndicator:NO];
        [self.contentView addSubview:self.scroll];
        [self.scroll addSubview:photo];
        
        //352,53
        CGFloat photoW = CGRectGetMaxX(photo.frame)/YGLY_SIZE_SCALE + 20;//(px)
        dingdanHao =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(CGRectMake(photoW, topDistance, 352, 56))]autorelease];
        dingdanHao.backgroundColor = [Utility hexStringToColor:@"#dcdcdc"];
        dingdanHao.textColor = [UIColor blackColor];
        dingdanHao.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [Utility addBevel:dingdanHao];
        [self.scroll addSubview:dingdanHao];
        
        CGRect titleRect = {{photoW,topDistance+54+1},{480,65}};
        titleName =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(titleRect)]autorelease];
        titleName.backgroundColor = [UIColor clearColor];
        titleName.textColor = [UIColor blackColor];
        titleName.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [self.scroll addSubview:titleName];
        
        CGRect numberRect = {{photoW,topDistance+(54+1)+65},{480,65}};
        numberLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(numberRect)]autorelease];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [self.scroll addSubview:numberLabel];
        
        CGRect priceRect = {{photoW,topDistance+(54+1)+65*2},{250,65}};
        priceLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(priceRect)]autorelease];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [Utility hexStringToColor:@"#ff6d00"];
        priceLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [self.scroll addSubview:priceLabel];
        
        NSDictionary *colorBtnDict = @{@"title":@"",
                                       @"method":@"colorBtnClicked:",
                                       @"size":@"{180,60}",
                                       @"size_Iphone4":@"{90,30}",
                                       @"size_Iphone5":@"{90,30}",
                                       @"size_Iphone6":@"{90,30}",
                                       @"position":[NSString stringWithFormat:@"{%f,%f}",(CGRectGetMaxX(dingdanHao.frame)-CGRectGetHeight(dingdanHao.frame))/YGLY_SIZE_SCALE ,topDistance+(54+1)+65*2+2.5],
                                       @"position_Iphone4":[NSString stringWithFormat:@"{%f,%f}",(CGRectGetMaxX(dingdanHao.frame)-CGRectGetHeight(dingdanHao.frame))/YGLY_SIZE_SCALE ,topDistance+(54+1)+65*2+2.5],
                                       @"position_Iphone5":[NSString stringWithFormat:@"{%f,%f}",(CGRectGetMaxX(dingdanHao.frame)-CGRectGetHeight(dingdanHao.frame))/YGLY_SIZE_SCALE ,topDistance+(54+1)+65*2+2.5],
                                       @"position_Iphone6":[NSString stringWithFormat:@"{%f,%f}",(CGRectGetMaxX(dingdanHao.frame)-CGRectGetHeight(dingdanHao.frame))/YGLY_SIZE_SCALE ,topDistance+(54+1)+65*2+2.5],
                                       @"fontsize":@"26",
                                       @"fontsize_Iphone4":@"13",
                                       @"fontsize_Iphone5":@"13",
                                       @"fontsize_Iphone6":@"13",
                                       @"highlightcolor":@"#b40000",
                                       @"color":@"#ff9933",
                                       @"textcolor":@"#ffffff",
                                       @"texthighlightcolor":@"#ffffff",
                                       @"cornerradius":@"5",
                                       @"tag":@""};
        button = [BaseUIImageView setColorButtonWithDict:colorBtnDict target:self];
        button.userInteractionEnabled = NO;
        [self.scroll addSubview:button];

        self.scroll.contentSize=(CGSize){CGRectGetMaxX(button.frame)+YGLY_VIEW_FLOAT(20),0};
        scrollOffest = CGPointMake(self.scroll.contentSize.width - self.size.width, 0);
        self.scroll.delegate = self;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [photo setNewUrl:[dict objectForKey:@"photo"] defauleImage:[dict objectForKey:@"defaultImageName"]];
        dingdanHao.text = [dict strValue:@"dingdanHao"];
        titleName.text = [dict strValue:@"titleName"];
        
        numberLabel.text = @"数量：-";
        NSMutableString *tmpStr = [NSMutableString stringWithString:numberLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"number" default:@"0"]];
        numberLabel.text = tmpStr;
        
        priceLabel.text = @"¥ -元/人";
        tmpStr = [NSMutableString stringWithString:priceLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"price" default:@"0"]];
        priceLabel.text = tmpStr;
        
        [self setBtnTitle:[dict strValue:@"btnTitle"]];
    });
    
}

-(void)setBtnTitle:(NSString *)title{
    
    [button setTitle:title forState:UIControlStateNormal];
    ACPButton *sender = (ACPButton *)button;
    //三种状态 未过期 已过期 完成
    if ([title hasPrefix:@"未过期"]) {
        
        [sender setFlatStyle:[Utility hexStringToColor:@"#b40000"] andHighlightedColor:[Utility hexStringToColor:@"#ff9933"]];
        sender.tag = 10001;
    }else if ([title hasPrefix:@"已过期"]){
        
        [sender setFlatStyle:[Utility hexStringToColor:@"#c8c8c8"] andHighlightedColor:[Utility hexStringToColor:@"#c8c8c8"]];
        sender.tag = 10002;
    }else if ([title hasPrefix:@"已完成"]){
        
        [sender setFlatStyle:[Utility hexStringToColor:@"#c8c8c8"] andHighlightedColor:[Utility hexStringToColor:@"#b40000"]];
        sender.tag = 10003;
    }
    
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 5.0f;
}

-(void)resetAni{
    [self.scroll setContentOffset:scrollOffest animated:YES];
}
-(void)resetOff{
    if (self.delegate) {
        OrderView*order =   (OrderView*)self.delegate;
        float value = [order.posDict floatValue:[NSString stringWithFormat:@"%ld",(long)self.row] default:10000];
        if (value >= 10000) {
            self.scroll.contentOffset = scrollOffest;
        }else{
            self.scroll.contentOffset = CGPointMake(value, 0);
        }
    }else{
        self.scroll.contentOffset = scrollOffest;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    flagStop = YES;
     OrderView*order =   (OrderView*)self.delegate;
    [order cellWillBeginDecelerating:self];
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%ld",(long)self.row]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    flagStop = NO;
    OrderView*order =   (OrderView*)self.delegate;
    [order.posDict removeAllObjects];
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%ld",(long)self.row]];
}

#pragma mark- colorBtnClicked
-(void)colorBtnClicked:(UIButton *)sender{
    
}
-(void)dealloc{
    [super dealloc];
}
@end
