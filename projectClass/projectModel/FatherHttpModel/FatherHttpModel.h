
#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "NetDefine.h"
#import "JsonData.h"
#import "StringMsgDefine.h"
#import "LhNSDictionary.h"
#import "Utility.h"
#import "NSObject+SBJson.h"

@interface ASIFormDataRequest (Lh)
-(NSMutableArray*)getPostData;
@end
@class ASIHTTPRequest;
@class ASINetworkQueue;
@class ASIFormDataRequest;
@class JsonData;

/*******************************************************************************
* 描述:
* 1. Model类是所有界面数据访问和数据管理的基类，如有需要可子类化Model，并定义其特定的方法
* 2. Model类的实例一般属于ViewController，并伴随ViewController的生命周期而存在，但也可以定义全局存在的Model实例
* 3. 可以通过addDelegate向Model增加一个观察者对象，这样每次网络数据响应时会自动回调到观察者自己的处理函数
* 4. Model网络事件的响应流程
*    a. 当收到网络成功消息时，首先调用子类的didReceiveData处理函数，如该函数返回TRUE，则代表Model的子
        类自己处理了网络数据，这时根据api的名字自动通知观察者，如users/login会自动通知观察者apiUsersLoginSuccessed。
     b. 如果观察者没有定义对应的api的回调事件，则会检查观察者的apiSuccessed函数，如存在则调用此函数
     c. 如果Model的didReceiveData不存在或返回FALSE，则代表Model或其子类没有处理网络数据，这时如果观察者定义
        了didReceiveData，则会自动通知观察者
     d. 网络接受失败时，遵从类似的过程

* 示例: 如调用api为users/login，则流程为
* 1. 检查Model子类的didReceiveData，如返回FALSE，则再检查观察者的didReceiveData（调用完成即代表本次过程全
* 原型定义参考：
  Model子类可定义的方法
  - (BOOL)didReceiveData:(JsonData*)data forApi:(NSString*)api;   观察者中的该事件可以把返回值定义为void

  观察者定义的方法
  - (void)apiUsersLoginSuccessed:(id)sender;
  - (void)apiUsersLoginFailed:(NSNumber*)errNo withMsg:(NSString*)msg;
  - (void)apiSuccessed:(id)sender forApi:(NSString*)api; 
  - (void)apiFailed:(NSNumber*)errNo withMsg:(NSString*)msg;

*******************************************************************************/

@interface FatherHttpModel : NSObject{
    ASINetworkQueue *networkQueue;
}

- (ASIFormDataRequest*)beginRequest:(NSString*)api baseUrl:(NSString*)baseUrl;
- (ASIFormDataRequest*)beginRequest:(NSString*)api;
- (void)endRequest:(ASIFormDataRequest*)request;
@end

