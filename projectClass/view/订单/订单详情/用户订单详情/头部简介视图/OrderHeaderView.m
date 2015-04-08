

#import "OrderHeaderView.h"
#import "Utility.h"

@implementation OrderHeaderView

-(void)setDict:(NSDictionary*)dict{
    
    if (!self.scroll) {
        
        CGFloat topDistance = 0;//px
        photo = (DownloadUIImageView*)[DownloadUIImageView Create:nil defauleImage:[dict objectForKey:@"defaultImageName"]];
      //  CGRect imageRect = {{0,topDistance},{250,250}};
       // photo.frame = YGLY_VIEW_FRAME_ALL(imageRect);
        
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]autorelease];;
        [self addGestureRecognizer:singleTap];
        
        self.scroll=[[[UIScrollView alloc]initWithFrame: self.bounds]autorelease];
        [self.scroll setShowsHorizontalScrollIndicator:NO];
        [self.scroll setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.scroll];
        [self.scroll addSubview:photo];
        
        CGFloat photoW = CGRectGetMaxX(photo.frame)/YGLY_SIZE_SCALE + 20;//(px)
        titleLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(CGRectMake(photoW, topDistance+60, 400, 65))]autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [self.scroll addSubview:titleLabel];
        
        CGRect priceRect = {{photoW,topDistance+125},{160,65}};
        priceLabel =[[[UILabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(priceRect)]autorelease];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [Utility hexStringToColor:@"#ff6d00"];
        priceLabel.font = [UIFont boldSystemFontOfSize:YGLY_VIEW_FLOAT(30)];
        [self.scroll addSubview:priceLabel];
        
        CGRect strikeRect = {{photoW+160,topDistance+126},{160,65}};
        originalPriceLabel =[[[StrikeThroughLabel alloc]initWithFrame: YGLY_VIEW_FRAME_ALL(strikeRect)]autorelease];
        originalPriceLabel.strikeThroughEnabled = YES;
        originalPriceLabel.backgroundColor = [UIColor clearColor];
        originalPriceLabel.textColor = [Utility hexStringToColor:@"#cacaca"];
        originalPriceLabel.font = [UIFont systemFontOfSize:YGLY_VIEW_FLOAT(26)];
        [self.scroll addSubview:originalPriceLabel];

        imageView = [Utility getUIImageViewByName:@"进入默认.png"];
        imageView.point = YGLY_VIEW_POINT(CGPointMake(CGRectGetMaxX(titleLabel.frame)/YGLY_SIZE_SCALE,85));
        [self.scroll addSubview:imageView];
        
        self.scroll.contentSize=(CGSize){CGRectGetMaxX(imageView.frame)+YGLY_VIEW_FLOAT(20),0};
        scrollOffest = CGPointMake(self.scroll.contentSize.width - self.size.width, 0);
        self.scroll.contentOffset = scrollOffest;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [photo setNewUrl:[dict objectForKey:@"photo"] defauleImage:[dict objectForKey:@"defaultImageName"]];
        titleLabel.text = [dict strValue:@"title"];
        
        priceLabel.text = @"¥ -元/人";
        NSMutableString *tmpStr = [NSMutableString stringWithString:priceLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"price" default:@"0"]];
        priceLabel.text = tmpStr;
        
        originalPriceLabel.text = @"¥ -元";
        tmpStr = [NSMutableString stringWithString:originalPriceLabel.text];
        [tmpStr replaceCharactersInRange:[tmpStr rangeOfString:@"-"] withString:[dict strValue:@"originalPrice" default:@"0"]];
        originalPriceLabel.text = tmpStr;
        
    });
    
}


#pragma mark- tapGesture
-(void)handleSingleTap:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(orderHeaderViewhadTap)]) {
        
        [_delegate orderHeaderViewhadTap];
    }
}
-(void)dealloc{
    [super dealloc];
}
@end
