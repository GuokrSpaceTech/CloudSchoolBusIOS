//
//  ETSettingsViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-24.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETSettingsViewController.h"
#import "ETSettingView.h"

@interface ETSettingsViewController ()

@end

@implementation ETSettingsViewController

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
    
    ETSettingView *sv = [[ETSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) - 46 - 57)];
    [self.view addSubview:sv];
    [sv release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
