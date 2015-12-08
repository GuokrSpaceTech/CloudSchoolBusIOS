//
//  IWNavigationController.m
//  01-ItcastWeibo
//
//  Created by apple on 14-1-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "BaseNavigationController.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
/**
 *  初始化（每一个类只会调用一次）
 */
//+ (void)initialize
//{
//    
//    // 1.获得bar对象
//    UINavigationBar *navBar = [UINavigationBar appearance];
//
////navBar.barTintColor = kNbg;
////    navBar.barTintColor = kNbg;
//    
//
////    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav"]];
////    [navBar insertSubview:imageview atIndex:0];
//
////    UIImage *image = [UIImage imageNamed:@"navigationBar.png"];
////    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//
//    
//    UIImage *image = [UIImage imageNamed:@"navigationBar.png"];
//    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//
//    
////    navBar.layer.contents=(id)[UIImage imageNamed:@"nav.png"].CGImage;
////    navBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBar.png"]];
//    
//
//    // 3.设置文字样式
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    //    attrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
//    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
//    [navBar setTitleTextAttributes:attrs];
//    
//    // 4.设置导航栏按钮的主题
//    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
//    
//    // 6.设置按钮的文字样式
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    //    itemAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
//    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
//}

-(void)viewDidLoad {
    // 1.获得bar对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.barTintColor = [UIColor orangeColor];;

    // 3.设置文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    attrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [navBar setTitleTextAttributes:attrs];
    
    // 4.设置导航栏按钮的主题
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    // 6.设置按钮的文字样式
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    itemAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
}




@end
