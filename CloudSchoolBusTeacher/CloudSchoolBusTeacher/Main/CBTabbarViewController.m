//
//  CBTabbarViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "AppDelegate.h"
#import "CBTabbarViewController.h"
#import "CBMineViewController.h"
#import "CBFindTableViewController.h"
#import "TeacherViewController.h"
#import "OperationCollectionViewController.h"
#import "ContactGroupTableViewController.h"
#import "UIColor+RCColor.h"
#import "BaseNavigationController.h"
#import "CBDateBase.h"
#import "UITabBar+CustomBadge.h"
#import "RYMessage.h"

@interface CBTabbarViewController ()
{
    CBFindTableViewController * findVC;
    UINavigationController *mineNav;
    CBMineViewController * mineVC;
}

@end

@implementation CBTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = appDelegate;
    
    self.tabBar.tintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
    
    findVC = [[CBFindTableViewController alloc]init];

    UIImage *image = [UIImage imageNamed:@"explore_unselected"];
    UIImage *selectedImage = [UIImage imageNamed:@"explore"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findVC.tabBarItem.image = image;
    findVC.tabBarItem.selectedImage = selectedImage;
    findVC.tabBarItem.title = @"发现";

    ContactGroupTableViewController * contactGroupVC = [[ContactGroupTableViewController alloc]initWithNibName:@"ContactGroupTableViewController" bundle:nil];
    contactGroupVC.tabBarItem.image = [[UIImage imageNamed:@"contact_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactGroupVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"contact"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactGroupVC.tabBarItem.title = @"联系人";
    
    OperationCollectionViewController *operationVC = [[OperationCollectionViewController alloc]initWithNibName:@"OperationCollectionViewController" bundle:nil];
    image = [[UIImage imageNamed:@"hobby_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    selectedImage = [[UIImage imageNamed:@"hobby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    operationVC.tabBarItem.image = image;
    operationVC.tabBarItem.selectedImage = selectedImage;
    operationVC.tabBarItem.title = @"班务";
    
     mineVC = [[CBMineViewController alloc]initWithNibName:@"CBMineViewController" bundle:nil];
    image = [[UIImage imageNamed:@"me_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.image = image;
    mineVC.tabBarItem.selectedImage = selectedImage;
    mineVC.tabBarItem.title = @"我";
    
    self.tabBar.translucent = NO;

    mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    UINavigationController *operationNav = [[UINavigationController alloc] initWithRootViewController:operationVC];
    UINavigationController *teacherNav = [[UINavigationController alloc] initWithRootViewController:contactGroupVC];
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:findVC];
    NSArray *arr = @[findNav,operationNav,teacherNav,mineNav];
    
    //Change the background color and tile color
    for(int i=0; i<[arr count]; i++)
    {
        UINavigationController *nav = arr[i];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            // iOS 6.1 or earlier
            nav.navigationBar.tintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
        } else {
            // iOS 7.0 or later
            nav.navigationBar.barTintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
            nav.navigationBar.translucent = NO;
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        }
    }
    
    //init the tab
    self.viewControllers = arr;
    
    //Register Uploading Receiver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRedDot:) name:@"uploading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRedDot:) name:@"MESSAGETEACHER" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
#pragma mark == TabBarController delegate
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //取消红点
    if (tabBarController.selectedIndex == 3 || tabBarController.selectedIndex == 2) {
        [self.tabBar setBadgeStyle:(kCustomBadgeStyleNone) value:1 atIndex:3];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addRedDot:(NSNotification *)notifcation
{
    [self.tabBar setTabIconWidth:29];
    [self.tabBar setBadgeTop:9];
    
    //融云消息
    if([notifcation.object isKindOfClass:[RYMessage class]])
    {
        [self.tabBar setBadgeStyle:(kCustomBadgeStyleRedDot) value:1 atIndex:2];
    }
    //照片上传通知
    else
    {
        [self.tabBar setBadgeStyle:(kCustomBadgeStyleRedDot) value:1 atIndex:3];
        mineVC.isUploadingNotifying = true;
    }
}

@end
