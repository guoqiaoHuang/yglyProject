
#import "TakePlayCell.h"
#import "Utility.h"
#import "TakePlayView.h"
#import "HBJNSString.h"
#define TP_TOP_OFFSET 20
/*
 NSDictionary *dic = @{@"photoUrl":@"",@"defaultImageName":@"",
 @"title":@"",
 @"date":@"",
 @"routeDay":@"",
 @"location":@"",
 @"peoples":@"",
 @"types":@[],
 @"price":@""};
 */
@interface TakePlayCell ()
{
    CGFloat titleLabelMaxX;
    CGFloat imageW;
}
@end
@implementation TakePlayCell
#pragma mark 刷新数据
-(void)setDict:(NSDictionary*)dict{
    if (!self.scroll) {
        senceImage = (DownloadUIImageView*)[DownloadUIImageView Create:nil defauleImage:@"带你玩默认图片.png"];
        cellwidth = senceImage.size.width*0.75;
        senceImage.point = CGPointMake(0, 0);
        _scroll=[[[UIScrollView alloc]initWithFrame: self.bounds]autorelease];
        [self.scroll setShowsHorizontalScrollIndicator:NO];
        [self.scroll setShowsVerticalScrollIndicator:NO];
        [self.contentView addSubview:self.scroll];
        [self.scroll addSubview:senceImage];
        self.scroll.delegate = self;
        self.scroll.contentSize=(CGSize){cellwidth+self.size.width,0};
        
        //点击手势
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]autorelease];;
        [self addGestureRecognizer:singleTap];
        
        
        //标题
        titleLabel = [self createLabelWithText:nil fontSize:15 point:CGPointMake(senceImage.size.width+10, 10) textColor:[UIColor blackColor] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        [self.scroll addSubview:titleLabel];
        
        //时间
        dateLabel = [self createLabelWithText:nil fontSize:13 point:CGPointMake(senceImage.size.width+10, 37) textColor:[UIColor blackColor] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        [self.scroll addSubview:dateLabel];
        //行程
        routeLabel = [self createLabelWithText:nil fontSize:11 point:CGPointMake(cellwidth+110, 30) textColor:[UIColor blackColor] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        routeLabel.size = CGSizeMake(200, 30);
        routeLabel.textAlignment = NSTextAlignmentRight;
        [self.scroll addSubview:routeLabel];
        
        //地点
        locationLabel = [self createLabelWithText:nil fontSize:13 point:CGPointMake(senceImage.size.width+10, 61) textColor:[UIColor blackColor] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        [self.scroll addSubview:locationLabel];
        //人数
        peoplesLabel = [self createLabelWithText:nil fontSize:11 point:CGPointMake(cellwidth+110, 54) textColor:[UIColor blackColor] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        peoplesLabel.size = CGSizeMake(200, 30);
        peoplesLabel.textAlignment = NSTextAlignmentRight;
        [self.scroll addSubview:peoplesLabel];
        
        //类型
        for (int i = 0; i < 3; i++) {
            
            typesLabel[i] = [self createLabelWithText:nil fontSize:13 point:CGPointMake(senceImage.size.width+10+40*i, 100) textColor:[UIColor whiteColor] bgColor:[Utility hexStringToColor:@"#a6c9ed"] size:CGSizeMake(36, 18) isCycleCorner:YES];
            typesLabel[i].textAlignment = NSTextAlignmentCenter;
            [self.scroll addSubview:typesLabel[i]];
        }
        //价格
        priceLabel = [self createLabelWithText:nil fontSize:15 point:CGPointMake(cellwidth+110, 93) textColor:[Utility hexStringToColor:@"#ff6d00"] bgColor:nil size:CGSizeZero isCycleCorner:NO];
        priceLabel.size = CGSizeMake(200, 30);
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        [self.scroll addSubview:priceLabel];
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [senceImage setNewUrl:[dict strValue:@"img"] defauleImage:@"带你玩默认图片.png"];
        titleLabel.text = [dict strValue:@"mobile_title"];
        [titleLabel sizeToFit];titleLabelMaxX = CGRectGetMaxX(titleLabel.frame);
        dateLabel.text = [[dict strValue:@"date"] substringWithRange:NSMakeRange(0,10)];
        [dateLabel sizeToFit];
        NSString *routeStr = [NSString stringWithFormat:@"行程: %@天",[dict strValue:@"day"]];
        NSMutableAttributedString *routeAtrStr = [[[NSMutableAttributedString alloc] initWithString:routeStr] autorelease];
        NSRange range = [routeStr rangeOfString:[NSString stringWithFormat:@"%@",[dict strValue:@"day"]]];
        [routeAtrStr setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]} range:range];
        routeLabel.attributedText = routeAtrStr;
        
        NSDictionary *address = [dict objectForKey:@"address"];
        if (address && [address isKindOfClass:[NSDictionary class]]) {
            locationLabel.text = [address objectForKey:@"address"];
             NSString*location = [address objectForKey:@"content"];
            if (location) {//经纬度存在
                NSRange range = [location rangeOfString:@"|"];
                if (range.location != NSNotFound) {
                    NSString*a1 =  [location substringWithRange:NSMakeRange(0,range.location)];
                    NSString*tmp =  [location substringWithRange:NSMakeRange(range.location+1,location.length-range.location-1)];
                    
                    range = [tmp rangeOfString:@"|"];
                    if (range.location != NSNotFound) {
                        NSString*a2=  [tmp substringWithRange:NSMakeRange(0,range.location)];
                        if ([LhLocationModel shareLocationModel].isLocationError) {
                            
                            NSString*msg =  [Utility distanceBetweenOrderBy:[a2 doubleValue] :[a1 doubleValue] :[LhLocationModel shareLocationModel].curUserLocation.latitude :[LhLocationModel shareLocationModel].curUserLocation.longitude];
                            locationLabel.text = [NSString stringWithFormat:@"%@(%@)",locationLabel.text,msg];
                        }else{
                            
                            locationLabel.text = [NSString stringWithFormat:@"%@",locationLabel.text];
                        }
                    }
                    
            }
            
            [locationLabel sizeToFit];
        }
    }
        
        routeStr = [NSString stringWithFormat:@"%ld人参与",(long)[dict intValue:@"peoples"]];
        routeAtrStr = [[[NSMutableAttributedString alloc] initWithString:routeStr] autorelease];
        range = [routeStr rangeOfString:[NSString stringWithFormat:@"%ld",(long)[dict intValue:@"peoples"]]];
        [routeAtrStr setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]} range:range];
        peoplesLabel.attributedText = routeAtrStr;
        NSArray *types = [dict objectForKey:@"zhuti"];//类型暂时不能超过三个
        for (int i = 0; i < 3; i++) {
            if (i < types.count) {
                NSString*msg = [types[i]objectForKey:@"value"];
                if (msg) {
                    typesLabel[i].text = [msg substringWithRange:NSMakeRange(0,msg.length > 2 ?2:msg.length)];
                    typesLabel[i].hidden = NO;
                }
                
            }else{
                typesLabel[i].hidden = YES;
            }
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%ld元/人",(long)[dict intValue:@"price"]];
        priceLabel.text = priceStr;
    });
    
}

-(UILabel *)createLabelWithText:(NSString *)text
                       fontSize:(CGFloat)fontSize
                          point:(CGPoint)point
                      textColor:(UIColor *)textColor
                        bgColor:(UIColor *)bgColor
                           size:(CGSize)size
                  isCycleCorner:(BOOL)isCycleCorner{
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    if (bgColor) {
        label.backgroundColor = bgColor;
    }else{
        label.backgroundColor = [UIColor clearColor];
    }
    label.font = [UIFont systemFontOfSize:fontSize];
    
    //如果width设定，则以width为准
    CGRect labelRect = {point,size};
    label.frame = labelRect;
    label.textAlignment = NSTextAlignmentLeft;
    
    label.text = text;
    label.textColor = textColor;
    if (isCycleCorner) {
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = CGRectGetHeight(label.frame)/2.0;
    }
    return label;
}

#pragma mark scroll滑动回调
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    flagStop = YES;
    TakePlayView*order =   (TakePlayView*)self.delegate;
    [order cellWillBeginDecelerating:self];
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%ld",(long)self.row]];
    scrollView.tag = self.row;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    flagStop = NO;
    TakePlayView*order =   (TakePlayView*)self.delegate;
    [order.posDict removeAllObjects];
    [order.posDict setObject:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] forKey:[NSString stringWithFormat:@"%ld",(long)scrollView.tag]];
}
#pragma mark 手势点击
-(void)handleSingleTap:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(takePlayCellDidSelected:)]) {
        [_delegate takePlayCellDidSelected:self.row];
    }
}

#pragma mark 动画
-(void)resetAni{
    [self.scroll setContentOffset:CGPointZero animated:YES];
}
-(void)resetOff{
    if (self.delegate) {
        TakePlayView*order =   (TakePlayView*)self.delegate;
        float value = [order.posDict floatValue:[NSString stringWithFormat:@"%ld",(long)self.row] default:10000];
        if (value >= 10000) {
            [self.scroll setContentOffset:CGPointZero animated:NO];
        }else{
            self.scroll.contentOffset = CGPointMake(value, 0);
        }
    }else{
        self.scroll.contentOffset = CGPointZero;
    }
}

-(void)dealloc{
    [super dealloc];
}
@end
