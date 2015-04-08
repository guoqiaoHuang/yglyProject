

#import "BaseUIImageView.h"
@interface IpadBaseView : BaseUIImageView
@property(nonatomic,copy) NSDictionary*inputDict;//view 跳转传进来的值
-(id)initWithFrame:(CGRect)frame input:(NSDictionary*)input;
@end
