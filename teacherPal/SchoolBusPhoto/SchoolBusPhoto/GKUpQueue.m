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
#import "TestFlight.h"
#import "DBManager.h"
#import "GKAppDelegate.h"
#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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
-(void)removeQueueAqueuest:(NSString *)nameid
{
    for (ASIHTTPRequest *request in [queue operations]) {
        
        NSString *picId=[[request userInfo] objectForKey:@"nameid"];
        if([picId isEqualToString:nameid])
        {
            [request cancel];
        }
        

    }
}
-(void)addRequestToQueue:(NSString *)path name:(NSString *)name nameid:(NSString *)nameId studentid:(NSString *)std time:(NSNumber *)time fize:(NSNumber *)fsize classID:(NSNumber *)classid intro:(NSString *)intro tag:(NSString *)tag
{
    

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
    [request setNumberOfTimesToRetryOnTimeout:1];
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

    
    
}

-(void)queueFinished:(ASIFormDataRequest *)request
{
    isLoading=NO;
//    if([[GKLoaderManager createLoaderManager].upArr count]!=0)
//    {
//        [[GKLoaderManager createLoaderManager] setQueueStart];
//    }
 
}
-(void)queueFail:(ASIFormDataRequest *)request
{
    isLoading=NO;
//    
//    if([queue operationCount]==0)
//    {
//        [[GKLoaderManager createLoaderManager] setQueueStart];
//    }
    
    
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
   
}

- (void)requestDidSuccess:(ASIHTTPRequest *)request
{
//    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
//     GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
    
    
    
    NSLog(@"%@",request.responseHeaders);
     NSLog(@"code ----%@",[request.responseHeaders objectForKey:@"Code"]);
    NSString *picId=[[request userInfo] objectForKey:@"nameid"];
    NSString *picPath=[[request userInfo] objectForKey:@"path"];
     //  [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    
    if([[request.responseHeaders objectForKey:@"Code"] integerValue]==1)
    {
        [self ChageCoreDataDeleteOrUoloadingAlter:YES picId:picId picPath:picPath];
        
        
    }
 
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-37) //时间戳错误
    {
        NSLog(@"时间戳错误");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-40) // 图片内容空
    {
        NSLog(@"图片内容空");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-41) // base64 错误
    {
        NSLog(@"base64 错误");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-38) //fsize空
    {
        NSLog(@"fsize空");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-42) //收到的文件流与 fsize 的大小不一致
    {
        NSLog(@"收到的文件流与 fsize 的大小不一致");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-43) //生成的文件不是图片
    {
        NSLog(@"生成的文件不是图片");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else if([[request.responseHeaders objectForKey:@"Code"] integerValue]==-44) //ffmpeg没有载入
    {
        NSLog(@"ffmpeg没有载入");
         [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
    else
    {
        NSLog(@"未知错误 没有code 值");
        [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
    }
        // 从findwraper 中删除
    
    // manager 继续下载
    
   // [manager startUpLoader];
    
}
-(void)ChageCoreDataDeleteOrUoloadingAlter:(BOOL)an  picId:(NSString *)picId picPath:(NSString *)path
{
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:picId,@"key", nil];
    [center postNotificationName:@"changeupload" object:nil userInfo:dic];
    GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
    GKAppDelegate *appdelegate=APPDELEGATE;
    
   
    if(an==YES) //更改coredata 状态
    {
        // upArr 删除下载完成的
        //改变coreData 的下载状态
        
        GKUserLogin *user=[GKUserLogin currentLogin];
        
        NSFetchRequest *mRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *mEntity = [NSEntityDescription entityForName:@"MovieDraft" inManagedObjectContext:appdelegate.managedObjectContext];
        [mRequest setEntity:mEntity];
        NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(userid = %@ and moviepath = %@)",[NSString stringWithFormat:@"%@", user.classInfo.classid],path];
        [mRequest setPredicate:searchPre];
        [[DBManager shareInstance] deleteObject:mRequest success:^{
            NSLog(@"草稿箱删除成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DRAFTDELETESUCCESS" object:nil];
            
        } failed:^(NSError *err) {
            NSLog(@"草稿箱删除失败");
        }];
        
        
        
        //[manager changeCoreDataLoadingState:picId];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        NSManagedObjectContext *moContext = appdelegate.managedObjectContext;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:moContext];
        [request setEntity:entity];
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"(nameID = %@)",picId];
        request.predicate=pred;

        [[DBManager shareInstance] updateObject:^(NSManagedObject *object) {
            
            UpLoader *loader=(UpLoader *)object;
          
            loader.isUploading=[NSNumber numberWithInt:2];
            
        } request:request success:^{
            
            
        } failed:^(NSError *err){
         
        }];
        
        // 删除 manager 数组第一条数据
        [manager removeWraperFromArr:picId];
        
        
        


    }
    else // 删除上传  重新上传
    {
        // upArr 删除下载完成的
        // 删除 coredate 改条信息
        //[manager deleteCoreDataLoadingState:picId];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        NSManagedObjectContext *moContext = appdelegate.managedObjectContext;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:moContext];
        [request setEntity:entity];
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"(nameID = %@)",picId];
        request.predicate=pred;

        [[DBManager shareInstance]deleteObject:request success:^{
            
        } failed:^(NSError *err) {
            
        }];
        // 删除 manager 数组第一条数据
        [manager removeWraperFromArr:picId];
    }
    //从document中删除临时文件
    NSError *error=nil;
    NSFileManager *fileManage=[NSFileManager defaultManager];
    if([fileManage fileExistsAtPath:path])
    {
        BOOL success= [fileManage removeItemAtPath:path error:&error];
        if(!success)
        {
            NSLog(@"删除文件失败 %@",error.description);
        }
        else
        {
            NSLog(@"删除成功");
        }
    }
}
- (void)requestDidFailed:(ASIFormDataRequest *)_request{
    
    NSLog(@"%@",_request.error.description);
    NSLog(@"上传失败 ：： %@",_request.error.description);
     NSLog(@"%@",_request.responseString);
    if(_request.error.code==6) // 改文件不存在
    {
        NSString *picId=[[_request userInfo] objectForKey:@"nameid"];
        NSString *picPath=[[_request userInfo] objectForKey:@"path"];
        [self ChageCoreDataDeleteOrUoloadingAlter:NO picId:picId picPath:picPath];
        
    }

    
}
-(void)dealloc
{
    self.queue=nil;
    [super dealloc];
}
@end
