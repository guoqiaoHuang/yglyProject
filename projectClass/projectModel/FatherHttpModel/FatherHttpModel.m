#import "FatherHttpModel.h"
#import "LhdatabasePublic.h"
#import "DataRequestTimerRecord.h"
@implementation ASIFormDataRequest (Lh)
-(NSMutableArray*)getPostData{
    return postData;
}
@end
#define API_REQUEST     0
#define IMG_REQUEST     1
#define VOICE_REQUEST   2
@interface FatherHttpModel (Private)

- (void)dataRequestSuccessed:(ASIHTTPRequest *)request;
- (void)dataRequestFailed:(ASIHTTPRequest *)request;
- (void)dispatchSuccessed:(NSDictionary*)data forApi:(NSString*)api;
- (void)dispatchFailed:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)api;
@end

static NSString *userAgent;

@implementation FatherHttpModel

+ (void)setUserAgent:(NSString *)newUserAgent {
    if (userAgent == nil) {
        userAgent = [newUserAgent copy];
    } else if (userAgent != newUserAgent) {
        [userAgent release];
        userAgent = [newUserAgent copy];
    }
}

-(id) init {
    self = [super init];
    if (self) {
        networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue reset];
        [networkQueue setDownloadProgressDelegate:self];
        [networkQueue setRequestDidFinishSelector:@selector(dataRequestSuccessed:)];
        [networkQueue setRequestDidFailSelector:@selector(dataRequestFailed:)];
        [networkQueue setShouldCancelAllRequestsOnFailure:NO];//防止一个请求失败，导致其它的请求都失败
        [networkQueue setDelegate:self];
    }
    return self;
}


- (void)dealloc {
    [networkQueue cancelAllOperations];
    [networkQueue reset];
    [networkQueue release];
    [super dealloc];
}



- (ASIFormDataRequest*)beginRequest:(NSString*)api baseUrl:(NSString*)baseUrl {
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:api]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setUserAgent:userAgent];
    [request setUserInfo:[NSDictionary dictionaryWithObject:api forKey:@"api"]];
    [request setTag:API_REQUEST];         //0代表api访问
    [request setTimeOutSeconds:20];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    [request setPostValue:api forKey:@"lh_api_url"];
    return request;    
}

- (ASIFormDataRequest*)beginRequest:(NSString*)api {
    return [self beginRequest:api baseUrl:CONNECTION_SITE];
}

- (void)endRequest:(ASIFormDataRequest*)request {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:request.userInfo];
    [userInfo setObject:[NSString stringWithFormat:@"%@",[[NSDate date] description]] forKey:@"uniqueAPI"];
    [request setUserInfo:userInfo];
//    [[DataRequestTimerRecord sharedDataRequestTimerRecord] beginRequestTimeWithApi:userInfo[@"api"] uniqueAPI:userInfo[@"uniqueAPI"]];
    EBLog(@"PostData:%@",[request getPostData]);
    [networkQueue addOperation:request];
    if ([networkQueue requestsCount] == 1) {
        [networkQueue go];
    }
}



- (void)dataRequestSuccessed:(ASIFormDataRequest *)request {
    
//    [request setPostValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"endapptime"];
    
    EBLog(@"PostData:%@",[request getPostData]);
    EBLog(@"PostData:%@",[request responseString]);
    NSString *api = [request.userInfo objectForKey:@"api"];
//    [[DataRequestTimerRecord sharedDataRequestTimerRecord] endRequestTimeWithApi:api uniqueAPI:request.userInfo[@"uniqueAPI"]];
    JsonData *jsonData = [[[JsonData alloc] initWithString:[request responseString]] autorelease];
    NSInteger code = [jsonData intValue:@"code" default:-1];
    NSLog(@"api: %@",api);
    NSLog(@"data: %@",jsonData.node);
    if (code == 0) {
        NSDictionary *data = [jsonData dictValue:@"data"];
        [self dispatchSuccessed:data forApi:api];
        //存储优先级别不用太高。
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //缓存数据插入
            if ([LhdatabasePublic getNoInsertApi:api]) {
                NSString*value = [data JSONRepresentation];
                NSString*key  = [Utility md5:[NSString stringWithFormat:@"%@",[request getPostData]]];
                [LhdatabasePublic InsertHttpCache:key value:value];
            }
        });
        
    }
    else {
        NSString*key  = [Utility md5:[NSString stringWithFormat:@"%@",[request getPostData]]];
        NSDictionary* dict = [LhdatabasePublic getHttpCacheValue:key];
        if (dict) {
            EBLog(@"%@",dict);
            [self dispatchSuccessed:dict forApi:api];
        }else{
             NSString *msg;
            if (jsonData.valid){
                msg = [jsonData strValue:@"msg" default:nil];
            }else{
                msg = @"系统错误";
            }
            NSLog(@"error_msg: %@",msg);
            [self dispatchFailed:code withMsg:msg forApi:api];
        }
        
    }
}

- (void)dataRequestFailed:(ASIFormDataRequest *)request {
    //缓存数据读取
    
    NSString *api = [request.userInfo objectForKey:@"api"];
    if ([LhdatabasePublic getNoInsertApi:api]) {
        NSString*key  = [Utility md5:[NSString stringWithFormat:@"%@",[request getPostData]]];
        NSDictionary* dict = [LhdatabasePublic getHttpCacheValue:key];
        if (dict) {
            EBLog(@"%@",dict);
            [self dispatchSuccessed:dict forApi:api];
        }else{
            NSString *api = [request.userInfo objectForKey:@"api"];
            [self dispatchFailed:(-1) withMsg:@"网络访问异常" forApi:api];
        }
    }else {
        NSString *api = [request.userInfo objectForKey:@"api"];
        [self dispatchFailed:(-1) withMsg:@"网络访问异常" forApi:api];
    }

}

- (void)dispatchSuccessed:(NSDictionary*)data forApi:(NSString*)api {
}
- (void)dispatchFailed:(NSInteger)errNo withMsg:(NSString*)msg forApi:(NSString*)api {
}



@end
