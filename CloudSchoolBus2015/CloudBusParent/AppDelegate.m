//
//  AppDelegate.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/4.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "AppDelegate.h"
#import "CBLoginViewController.h"
#import "CBTabbarViewController.h"
#import "CBDateBase.h"
#import "CBLoginInfo.h"
#import "CB.h"
#import "RCIM.h"
#import "RCIMClient.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)makeMainViewController
{
    
    CBTabbarViewController *main = [[CBTabbarViewController alloc] init];
    
    
    self.window.rootViewController = main;
    
}
-(void)makeLoginViewController
{
    CBLoginViewController * loginVC = [[CBLoginViewController alloc]initWithNibName:@"CBLoginViewController" bundle:nil];
    self.window.rootViewController = loginVC;
}
-(void)setRegisterForRemoteNotification:(UIApplication *)application
{
    if(iOS8)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [RCIM initWithAppKey:RONGCLOUND_IM_APPKEY deviceToken:nil];
    [self setRegisterForRemoteNotification:application];
    
    
    [[CBDateBase sharedDatabase]selectFormTableLoginInfo];
    
    
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    if(info.sid == nil)
    {
        //登陆页面
        info.state = LoginOff;
        [self makeLoginViewController];
    }
    else
    {
        //主页面
         info.state = LoginOn;
        [self makeMainViewController];
        
    }
    
 

    // [self makeLoginViewController];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   // [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
