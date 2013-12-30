//
//  GKLoaderManager.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-21.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKLoaderManager.h"
#import "GKAppDelegate.h"

#import "GKUserLogin.h"
#import "GKFindWraper.h"
static GKLoaderManager *manager=nil;
@implementation GKLoaderManager
@synthesize upArr;

+(GKLoaderManager *)createLoaderManager
{
    if(manager==nil)
    {
        manager=[[GKLoaderManager alloc]init];
    }
    
    return manager;
}
-(void)addNewPicToCoreData:(NSString *)path name:(NSString *)name iSloading:(NSNumber *)isUploading nameId:(NSString *)nameId studentId:(NSString *)std time:(NSNumber *)time fsize:(NSNumber *)fize classID:(NSNumber *)classid intro:(NSString *)intro data:(NSData *)imageData
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    NSLog(@"?????????????????%@",nameId);
    UpLoader *aa=[self getOneData:nameId];
    
    if(aa!=nil && [aa.nameID isEqualToString:nameId])
    {
        return;
    }
    NSString *imageName=[NSString stringWithFormat:@"%@_%@_%@",user.classInfo.uid,time,fize];
    GKAppDelegate *delegate=APPDELEGATE;
    UpLoader *upLoader= [NSEntityDescription insertNewObjectForEntityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
    upLoader.image=path;
    upLoader.nameID=nameId;
    upLoader.classUid=classid;
    upLoader.name=imageName;
    upLoader.studentId=std;
    upLoader.fsize=fize;
    upLoader.ftime=time;
    upLoader.introduce=intro;
  
    upLoader.isUploading=[NSNumber numberWithInt:UPLOADING];
    
    upLoader.smallImage=imageData;
    NSError *err;
    [delegate.managedObjectContext save:&err];
    
   // NSLog(@"%@",[err description]);
    
    
    
}
-(NSArray *)getAllUploaderPhotoFromCoreData
{
    GKAppDelegate *delegate=APPDELEGATE;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
 
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];

    NSError *err=nil;
    NSArray *arr=[delegate.managedObjectContext executeFetchRequest:request error:&err];
    [request release];
    return arr;

}
-(void)getLoadingPicFromCoreData
{
    
    if(upArr==nil)
        upArr=[[NSMutableArray alloc]init];
    else
        [upArr removeAllObjects];
    
    GKAppDelegate *delegate=APPDELEGATE;
    

    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(isUploading = %@)",[NSNumber numberWithInt:UPLOADING]];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSError *err=nil;
    NSArray *arr=[delegate.managedObjectContext executeFetchRequest:request error:&err];
    [request release];
    
    
    for (int i=0; i<[arr count]; i++) {
        UpLoader *loader=[arr objectAtIndex:i];
        
        GKUpWraper *wraper=[[GKUpWraper alloc]init];
        
        
        wraper.name=loader.name;
        wraper.isUploading=loader.isUploading;
        wraper.path=loader.image;
        wraper.nameid=loader.nameID;
        wraper.tid=loader.studentId;
        wraper.intro=loader.introduce;
        wraper.time=loader.ftime;
        wraper.fize=loader.fsize;
        wraper.classid=loader.classUid;
        wraper.imageData=loader.smallImage;
        [upArr addObject:wraper];
        [GKFindWraper addUpWrapper:wraper Key:loader.nameID];
 
        
       //
//        
//        [[GKUpQueue creatQueue] addRequestToQueue:loader.image name:loader.name nameid:loader.nameID studentid:loader.studentId time:loader.ftime fize:loader.fsize classID:loader.classUid];
        

        [[GKUpQueue creatQueue]addRequestToQueue:wraper.path name:wraper.name nameid:wraper.nameid studentid:wraper.tid time:wraper.time fize:wraper.fize classID:wraper.classid intro:wraper.intro];
        [wraper release];
    }
    
    
  
  //  [self startUpLoader];
    
}
-(UpLoader *)getOneData:(NSString *)strId
{
    GKAppDelegate *delegate=APPDELEGATE;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(nameID = %@)",strId];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSError *err=nil;
    NSArray *arr=[delegate.managedObjectContext executeFetchRequest:request error:&err];
    [request release];
    if(arr==nil || [arr count]==0)
        return nil;
    return [arr objectAtIndex:0];

}
-(void)addWraperToArr:(NSString *)path name:(NSString *)name iSloading:(NSNumber *)isUploading nameId:(NSString *)nameId studentId:(NSString *)tid time:(NSNumber *)time fsize:(NSNumber *)fize classID:(NSNumber *)classid intro:(NSString *)intro data:(NSData *)imageData
{
    if([GKFindWraper getBookWrapper:nameId]==nil)
    {
        GKUserLogin *user=[GKUserLogin currentLogin];
        NSString *imageName=[NSString stringWithFormat:@"%@_%@_%@",user.classInfo.uid,time,fize];
        
        GKUpWraper *wraper=[[GKUpWraper alloc]init];
        wraper.name=imageName;
        wraper.isUploading=isUploading;
        wraper.path=path;
        wraper.nameid=nameId;
        wraper.tid=tid;
        wraper.time=time;
        wraper.fize=fize;
        wraper.classid=classid;
        wraper.intro=intro;
        wraper.imageData=imageData;
        [upArr addObject:wraper];
        [wraper release];
        [GKFindWraper addUpWrapper:wraper Key:nameId];
        

        [[GKUpQueue creatQueue]addRequestToQueue:wraper.path name:wraper.name nameid:wraper.nameid studentid:wraper.tid time:wraper.time fize:wraper.fize classID:wraper.classid intro:wraper.intro];
       // [[GKUpQueue creatQueue] addRequestToQueue:path name:imageName nameid:nameId studentid:tid time:time fize:fize classID:classid];
        
        
        // path name  nameId tid time fize classid
        
    }
    

   // [self startUpLoader];

}

-(void)toTail:(NSString *)key
{
    GKUpWraper *wraper=[GKFindWraper getBookWrapper:key];
 
    if(wraper!=nil)
    {
         wraper.isUploading=[NSNumber numberWithInteger:1];
        [upArr removeObject:wraper];
        [upArr addObject:wraper];
       
    }
}
-(void)changeCoreDataLoadingState:(NSString *)nameid
{
    GKAppDelegate *delegate=APPDELEGATE;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpLoader" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(nameID = %@)",nameid];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:pred];
    NSError *err=nil;
    NSArray *arr=[delegate.managedObjectContext executeFetchRequest:request error:&err];
    [request release];
    
    for (int i=0; i<[arr count]; i++) {
        UpLoader *loader=[arr objectAtIndex:i];
        loader.isUploading=[NSNumber numberWithInt:UPDOWN]; // 下载完成
    }
    [delegate.managedObjectContext save:&err];


}

-(void)removeWraperFromArr:(NSString *)key
{
    GKUpWraper *wraper=[GKFindWraper getBookWrapper:key];
    if(wraper!=nil)
    {
            [upArr removeObject:wraper];
            [GKFindWraper RemoveBookWrapperForKey:key];

    }

}
-(void)start
{
    [self startUpLoader];
    
    
}
-(void)setQueueStop
{
    [[[GKUpQueue creatQueue] queue] cancelAllOperations];
}
-(void)setQueueStart
{
    //[[[GKUpQueue creatQueue] queue] cancelAllOperations];
    
    for (int i=0; i<[upArr count]; i++) {
        GKUpWraper *wraper=[upArr objectAtIndex:i];
        [[GKUpQueue creatQueue]   addRequestToQueue:wraper.path name:wraper.name   nameid:wraper.nameid studentid:wraper.tid time:wraper.time   fize:wraper.fize classID:wraper.classid intro:wraper.intro];

    }
    
    
}

-(NSString *)fileName
{
    
    int a=arc4random()%1000;
    
    NSDate *date=[NSDate date];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    
    NSLog(@"%f",time);
    
    return [NSString stringWithFormat:@"%d%d",(int)time,a];
    
    
}
-(void)startUpLoader
{
    if([upArr count]==0)
        return;
//
//   
//    
    GKUpWraper *wraper=[upArr objectAtIndex:0];
    NSLog(@"???????%@~~~~~~~~~~~~",wraper.isUploading);
    if([wraper.isUploading integerValue]!=10)
    {
        wraper.isUploading=[NSNumber numberWithInt:10];
        [[GKUpQueue creatQueue]   addRequestToQueue:wraper.path name:wraper.name   nameid:wraper.nameid studentid:wraper.tid time:wraper.time   fize:wraper.fize classID:wraper.classid intro:wraper.intro];
    }
    
    
    
    
   

    


}



@end
