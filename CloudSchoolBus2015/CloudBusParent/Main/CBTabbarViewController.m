//
//  CBTabbarViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBTabbarViewController.h"
#import "CBMineViewController.h"
#import "CBFindTableViewController.h"
#import "TeacherViewController.h"
#import "CBHobbyViewController.h"
#import "UIColor+RCColor.h"
@interface CBTabbarViewController ()

@end

@implementation CBTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = [UIColor colorWithHexString:@"F3A139" alpha:1.0f];
    
    CBFindTableViewController * findVC = [[CBFindTableViewController alloc]init];

    UIImage *image = [UIImage imageNamed:@"explore_unselected"];
    UIImage *selectedImage = [UIImage imageNamed:@"explore"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findVC.tabBarItem.image = image;
    findVC.tabBarItem.selectedImage = selectedImage;
    findVC.tabBarItem.title = @"发现";

    TeacherViewController * teacherVC = [[TeacherViewController alloc]init];
    teacherVC.tabBarItem.image = [[UIImage imageNamed:@"contact_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    teacherVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"contact"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    teacherVC.tabBarItem.title = @"班级教师";
    
    
    CBHobbyViewController * hobbyVC = [[CBHobbyViewController alloc]init];
    image = [[UIImage imageNamed:@"hobby_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    selectedImage = [[UIImage imageNamed:@"hobby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hobbyVC.tabBarItem.image = image;
    hobbyVC.tabBarItem.selectedImage = selectedImage;
    hobbyVC.tabBarItem.title = @"兴趣爱好";
    
    
    CBMineViewController * mineVC = [[CBMineViewController alloc]initWithNibName:@"CBMineViewController" bundle:nil];
    image = [[UIImage imageNamed:@"me_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.image = image;
    mineVC.tabBarItem.selectedImage = selectedImage;
    mineVC.tabBarItem.title = @"我";
    

    UINavigationController * mainNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    UINavigationController * hobbyNav = [[UINavigationController alloc]initWithRootViewController:hobbyVC];
    UINavigationController * teacherNav = [[UINavigationController alloc]initWithRootViewController:teacherVC];
    UINavigationController * findNav = [[UINavigationController alloc]initWithRootViewController:findVC];
    NSArray * arr = @[findNav,teacherNav,hobbyNav,mainNav];
    
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
        }
    }
    
    
    
    //init the tab
    self.viewControllers = arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
