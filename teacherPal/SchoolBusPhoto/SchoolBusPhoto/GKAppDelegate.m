//
//  GKAppDelegate.m
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import "GKAppDelegate.h"
#import "GKUserLogin.h"
#import "GKUpQueue.h"
#import "GKLoaderManager.h"

#import "MobClick.h"
@implementation GKAppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    self.loginVC=nil;
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize loginVC;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [MobClick startWithAppkey:@"537436b256240ba278017fc3" reportPolicy:SEND_INTERVAL   channelId:@""];
    
     if(ios7) {
             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    

//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:CURRENTVERSION];
    loginVC=[[GKLoginViewController alloc]initWithNibName:@"GKLoginViewController" bundle:nil];
    self.window.rootViewController=loginVC;

    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
   
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    

//    _hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
//    [_hostReach startNotifier];

    [self CheckVersion];
    //[UIApplication sharedApplication].statusBarStyle= UIStatusBarStyleLightContent;
    
    Reachability *reachability=[[Reachability reachabilityWithHostName:@"www.yunxiaoche.com"] retain];
    
    [reachability startNotifier];
    
 
    

//[[EKRequest Instance]EKHTTPRequest:schoolstudent parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"machine", nil] requestMethod:GET forDelegate:self];
    
//[[EKRequest Instance]EKHTTPRequest:schoolcheck parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"007805026cb6",@"machine", nil] requestMethod:GET forDelegate:self];

    
    //[[EKRequest Instance]EKHTTPRequest:schoolad parameters:nil requestMethod:GET forDelegate:self];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationDidEnterBackground{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    //得到当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    //一个后台任务标识符
    UIBackgroundTaskIdentifier taskID = 0;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        //如果系统觉得我们还是运行了;太久，将执行这个程序块，并停止运行应用程序
        NSLog(@"自动停止");
        [app endBackgroundTask:taskID];
    }];
    //UIBackgroundTaskInvalid表示系统没有为我们提供额外的时候
    if (taskID == UIBackgroundTaskInvalid) {
        NSLog(@"Failed to start background task!");
        return;
    }
    //告诉系统我们完成了
    [app endBackgroundTask:taskID];
}
-(BOOL)connectedToNetWork
{
    
    NetworkStatus networkStatus;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Reachability* hostReach = [Reachability reachabilityWithHostName:@"www.yunxiaoche.com"];
    networkStatus = [hostReach currentReachabilityStatus];
    [pool release];
    
    return networkStatus;
    
}

- (void)reachabilityChanged:(NSNotification *)note
{

    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status==NotReachable)
    {
        
            [[GKLoaderManager createLoaderManager] setQueueStop];
     
        
    }
    if(status==ReachableViaWiFi)
    {

        
            if([[[GKUpQueue creatQueue] asiQueue] operationCount]==0)
            {
                [[GKLoaderManager createLoaderManager] setQueueStart];
            }
            
           // [[GKLoaderManager createLoaderManager] setQueueStart];
        
        
    }
    if(status==ReachableViaWWAN)
    {
        
        if([[[GKUpQueue creatQueue] asiQueue] operationCount]==0)
        {
            [[GKLoaderManager createLoaderManager] setQueueStart];
        }
    }
    
    
}
-(void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSLog(@"%@",deviceToken);
   // NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
  //  self.token = [[deviceToken description] stringByTrimmingCharactersInSet:angleBrackets];
    [BPush registerDeviceToken: deviceToken];
    //self.token=[[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
    

    
}
- (void)bind
{
    [BPush bindChannel];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:
(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
    //self.token = @"";
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~%@", userInfo);
    
    application.applicationIconBadgeNumber = 0;
    
    //NSString *pushStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"key"]];
    [BPush handleNotification:userInfo];
    
  //  NSNotification *noti=[NSNotification notificationWithName:@"UPDATEDATA" object:pushStr];
  //  [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    user.badgeNumber=[NSNumber numberWithInt:[user.badgeNumber integerValue]+1];
    NSUserDefaults *defaultuser=[NSUserDefaults standardUserDefaults];
    [defaultuser setObject:user.badgeNumber forKey:@"BADGE"];
    
}
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [NSDictionary dictionaryWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
       // NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
       // NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            //            self.viewController.appidText.text = appid;
            //            self.viewController.useridText.text = userid;
            //            self.viewController.channelidText.text = channelid;
            //
            //            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            //            self.appId = appid;
            //            self.channelId = channelid;
            //            self.userId = userid;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"type",userid,@"userid",channelid,@"channelid", nil];
            [[EKRequest Instance] EKHTTPRequest:push parameters:param requestMethod:POST forDelegate:self];
            
            
            
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            //            self.viewController.appidText.text = nil;
            //            self.viewController.useridText.text = nil;
            //            self.viewController.channelidText.text = nil;
        }
    }
    
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    //NSLog(@"%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
//    
    //NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    //NSLog(@"%@",dic);
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{}

-(void)CheckVersion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //"Lang"="2";
        NSString *str= NSLocalizedString(@"Lang", @"");
        NSURL * url=nil;
        if([str isEqualToString:@"1"])
        {
            url=[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=751056893"];
        }
        if([str isEqualToString:@"2"])
        {
            url=[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=751056893&country=cn"];
        }
        // NSURL * url=[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=600413820"];
        
        NSData *data=  [NSData dataWithContentsOfURL:url];
        // NSString *string=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data)
            {
                NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                // NSLog(@"dic=%@",dic);
                
                NSArray * array=[dic objectForKey:@"results"];
                if ([array count]==0||array==nil) {
                    return;
                }
                NSString * verson=[[array objectAtIndex:0]objectForKey:@"version"];
                NSString *releaseNode=nil;
                releaseNode=[[array objectAtIndex:0]objectForKey:@"releaseNotes"];
                if(releaseNode==nil)
                    releaseNode=[[array objectAtIndex:0]objectForKey:@"description"];
                // NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                
                //NSRange range=[verson rangeOfString:currentVersion];
                
                if(![verson isEqualToString:currentVersion])
                {
                    //if()
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"versionUp", @"版本升级") message:releaseNode delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"shengji", @""), nil];
                    alert.delegate=self;
                    alert.tag=1100;
                    [alert show];
                    [alert release];
                    
                }
                
                
            }
            
        });
        // [self performSelectorOnMainThread:@selector(uploadUI:) withObject:string waitUntilDone:YES];
        // [string release];
        
        
    });
    // NSURL * url=[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=600478283"];
    // [self performSelectorInBackground:@selector(checkVersion:) withObject:url];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1100)
    {
        if(buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/yun-zhong-xiao-che-jiao-shi/id751056893?ls=1&mt=8"]];
        }
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    NSString * badge=[user objectForKey:@"BADGE"];
    
    if(badge==nil)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=[badge integerValue];
   // -(void)applicationDidEnterBackground{
    [self applicationDidEnterBackground];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //@"ACTIVEPHOTO"
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"ACTIVEPHOTO" object:nil];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SchoolBusPhoto" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SchoolBusPhoto.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }    
//    
//    return _persistentStoreCoordinator;
//}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SchoolBusPhoto.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // handle db upgrade
   // NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                          //   [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                          //   [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
