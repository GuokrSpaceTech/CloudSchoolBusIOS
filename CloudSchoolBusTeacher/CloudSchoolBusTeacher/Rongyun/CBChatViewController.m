//
//  CBChatViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/18.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBChatViewController.h"

@interface CBChatViewController ()

@end

@implementation CBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavigationTitle:@"dd" textColor:[UIColor blackColor]];
    [self setNavigationTitle:@"会话" textColor:[UIColor blackColor]];
    
    // 自定义导航左右按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
    [leftButton setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // 自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    [rightButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
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
