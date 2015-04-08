
#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "NetDefine.h"
#import "JsonData.h"
#import "StringMsgDefine.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "NSObject+SBJson.h"

@class ASIHTTPRequest;
@class ASINetworkQueue;
@class ASIFormDataRequest;
@class JsonData;

@interface DownloadModel : NSObject{
    ASINetworkQueue *networkQueue;
    
}
@property(nonatomic,retain)  NSMutableDictionary* requestsDict;
- (ASIHTTPRequest*)downloadImage:(id)delegate url:(NSString*)fullUrl tag:(int)tag validator:(id)validator;
- (ASIHTTPRequest*)downloadVoice:(id)delegate url:(NSString*)fullUrl tag:(int)tag validator:(id)validator;


+ (void)setUserAgent:(NSString *)newUserAgent;
+ (DownloadModel*)sharedDownloadModel;
+(void)deleteRequest:(ASIHTTPRequest*)request;
-(BOOL)hdEnsurePath:(NSString*)path;
@end

