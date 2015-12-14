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
#import "CBFindTableViewController.h"
#import "CBDateBase.h"
#import "CBLoginInfo.h"
#import "CB.h"
#import "RCIM.h"
#import "RCIMClient.h"
#import "RCTextMessage.h"
#import "RYMessage.h"
#import "MessageState.h"
@interface AppDelegate ()<RCIMReceiveMessageDelegate>
{
    CBTabbarViewController *main;
}
@end

@implementation AppDelegate
-(void)didReceivedMessage:(RCMessage*)message left:(int)left
{
    if(message.conversationType == ConversationType_PRIVATE && message.messageDirection == MessageDirection_RECEIVE)
    {
        //发送者id
        NSString * senderid = [NSString stringWithFormat:@"%@",message.senderUserId];
        NSString * sendertime = [NSString stringWithFormat:@"%lld",message.sentTime];
        //[senderid isKindOfClass:<#(__unsafe_unretained Class)#>]
        NSString * objType = @"";
        NSString * content = @"";
        if([message.objectName isEqualToString:@"RC:TxtMsg"])
        {
            objType = @"txt";
            RCTextMessage * obj =(RCTextMessage *)message.content;
            content = obj.content;
        }
        else if([message.objectName isEqualToString:@"RC:ImgMsg"])
        {
            objType = @"pic";
            content = @"图片";
        }
        else if([message.objectName isEqualToString:@"RC:VcMsg"])
        {
             content = @"语音";
        }
        else if([message.objectName isEqualToString:@"RC:LBSMsg"])
        {
            content = @"位置消息";
        }
        else
        {
            content = @"其他";
        }
        
        RYMessage * message = [[RYMessage alloc]init];
        message.senderid = senderid;
        message.sendertime = sendertime;
        message.messagetype = objType;
        message.messagecontent = content;
        message.isRead = NO;
        //[MessageState addObjectToArr:message];
       // [[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGETEACHER" object:nil];
        CBLoginInfo * info = [CBLoginInfo shareInstance];
        if(info.teacherVCIsLoading) // teacher页面已加载 并且有教师信息
        {
            // 直接发通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGETEACHER" object:message];
        }
        else
        {
            [MessageState addObjectToArr:message];
        }
    }
}

-(void)makeMainViewController
{
    // 连接融云服务器
    [[CBLoginInfo shareInstance] connectRongYun];
    main = [[CBTabbarViewController alloc] init];
    self.window.rootViewController = main;
    
}
-(void)makeLoginViewController
{

    CBLoginViewController * loginVC = [[CBLoginViewController alloc]initWithNibName:@"CBLoginViewController" bundle:nil];
    UINavigationController * logginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = logginNav;
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
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    [[CBDateBase sharedDatabase] selectFormTableLoginInfo];
    
    CBLoginInfo *info = [CBLoginInfo shareInstance];
    
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

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"Selected INDEX OF TAB-BAR ==> %i", tabBarController.selectedIndex);
    
    //First Tab
    if (tabBarController.selectedIndex == 0) {
        UINavigationController *nav = (UINavigationController *)viewController;
        CBFindTableViewController *findVC = [[nav viewControllers] objectAtIndex:0];
        if(findVC)
        {
            if([findVC respondsToSelector:@selector(selectAllMessages)])
            {
                [findVC selectAllMessages];
            }
        }
    }
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
