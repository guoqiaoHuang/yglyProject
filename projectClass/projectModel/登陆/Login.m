#import "Login.h"
#import "MMProgressHUD.h"
#import "GlobalModel.h"
@implementation Login
@synthesize loginType;
@synthesize delegate;
static Login *shareController;

+(void)Logout{
    if ([Login defaultController].loginType == SinaLogin) {
      
    }
    
}


+(Login *)defaultController
{
    @synchronized(self)
    {
        if (shareController == nil){
            shareController = [[self alloc]init];
            shareController.loginType = UserLogin;//默认注册登陆
        }
    }
    return shareController;
}

#pragma mark - 使新浪微博登录
+(void)SinaLogin{
    Login *login = [Login defaultController];
    login.loginType = SinaLogin;//新浪微博登录
    [login sinaLogin];
}



-(void)sinaLogin
{
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        NSLog(@"%d",result);
//        if (result) {
//            //成功登录后，判断该用户的ID是否在自己的数据库中。
//            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
//            [self endSuccessLogin:ShareTypeSinaWeibo userInfo:userInfo];
//        }else{
//            EBLog(@"sinaLogin:error");
//        }
//    }];
}

//-(void)endSuccessLogin:(ShareType)type userInfo:(id<ISSPlatformUser>) userInfo{
////    [MMProgressHUD showWithStatus:@"正在注册"];
////    //现实授权信息，包括授权ID、授权有效期等。
////    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
////    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
////    EBLog(@"uid:%@   token:%@  extInfo:%@  nickname:%@",[credential uid],[credential token],[credential extInfo],[userInfo nickname]);
////    //数据提交服务器 刷新本地数据 成功后回调代理
////
////    [GlobalModel sharedGameModel].loginType = [Login defaultController].loginType;
////    [MMProgressHUD dismiss];
////    if ([[Login defaultController].delegate respondsToSelector:@selector(afterLoginRefreshView)]) {
////        [[Login defaultController].delegate afterLoginRefreshView];
////    }
//}

//-(void)endfailedLogin:(ShareType)type{
//
//}

-(void)dealloc{
    [super dealloc];
}
@end
