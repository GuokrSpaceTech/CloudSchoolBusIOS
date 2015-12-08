//
//  AppDelegate.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/4.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)makeLoginViewController;
-(void)makeMainViewController;
@end

