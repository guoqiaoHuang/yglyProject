//
//  BodyModel.m
//  yglyProject
//
//  Created by 枫 on 14-10-16.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "BodyModel.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "BaseUIImageView.h"

//要添加图标 则在字典中添加一个 名为 photo 的key值
//长度会发生改变
static CGFloat lastMaxY = 0;

@implementation BodyModel

+(BodyModel *)createBodyModelWithDict:(NSDictionary *)dict frame:(CGRect)frame style:(NSInteger)style{
    
    BodyModel *model = [[[BodyModel alloc] initWithFrame:frame] autorelease];
    NSArray *keyArray = [dict allKeys];
    
    for (NSString *key in keyArray) {
        
        NSString *value = [dict strValue:key];
        [model createKeyLabel:key valueLabel:value atview:model style:style];
    }
    lastMaxY = 0;
    return model;
    
}
+(BodyModel *)createBodyModelWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    return [BodyModel createBodyModelWithDict:dict frame:frame style:0];
}

-(void)createKeyLabel:(NSString *)key
           valueLabel:(NSString *)value
               atview:(BodyModel *)view
                style:(NSInteger)style{
    
    if (style == 0 || style == 2) {
        
        //添加keylabel
        UILabel *keyLabel = [view createUILabelWithText:[NSString stringWithFormat:@"%@: ",key] fontSize:YGLY_VIEW_FLOAT(26) textColor:[UIColor blackColor] frame:CGRectMake(0, lastMaxY, MAXFLOAT, 10) style:style isKeyLabel:YES];
        [view addSubview:keyLabel];
        
        CGFloat keyLabelW = CGRectGetWidth(keyLabel.frame);
        CGFloat keyLabelMaxX = CGRectGetMaxX(keyLabel.frame);
        //添加valuelabel
        UILabel *valueLabel = [view createUILabelWithText:value fontSize:YGLY_VIEW_FLOAT(26) textColor:[Utility hexStringToColor:@"#30629a"] frame:CGRectMake(keyLabelMaxX, lastMaxY, CGRectGetWidth(self.frame) - keyLabelW, 10) style:style isKeyLabel:NO];
        [view addSubview:valueLabel];
        
        lastMaxY = MAX(CGRectGetMaxY(valueLabel.frame), CGRectGetMaxY(keyLabel.frame))  + YGLY_VIEW_FLOAT(20);
        CGRect frame = view.frame;
        frame.size.height = lastMaxY;
        view.frame = frame;
    }else if (style == 1){
        
        //添加keylabel
        UILabel *keyLabel = [view createUILabelWithText:[NSString stringWithFormat:@"%@",key] fontSize:YGLY_VIEW_FLOAT(30) textColor:[UIColor blackColor] frame:CGRectMake(0, lastMaxY, CGRectGetWidth(self.frame), 10) style:style isKeyLabel:YES];
        [view addSubview:keyLabel];
        keyLabel.text = [NSString stringWithFormat:@"%@",key];
        lastMaxY = CGRectGetMaxY(keyLabel.frame) + YGLY_VIEW_FLOAT(5);
        
        //添加valuelabel
        UILabel *valueLabel = [view createUILabelWithText:value fontSize:YGLY_VIEW_FLOAT(26) textColor:[UIColor blackColor] frame:CGRectMake(0, lastMaxY, CGRectGetWidth(self.frame), 10) style:style isKeyLabel:NO];
        [view addSubview:valueLabel];
        
        lastMaxY = CGRectGetMaxY(valueLabel.frame) + YGLY_VIEW_FLOAT(40);
        CGRect frame = view.frame;
        frame.size.height = lastMaxY;
        view.frame = frame;
    }else if (style == 3){//在最左侧多加一个图标
        
      //  UIImageView *leftImageView = [Utility getUIImageViewByName:dict[@"photo"]];
    }
}

//重新计算高度
-(UILabel*)createUILabelWithText:(NSString *)text
                        fontSize:(CGFloat)fontSize
                       textColor:(UIColor*)color
                           frame:(CGRect)frame
                           style:(NSInteger)style
                      isKeyLabel:(BOOL)isKeyLabel{
   
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    if (style == 2){
        
        if (isKeyLabel) {
            label.font = [UIFont boldSystemFontOfSize:fontSize];
        }
        label.textColor = [UIColor blackColor];
    }else if (style == 1){
        
        if (isKeyLabel) {
            label.font = [UIFont boldSystemFontOfSize:fontSize];
        }
    }
    label.text = text;
    
    //重新计算frame
    CGSize contentSize = CGSizeZero;
    contentSize = [Utility getSizeFormString:text maxW:CGRectGetWidth(label.frame) font:label.font];
    
    CGRect labelFrame = frame;
    labelFrame.size = contentSize;
    if (style == 1) {
         labelFrame.size.width = CGRectGetWidth(label.frame);
    }
    label.frame = labelFrame;
    
    return label;
}

-(void)setWithDict:(NSDictionary *)dict{
    
    NSArray *keyArray = [dict allKeys];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSString *key in keyArray) {
        
        NSString *value = [dict strValue:key];
        [self createKeyLabel:key valueLabel:value atview:self style:0];
    }
    lastMaxY = 0;
}
@end
