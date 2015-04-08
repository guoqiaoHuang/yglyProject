#import "ProjectPositionTransformation.h"
#import "Utility.h"

@implementation ProjectPositionTransformation

#pragma mark 我的.begin
+(CGPoint)getMyViewPhotoPos{
    return CGPointMake(132, 35);
}
#pragma mark 我的.end

#pragma 所有的尺寸或者坐标均为像素（px）
+(CGPoint)getMyProjectPoint:(CGPoint)point{
    
    point.x = [ProjectPositionTransformation getMyProjectFloat:point.x];
    point.y = [ProjectPositionTransformation getMyProjectFloat:point.y];
    return point;
}
+(CGSize)getMyProjectSize:(CGSize)size{
    
    return [Utility getSize:size];
}
+(CGFloat)getMyProjectFloat:(CGFloat)aFloat{
    
    return aFloat * [Utility getNode].sizeSacle;
}
+(CGRect)getMyProjectRect:(CGRect)rect all:(BOOL)all{
    
    CGPoint origin = CGPointZero;
    if (all) {
        origin = [ProjectPositionTransformation getMyProjectPoint:rect.origin];
    }
    
    CGSize  size  = [ProjectPositionTransformation getMyProjectSize:rect.size];
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

@end
