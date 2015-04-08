#import <Foundation/Foundation.h>
#import "Utility.h"

#ifndef YGLY_VIEW_FRAME
#define YGLY_VIEW_FRAME

//改变frame的坐标点和尺寸
#define YGLY_VIEW_FRAME_ALL(rect) [ProjectPositionTransformation getMyProjectRect:rect all:YES]
//只改变frame的尺寸
#define YGLY_VIEW_FRAME_ONLY_SIZE(rect) [ProjectPositionTransformation getMyProjectRect:rect all:NO]
//将所给的size转变成相应的大小
#define YGLY_VIEW_SIZE(size) [ProjectPositionTransformation getMyProjectSize:size]
#define YGLY_VIEW_POINT(point) [ProjectPositionTransformation getMyProjectPoint:point]
//只改变CGFloat的大小
#define YGLY_VIEW_FLOAT(aFloat) [ProjectPositionTransformation getMyProjectFloat:aFloat]

#define YGLY_SIZE_SCALE [Utility getNode].sizeSacle
#endif

@interface ProjectPositionTransformation : NSObject

+(CGPoint)getMyViewPhotoPos;

//---by feng----------
//所有的尺寸或者坐标均为像素（px）
+(CGPoint)getMyProjectPoint:(CGPoint)point;
+(CGSize)getMyProjectSize:(CGSize)size;
+(CGFloat)getMyProjectFloat:(CGFloat)aFloat;
+(CGRect)getMyProjectRect:(CGRect)rect all:(BOOL)all;
@end
