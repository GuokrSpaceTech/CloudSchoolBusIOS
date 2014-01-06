//
//  ETBottomNavigationController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETBottomNavigationController.h"

@interface ETBottomNavigationController ()

@end

@implementation ETBottomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return NO;
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
////    self.topViewController.supportedInterfaceOrientations
//    return UIInterfaceOrientationPortrait;
//}

@end
