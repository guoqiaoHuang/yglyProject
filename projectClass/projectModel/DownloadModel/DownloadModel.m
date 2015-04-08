#import "DownloadModel.h"
#import "UtilityExt.h"
#define API_REQUEST     0
#define IMG_REQUEST     1
#define VOICE_REQUEST   2
@interface DownloadModel (Private)

- (void)dataRequestSuccessed:(ASIHTTPRequest *)request;
- (void)dataRequestFailed:(ASIHTTPRequest *)request;
- (void)fileDownloaded:(NSDictionary*)userInfo forType:(NSInteger)fileType url:(NSString*)url;
@end

static NSString *userAgent;
static DownloadModel *shareDownloadModel = nil;
@implementation DownloadModel
@synthesize requestsDict;
+ (void)setUserAgent:(NSString *)newUserAgent {
    if (userAgent == nil) {
        userAgent = [newUserAgent copy];
    } else if (userAgent != newUserAgent) {
        [userAgent release];
        userAgent = [newUserAgent copy];
    }
    
}
+ (DownloadModel*)sharedDownloadModel{
    if (!shareDownloadModel){
		shareDownloadModel = [[DownloadModel alloc] init];
        shareDownloadModel.requestsDict = [NSMutableDictionary dictionaryWithCapacity:100];
	}
	return shareDownloadModel;
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


- (ASIHTTPRequest*)downloadFile:(id)delegate url:(NSString*)fullUrl tag:(int)tag validator:(id)validator fileType:(NSInteger)type {
    
    
    NSString*wifi =  [[NSUserDefaults standardUserDefaults] objectForKey:@"yglyProjectwifi"];
    if (wifi && [wifi isEqualToString:@"1"]) {
        BOOL flag = [[Reachability reachabilityForInternetConnection] isReachableViaWiFi];
        if (!flag) {//非WiFi下停止下载
            return nil;
        }
    }
    NSString*turl = [Utility hdGetFullUrl :fullUrl];
    NSURL *url = [NSURL URLWithString:turl];
    NSString *path = [Utility getUrlPath:turl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES){
        return nil;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUserAgent:userAgent];
    [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithNonretainedObject:delegate], path, [NSNumber numberWithInt:tag], [NSValue valueWithNonretainedObject:validator], nil] forKeys:[NSArray arrayWithObjects:@"delegate", @"path", @"tag", @"validator", nil]]];
    [request setTag:type];         //1代表图片访问, 2代表声音访问
    [request setDownloadDestinationPath:path];//自定义临时存储路径
    [request setTimeOutSeconds:30];
    [request setAllowResumeForFileDownloads:YES];//断点续传
    [request setTemporaryFileDownloadPath:[path stringByDeletingPathExtension]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    [networkQueue addOperation:request];
    if ([networkQueue requestsCount] == 1) {
        [networkQueue go];
    }
    NSMutableDictionary*dict = [[DownloadModel sharedDownloadModel].requestsDict objectForKey:[NSString stringWithFormat:@"%@",url]];
    if (dict) {
        ASIHTTPRequest *terquest = [dict objectForKey:@"request"];
        [terquest clearDelegatesAndCancel];
        terquest= nil;
        NSMutableArray*array = [dict objectForKey:@"delegates"];
        if (!array) {
             array = [NSMutableArray arrayWithCapacity:3];
        }
        [array addObject:delegate];
        [dict setObject:array forKey:@"delegates"];//代理数组
        [dict setObject:request forKey:@"request"];//下载对象
    }else{
        dict = [NSMutableDictionary dictionaryWithCapacity:3];
        [dict setObject:request forKey:@"request"];//下载对象
        NSMutableArray*array = [NSMutableArray arrayWithCapacity:3];
        [array addObject:delegate];
        [dict setObject:array forKey:@"delegates"];//代理数组
    }
    [[DownloadModel sharedDownloadModel].requestsDict setObject:dict forKey:[NSString stringWithFormat:@"%@",url]];
    return request;
}
- (ASIHTTPRequest*)downloadImage:(id)delegate url:(NSString*)fullUrl tag:(int)tag validator:(id)validator {
   return  [self downloadFile:delegate url:fullUrl tag:tag validator:validator fileType:IMG_REQUEST];
}

- (ASIHTTPRequest*)downloadVoice:(id)delegate url:(NSString*)fullUrl tag:(int)tag validator:(id)validator {
   return [self downloadFile:delegate url:fullUrl tag:tag validator:validator fileType:VOICE_REQUEST];
}

- (void)dataRequestSuccessed:(ASIHTTPRequest *)request {
    if (request.tag == IMG_REQUEST || request.tag == VOICE_REQUEST) { //图片访问
        NSDictionary *dict = request.userInfo;
        NSString*url = [NSString stringWithFormat:@"%@",request.url];
        [self fileDownloaded:dict forType:request.tag url:url];
        [[DownloadModel sharedDownloadModel].requestsDict removeObjectForKey:url];
        return;
    }
}

- (void)dataRequestFailed:(ASIHTTPRequest *)request {
    NSString*url = [NSString stringWithFormat:@"%@",request.url];
    [[DownloadModel sharedDownloadModel].requestsDict removeObjectForKey:url];
}

+(void)deleteRequest:(ASIHTTPRequest*)request{
    if(!request){
        return ;
    }
    EBLog(@"url:%@",request.url);
    [request clearDelegatesAndCancel];
    NSString*url = [NSString stringWithFormat:@"%@",request.url];
     NSMutableDictionary*dic = [[DownloadModel sharedDownloadModel].requestsDict objectForKey:url];
    if([[dic objectForKey:@"request"] isEqual:request]){
        [[DownloadModel sharedDownloadModel].requestsDict removeObjectForKey:url];//删除下载队形与代理
    }else{//删除代理
        NSMutableArray*array = [dic objectForKey:@"delegates"];
        id delegate = [request.userInfo objectForKey:@"delegate"];
        int i = 0;
        for (id del in array) {
            if ([del isEqual:delegate]) {
                [array removeObjectAtIndex:i];
                return;
            }
            i++;
        }
    }
    
}

- (void)fileDownloaded:(NSDictionary*)userInfo forType:(NSInteger)fileType url:(NSString*)url{
    SEL sel = nil;
    if (fileType == IMG_REQUEST)
        sel = @selector(didImageDownloaded:url:);
    else if (fileType == VOICE_REQUEST)
        sel = @selector(didVoiceDownloaded:url:);
    
    NSString*path = [userInfo objectForKey:@"path"];
    
    NSMutableDictionary*dic = [[DownloadModel sharedDownloadModel].requestsDict objectForKey:url];
    NSMutableArray*array = [dic objectForKey:@"delegates"];
    for (id delegate in array) {
        if ([delegate respondsToSelector:sel]) {
            NSMethodSignature *sig = [delegate methodSignatureForSelector:sel];
            if (sig) {
                NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
                [invo setTarget:delegate];
                [invo setSelector:sel];
                [invo setArgument:&path atIndex:2];
                [invo setArgument:&url atIndex:3];
                [invo invoke];
            }
        }

    }
}



-(BOOL)hdEnsurePath:(NSString*)path{
    if ([path length] == 0)
        return FALSE;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        NSString* parentPath = [path stringByDeletingLastPathComponent];
        if ([self hdEnsurePath:parentPath]) {
            NSError* error = nil;
            return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        } else {
            return FALSE;
        }
    }
    return TRUE;
}


@end
