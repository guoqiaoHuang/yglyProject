#import "BusinessOrderCell.h"
#import "Utility.h"
#import "OrderView.h"
#import "BaseUIImageView.h"
#import "ACPButton.h"

@implementation BusinessOrderCell
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
        
        CGFloat photoW = CGRectGetMaxX(photo.frame)/YGLY_SIZE_SCALE + 20;//(px)
        titleLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(CGRectMake(photoW, topDistance+20, 485, 56))]autorelease];
        titleLabel.backgroundColor = [Utility hexStringToColor:@"#dcdcdc"];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [Utility addBevel:titleLabel];
        [self.scroll addSubview:titleLabel];
        
        CGRect numberRect = {{photoW,topDistance+20+56},{242.5,194}};
        numberLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(numberRect)]autorelease];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [Utility hexStringToColor:@"#ff6d00"];
        numberLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [self.scroll addSubview:numberLabel];
        
        CGRect priceRect = {{photoW+242.5,topDistance+20+56},{242.5,194}};
        timeLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(priceRect)]autorelease];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [Utility hexStringToColor:@"#cacaca"];
        timeLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [self.scroll addSubview:timeLabel];

        self.scroll.contentSize=(CGSize){CGRectGetMaxX(timeLabel.frame)+YGLY_VIEW_FLOAT(50),0};
        scrollOffest = CGPointMake(self.scroll.contentSize.width - self.size.width, 0);
        self.scroll.delegate = self;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [photo setNewUrl:[dict objectForKey:@"photo"] defauleImage:[dict objectForKey:@"defaultImageName"]];
        titleLabel.text = [dict strValue:@"title"];
        
        numberLabel.text = @"已报名：-人";
        NSMutableString *tmpStr = [NSMutableString stringWithString:numberLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"number" default:@"0"]];
        numberLabel.text = tmpStr;
        
        timeLabel.text = @"时间：-";
        tmpStr = [NSMutableString stringWithString:timeLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"time" default:@"7月19日"]];
        timeLabel.text = tmpStr;
        
    });
    
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
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%zi",self.row]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    flagStop = NO;
    OrderView*order =   (OrderView*)self.delegate;
    [order.posDict removeAllObjects];
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%zi",self.row]];
}

#pragma mark- colorBtnClicked
-(void)colorBtnClicked:(UIButton *)sender{
    
}
-(void)dealloc{
    [super dealloc];
}
@end
