//
//  ETGrowViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-11-8.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETGrowViewController.h"
#import "ETKids.h"
#import "ETGrowRecordViewController.h"

@interface ETGrowViewController ()

@end

@implementation ETGrowViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(doClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"chengzhangdangan", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    UIImageView *backImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backImgV.image=[UIImage imageNamed:@"growBack.png"];
    [self.view addSubview:backImgV];
    [backImgV release];
    
    UIImageView *vImgV=[[UIImageView alloc]initWithFrame:CGRectMake(30, NAVIHEIGHT + (ios7 ? 20 : 0) + 10, 50, 362)];
    vImgV.image=[UIImage imageNamed:@"growVertical.png"];
    [self.view addSubview:vImgV];
    [vImgV release];
    
    UIButton *grow01Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [grow01Btn setFrame:CGRectMake(113, 110, 135, 122)];
    [grow01Btn setImage:[UIImage imageNamed:@"grow01.png"] forState:UIControlStateNormal];
    [grow01Btn addTarget:self action:@selector(doClickGrow01:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grow01Btn];
    
    UIButton *grow02Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [grow02Btn setFrame:CGRectMake(118, 230, 135, 122)];
    [grow02Btn setImage:[UIImage imageNamed:@"grow02.png"] forState:UIControlStateNormal];
    [self.view addSubview:grow02Btn];
    
    UIButton *grow03Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [grow03Btn setFrame:CGRectMake(124, 354, 73, 83)];
    [grow03Btn setImage:[UIImage imageNamed:@"grow03.png"] forState:UIControlStateNormal];
    [self.view addSubview:grow03Btn];
    
    
    
}

- (void)doClickGrow01:(id)sender
{
    ETGrowRecordViewController *grVC = [[ETGrowRecordViewController alloc] init];
    [self.navigationController pushViewController:grVC animated:YES];
    [grVC release];
}

- (void)doClickCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
