//
//  AppDelegate.h
//  etonkids-iphone
//
//  Created by wpf on 1/10/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//
//aaaaaa
//bbbbbb


/**
 *	@file   AppDelegate
 *  @brief  应用程序委托
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WXApi.h"
#import "BPush.h"
#import "EKRequest.h"

#import "ETCustomAlertView.h"
#import "ETBottomNavigationController.h"
#import "Reachability.h"
@class ETLoginViewController;
#define SHARED_APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@class LeveyTabBarController,ETBottomViewController;

/// 应用程序委托
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,EKProtocol,ETCustomAlertViewDelegate>
{
  
    //   enum WXScene _scene;
   // UITabBarController *leveyTabBarController;
//    ETLoginViewController *loginViewController;
    Reachability *reachabiltiy;
    

    
}

/// 推送通知 设备token.
@property(nonatomic,retain)NSString *token;

/// 主窗口.
@property (strong, nonatomic) UIWindow *window;

/// 登录页面.
@property (nonatomic, retain) ETLoginViewController *loginViewController;

@property (nonatomic, retain) ETBottomNavigationController *bottomNav;
@property (nonatomic, retain) ETBottomViewController *bottomVC;
@property (nonatomic, retain) NSString *pushMsg;
@property (nonatomic, retain) NSDate *enterBackDate;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign)NetworkStatus networkStatus;


/**
 *	检查版本更新.
 */
-(void)CheckVersion;
-(BOOL)isConnectNetwork;
- (void)bind;

@end

