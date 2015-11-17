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
@interface CBTabbarViewController ()

@end

@implementation CBTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CBFindTableViewController * findVC = [[CBFindTableViewController alloc]init];
    UINavigationController * findNav = [[UINavigationController alloc]initWithRootViewController:findVC];
    findNav.tabBarItem.title = @"发现";
    
    TeacherViewController * teacherVC = [[TeacherViewController alloc]init];
    UINavigationController * teacherNav = [[UINavigationController alloc]initWithRootViewController:teacherVC];
    teacherNav.tabBarItem.title = @"班级教师";
    CBHobbyViewController * hobbyVC = [[CBHobbyViewController alloc]init];
    UINavigationController * hobbyNav = [[UINavigationController alloc]initWithRootViewController:hobbyVC];
    hobbyNav.tabBarItem.title = @"兴趣爱好";
    CBMineViewController * mineVC = [[CBMineViewController alloc]initWithNibName:@"CBMineViewController" bundle:nil];
    UINavigationController * mainNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    mainNav.tabBarItem.title = @"我的";
    
    NSArray * arr = @[findNav,teacherNav,hobbyNav,mainNav];
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
