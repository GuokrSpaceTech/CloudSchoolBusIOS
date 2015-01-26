//
//  ETdefaultViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-2.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETdefaultViewController.h"
#import "ETKids.h"
#import "Modify.h"

@interface ETdefaultViewController ()

@end

@implementation ETdefaultViewController
@synthesize image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
       [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13+ (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"Background",@"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
     

    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT+ (ios7 ? 20 : 0), self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.backgroundColor=CELLCOLOR;
    [self.view  addSubview:scrollview];
    [scrollview release];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"006.png",@"002.png",@"003.png",@"004.png",@"005.png",@"001.png",@"007.png",@"008.png",@"009.png",@"010.png",@"011.png",@"012.png", nil];
    
    for (int i = 0; i < 11; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 999 + i;
        [btn setFrame:CGRectMake(20 + (80 + 20) * (i % 3), 20 + (80 + 20) * (i / 3), 80, 80)];
        [btn setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        
    }
    
    
    
    mark = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mark.image = [UIImage imageNamed:@"backgroundkeyselect.png"];
    [scrollview addSubview:mark];
    [mark release];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *obj = [userDefault objectForKey:@"HEADERBACKGROUND"];
    
    
    if (![obj isEqualToString:@"-1"])
    {
        
        NSString *num = (NSString *)obj;
        int n = num.intValue;
        mark.hidden = NO;
        [mark setFrame:CGRectMake(20 + (80 + 20) * (n % 3), 20 + (80 + 20) * (n / 3), 20, 20)];
    }
    else
    {
        mark.hidden = YES;
    }
    
    
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doSelect:(UIButton *)sender
{

    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
        
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",sender.tag%999],@"skinid", nil];
    [[EKRequest Instance] EKHTTPRequest:skinid parameters:param requestMethod:POST forDelegate:self];
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (method == skinid && code == 1)
    {
        mark.hidden = NO;
        
        NSString *num = [param objectForKey:@"skinid"];
        
        UIButton *sender = (UIButton *)[scrollview viewWithTag:(999 + num.intValue)];
        
        [mark setFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 20, 20)];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:num forKey:@"HEADERBACKGROUND"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEBACKGROUND" object:nil];
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"success", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
    [alert show];
}

-(void)leftButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    self.image = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    return NO;
}




@end
