//
//  GKUpQueue.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKUpQueue.h"
#import "GKUserLogin.h"
#import "GKLoaderManager.h"
#import "GKFindWraper.h"
static GKUpQueue *gkqueue=nil;
@implementation GKUpQueue
@synthesize queue;
@synthesize isLoading;
-(id)init
{
    if(self=[super init])
    {
    
        queue=[[ASINetworkQueue alloc]init];
        [queue cancelAllOperations];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        queue.maxConcurrentOperationCount=1;
        queue.showAccurateProgress=YES;
        queue.delegate=self;
        [queue setRequestDidFailSelector:@selector(queueFail:)];
        [queue setRequestDidFinishSelector:@selector(queueFinished:)];
        isLoading=NO;
        [queue go];

        
    }
    return self;
}
+(id)creatQueue
{
    if(gkqueue==nil)
    {
        gkqueue =[[GKUpQueue alloc]init];
    }
    
    return gkqueue;
}
-(void)addRequestToQueue:(NSString *)path name:(NSString *)name nameid:(NSString *)nameId studentid:(NSString *)std time:(NSNumber *)time fize:(NSNumber *)fsize classID:(NSNumber *)classid intro:(NSString *)intro tag:(NSString *)tag
{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    isLoading=YES;
    GKUserLogin *user=[GKUserLogin currentLogin];
    NSLog(@"------%@",classid);
    //source
    GKUpWraper *wrapper=[GKFindWraper getBookWrapper:nameId];

   NSString *url=[NSString stringWithFormat:@"http://%@/source",user.upIP];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"sid" value:user._sid];
    [request addRequestHeader:@"apikey" value:@"mactoprest"];
    [request addRequestHeader:@"Version" value:CURRENTVERSION];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setDelegate:self];
    request.uploadProgressDelegate=wrapper._progressView;
    request.showAccurateProgress=YES;
    [request setNumberOfTimesToRetryOnTimeout:5];
    //NSData *imageData=[GTMBase64 ];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    //[request setdid];
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
   [request setFile:path forKey:@"fbody"];
    [request addPostValue:@"article" forKey:@"pictype"];
    //[request addPostValue:@"jpg" forKey:@"fext"];
    [request addPostValue:name forKey:@"fname"];
    [request addPostValue:std forKey:@"memberlist"];
    [request addPostValue:time forKey:@"ftime"];
    [request addPostValue:classid forKey:@"uid"];
    [request addPostValue:intro forKey:@"intro"];
    [request addPostValue:tag forKey:@"tag"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:nameId,@"nameid",path,@"path", name,@"filename",@"",@"",nil]];
    [request addPostValue:[self fileName] forKey:@"pickey"];
    
    [queue addOperation:request];
    [pool drain];

    
}

-(void)queueFinished:(ASIFormDataRequest *)request
{
    isLoading=NO;
}
-(void)queueFail:(ASIFormDataRequest *)request
{
    isLoading=NO;
}
-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    NSLog(@"%lld",bytes);
}

-(NSString *)fileName
{
    int a=arc4random()%1000;
    NSDate *date=[NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSLog(@"%f",time);
    return [NSString stringWithFormat:@"%d%d",(int)time,a];
}
-(NSNumber *)numberSize:(NSData *)data
{
    NSLog(@"%lu",(unsigned long)[data length]);
    
    float aa=[data length]/1024.0;
    
    NSLog(@"%f",aa);
    return [NSNumber numberWithFloat:aa];
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"hahahahahahahahahhahhahahahah");
}

- (void)requestDidSuccess:(ASIHTTPRequest *)request
{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
     GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
    NSLog(@"%@",request.responseHeaders);
    
    

    if([[request.responseHeaders objectForKey:@"Code"] integerValue]==1)
    {
        NSString *picId=[[request userInfo] objectForKey:@"nameid"];
        NSString *picPath=[[request userInfo] objectForKey:@"path"];
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:picId,@"key", nil];
        
        [center postNotificationName:@"changeupload" object:nil userInfo:dic];
        
        // upArr 删除下载完成的
        //改变coreData 的下载状态
        [manager changeCoreDataLoadingState:picId];
        // 删除 manager 数组第一条数据
        [manager removeWraperFromArr:picId];
        
        
        //从document中删除临时文件
        
        NSFileManager *fileManage=[NSFileManager defaultManager];
        if([fileManage fileExistsAtPath:picPath])
        {
            [fileManage removeItemAtPath:picPath error:nil];
        }
    }
 

    // 从findwraper 中删除
    
    // manager 继续下载
    
   // [manager startUpLoader];
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)_request{
    

//    NSString *picId=[[_request userInfo] objectForKey:@"nameid"];
//    
//    //UpLoader *up= [[GKLoaderManager createLoaderManager] getOneData:picId];
//   
//    GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
//    // [manager removeWraperFromArr:<#(NSString *)#>]
//    // [manager removeWraperFromArr:<#(NSString *)#>];
//    [manager toTail:picId];
//    
//    [manager startUpLoader];
//
    //    NSString *picPath=[[_request userInfo] objectForKey:@"path"];
//
//    NSString *picname=[[_request userInfo] objectForKey:@"filename"];
    
  //  [self addRequestToQueue:picPath name:picname nameid:<#(NSString *)#> studentid:<#(NSString *)#> time:<#(NSNumber *)#>];
    
}
-(void)dealloc
{
    self.queue=nil;
    [super dealloc];
}
@end
