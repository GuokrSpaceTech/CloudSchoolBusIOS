//
//  AppDelegate.m
//  etonkids-iphone
//
//  Created by wpf on 1/10/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "AppDelegate.h"
#import "ETBottomViewController.h"
#import "JSON.h"
#import "ETGestureCheckViewController.h"
#import "ETLoginViewController.h"
#import "ETCustomAlertView.h"
#import "MobClick.h"
#import "ETCommonClass.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "AlixPayResult.h"

//#import "DataSigner.h"
//#import "DataVerifier.h"
//#import "PartnerConfig.h"

#import "GKPersionalViewController.h"
@implementation AppDelegate

@synthesize token,bottomNav,bottomVC,loginViewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize pushMsg,networkStatus;

- (void)dealloc
{
    [_window release];
    self.token=nil;
   
    [super dealloc];
}
-(void)netWorkChanged:(NSNotification *)no
{
    Reachability* curReach = [no object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    networkStatus = [curReach currentReachabilityStatus];
    
    
    switch (networkStatus) {
        case NotReachable:
        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case ReachableViaWWAN:
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"当前为3G 网络" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        }
            
        default:
            break;
    }
}

-(BOOL)isConnectNetwork
{
    NetworkStatus state;
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    
    Reachability *reach= [Reachability reachabilityWithHostName:@"www.yunxiaoche.com"];
    state=[reach currentReachabilityStatus];
    
    [pool drain];
    if(state==NotReachable)
    {
        return NO;
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalAlipay:) name:@"PERSIONALALIPAY" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChanged:) name:kReachabilityChangedNotification object:nil];
    
    reachabiltiy=[[Reachability reachabilityWithHostName:@"www.yunxiaoche.com"] retain];
    [reachabiltiy startNotifier];
    
    [MobClick startWithAppkey:@"53a150c056240b8a53094d52" reportPolicy:SEND_INTERVAL   channelId:@""];
    [MobClick setAppVersion:@"3.4.6"];

    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if (![userdefault objectForKey:SWITHGESTURE]) { // 设置页面手势密码开关   默认关闭
        [userdefault setObject:@"0" forKey:SWITHGESTURE];
    }


    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];

    //application.applicationIconBadgeNumber = 0;
    
#ifdef __IPHONE_8_0
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
         [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }


#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif



    //向微信注册
    [WXApi registerApp:@"wx2376a8ec446b2086"];
    
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"---------------------------- %@", dictionary);
        }
       // application.applicationIconBadgeNumber = 0;
       
        if ([dictionary objectForKey:@"key"])
        {   //如果存在类型 赋值
            self.pushMsg = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"key"]];
        }
        else
        {
            //如果不存在
            self.pushMsg = nil;
        }
    }

    loginViewController=[[ETLoginViewController alloc] init];
    self.window.rootViewController = loginViewController;
    //[loginViewController release];
    


    
    NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"auto  %@",[defaultUser objectForKey:AUTOLOGIN]);
    
    UserLogin *user = [UserLogin currentLogin];
    
    if ([defaultUser objectForKey:AUTOLOGIN] && [user getLastLogin])
    {
       UserLogin *userLogin= [ETCoreDataManager cachedUser:user.regName withPass:user.passWord andStudent:user.uid_student];

       if(userLogin!=nil)
       {
           ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
           [com requestLoginWithComplete:^(NSError *err){
               //[[EKRequest Instance] EKHTTPRequest:notice parameters:param requestMethod:POST forDelegate:self];
           }];
           
           [self performSelector:@selector(presentBottom) withObject:nil afterDelay:0.00];
       }

    }


    [self.window makeKeyAndVisible];

    [self CheckVersion];
    

    
    return YES;
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.

}
#endif
-(void)personalAlipay:(NSNotification *)no
{
    if([[self.bottomNav topViewController] isKindOfClass:[GKPersionalViewController class]])
    {
        return;
    }
    GKPersionalViewController *VC=[[GKPersionalViewController alloc]init];
    
    [self.bottomNav pushViewController:VC animated:YES];
}
- (void)presentBottom
{
    ETBottomViewController *bVC = [[ETBottomViewController alloc] init];
    self.bottomVC = bVC;
    [bVC release];
    
    ETBottomNavigationController *bNC = [[ETBottomNavigationController alloc] initWithRootViewController:self.bottomVC];
    self.bottomNav = bNC;
    [bNC release];
    
    
   // [loginViewController presentModalViewController:self.bottomNav animated:NO];
    [loginViewController presentViewController:self.bottomNav animated:NO completion:^{
        
    }];
    
    
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"1"])
    {
        ETGestureCheckViewController *gcVC = [[ETGestureCheckViewController alloc] init];
      //  [self.bottomVC presentModalViewController:gcVC animated:YES];
        [self.bottomVC presentViewController:gcVC animated:YES completion:^{
            
        }];
        [gcVC release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADBADGE" object:nil];
    
    
    // 根据推送参数 改变页面显示
    if (self.pushMsg != nil)
    {
        NSNotification *noti=[NSNotification notificationWithName:@"UPDATEDATA" object:self.pushMsg];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    
    
}

-(void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@",deviceToken);
    NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    self.token = [[deviceToken description] stringByTrimmingCharactersInSet:angleBrackets];
    [BPush registerDeviceToken: deviceToken];
    //self.token=[[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    //[BPush bindChannel];
    
}
- (void)bind
{
    [BPush bindChannel];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:
(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
    self.token = @"";
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~%@", userInfo);
    
 //   application.applicationIconBadgeNumber = 0;
    
    NSString *pushStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"key"]];
    [BPush handleNotification:userInfo];
 
    NSNotification *noti=[NSNotification notificationWithName:@"UPDATEDATA" object:pushStr];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"%@",url);
    
    NSString *string =[url absoluteString];
    if([string hasPrefix:@"yunxiaocheparent"])
    {
       //  [self parse:url application:application];
        return YES;
    }
    else
    {
       return  [WXApi handleOpenURL:url delegate:self];
   
    }
    
    return  YES;
   
   
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//       NSLog(@"%@",url);
//    return  [WXApi handleOpenURL:url delegate:self];
//}
-(void) onReq:(BaseReq*)req
{
    NSLog(@"strmsg : %@",req);
}
-(void) onResp:(BaseResp*)resp
{
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *dic=[notification userInfo];
    
    NSString *name=[dic objectForKey:@"birthday"];
    NSString *meg=[NSString stringWithFormat:@"宝宝%@的生日",name];
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:@"生日快乐" message:meg delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];

    [alert show];
   // [ETAlert showAlert:name];
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
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
    
    [res release];
    
}
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    NSLog(@"push error : %@",error);
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{

    if (method == push) {
        
        if (code == 1) {
            NSLog(@"push response %@",response);
        }
        
    }
    if(method==student)
    {
         UserLogin *user=[UserLogin currentLogin];
        if(code==1)
        {
            user.isStudentInterface=YES;
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            user.chunyuisopen=[NSString stringWithFormat:@"%@",[dic objectForKey:@"chunyuisopen"]];
            user.chunyuendtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"chunyu_endtime"]];

        }
        else
        {
            user.isStudentInterface=NO;
        }
    }
    
}
-(void)CheckVersion
{
    NSURL * url=[NSURL URLWithString:LOCAL(@"checkversion",@"")];
    [self performSelectorInBackground:@selector(checkVersion:) withObject:url];
}

-(void)uploadUI:(id)value
{
 
    NSDictionary * dic =[value JSONValue];
   // NSLog(@"dic=%@",dic);
    
    NSArray * array=[dic objectForKey:@"results"];
    if ([array count]==0||array==nil) {
        return;
    }
    NSString * verson=[[array objectAtIndex:0]objectForKey:@"version"];
    NSString *releaseNode=[[array objectAtIndex:0]objectForKey:@"releaseNotes"];
   // NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//    NSRange range=[verson rangeOfString:currentVersion];
    
    if(![verson isEqualToString:currentVersion])
    {
        ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"Check New Version", @"提示") message:releaseNode delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"shengji", @""), nil];
        alert.delegate=self;
        alert.tag=1100;
        [alert show];
        
    }
    
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(alertView.tag==1100)
    {
        if(index == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/yun-zhong-xiao-che-jia-zhang/id600478283?mt=8"]];
        }
    }
    
}

-(void)checkVersion:(id)value
{
    NSData *data=  [NSData dataWithContentsOfURL:value];
    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self performSelectorOnMainThread:@selector(uploadUI:) withObject:string waitUntilDone:YES];
    [string release];
    
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
//    NSLog(@"111111111");
    self.enterBackDate = [NSDate date];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.enterBackDate = [NSDate date];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber=0;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADBADGE" object:nil];
    
    int delta = [self.enterBackDate timeIntervalSinceNow];
//    NSLog(@"%d",delta);
    if (ABS(delta) >= 2*60) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if ([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"1"])
        {
            ETGestureCheckViewController *gcVC = [[ETGestureCheckViewController alloc] init];
         //   [self.bottomVC presentModalViewController:gcVC animated:YES];
            [self.bottomVC presentViewController:gcVC animated:YES completion:^{
                
            }];
            [gcVC release];
        }
    }
    
    self.enterBackDate = nil;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADBADGE" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEBIRTHDAY" object:nil];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"terminate");
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"etonkids-iphone" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Etonkids.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

//- (NetworkStatus)connectedToNetwork
//{
//    NetworkStatus networkStatus;
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    Reachability* hostReach = [Reachability reachabilityWithHostName:ListionBooksServer];
//    networkStatus = [hostReach currentReachabilityStatus];
//    [pool release];
//    
//    return networkStatus;
//}




//result = {
//    memo = "";
//    result = "partner=\"2088511416723811\"&seller_id=\"guokr@mac-top.mobi\"&out_trade_no=\"k7TADjWxHw5fDgB\"&subject=\"\U533b\U751f\U54a8\U8be2\U670d\U52a1\"&body=\"\U533b\U751f\U54a8\U8be2\"&total_fee=\"0.01\"&notify_url=\"http%3A%2F%2Fwww.yunxiaoche.com%2Falpay%2Fnotify_url.php\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"UbOMiykR0L/RdOl4fpQK3JKJYRL7tceFRZ7yNny6tsZ+lHSLv+u1PIsf4j1oovpv2hWjPIOQ2j5nSCpOCpeuV59xNICi67ss0DRS/3JpUgMkz/xS5FL+zy9NtOaztOStu1ul5oEhQUkU6VndIcj4aNxonxXLqZM3p6FS16IOBuw=\"";
//    resultStatus = 9000;
//}

//2014-12-24 19:07:43.810 etonkids-iphone[2362:266264] result = {
//    memo = "\U7528\U6237\U4e2d\U9014\U53d6\U6d88";
//    result = "";
//    resultStatus = 6001;
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             
             NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
             if([resultStatus isEqualToString:@"9000"])
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 [alert release];
             }
             else
             {
                 NSString *result=[resultDic objectForKey:@"result"];
                 NSString *result1=[resultDic objectForKey:@"memo"];
                 
                 NSLog(@"%@--%@",result,result1);
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:result1 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 [alert release];
     
             }
         }];
    }
    
    return YES;
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)loadchunyu
{
    [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
}


@end
