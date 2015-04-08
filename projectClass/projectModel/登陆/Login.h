#import <Foundation/Foundation.h>

typedef enum
{
    UserLogin,//用户注册登录
    SinaLogin,//新浪登录
}LoginType;


@protocol LoginDelegate <NSObject>
@optional
-(void)afterLoginRefreshView;//登录之后 更新界面
-(void)afterLogoutRefreshView;//注销 之后 更新界面

@end

@interface Login : NSObject{

}
@property (nonatomic,assign)id<LoginDelegate>delegate;
@property (assign,nonatomic)LoginType loginType;
+(void)SinaLogin;
+(void)Logout;
+(Login *)defaultController;
@end
