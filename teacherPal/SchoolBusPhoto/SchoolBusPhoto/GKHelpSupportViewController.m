//
//  GKHelpSupportViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-9.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKHelpSupportViewController.h"
#import "KKNavigationController.h"
@interface GKHelpSupportViewController ()

@end

@implementation GKHelpSupportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height - navigationView.frame.size.height-navigationView.frame.origin.y)];
    bgView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:bgView];
    [bgView release];
    
    titlelabel.text=NSLocalizedString(@"helpSupport", @"");
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttom setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];

	// Do any additional setup after loading the view.
}
-(void)leftClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES
     ];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
