#import "IpadBaseView.h"
@implementation IpadBaseView
-(id)initWithFrame:(CGRect)frame input:(NSDictionary*)input{
    self.inputDict = input;
    [super initWithFrame: frame];
    self.backgroundColor = [UIColor grayColor];
    return self;
}

@end
