//
//  ETChangeGestureViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETChangeGestureViewController.h"
#import "ETKids.h"

@interface ETChangeGestureViewController ()

@end

@implementation ETChangeGestureViewController
@synthesize firstPwd;

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
    
    self.view.backgroundColor = [UIColor blackColor];
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"SetGesturePassword", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *dotImgV = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 10 - 2 + (i/3)*(4 + 6),
                                                                             75 + (i%3)*(4 + 6) + (ios7 ? 20 : 0),
                                                                             4,
                                                                             4)];
        dotImgV.backgroundColor = [UIColor whiteColor];
        dotImgV.tag = 333 + i;
        [self.view addSubview:dotImgV];
        [dotImgV release];
    }
    
    
    tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + 70 + (ios7 ? 20 : 0), 320, 30)];
    tLabel.text = LOCAL(@"drawlock", @"");
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:tLabel];
    [tLabel release];
    
    ETLockView *lockV = [[ETLockView alloc] initWithFrame:CGRectMake(0, 460 - 270 + (ios7 ? 20 : 0), 250, 250)];
    lockV.center = CGPointMake(160, 310);
    lockV.delegate = self;
    [self.view addSubview:lockV];
    [lockV release];
    
//    NSLog(@"%f",self.view.frame.size.height);
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, (iphone5 ? 548 : 460) - 30 + (ios7 ? 20 : 0), 320, 30)];
//    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
//    [button setTitle:LOCAL(@"forgetGesture", @"") forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(forgetGesPwd:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setDot:(NSString *)str
{
    for (int i = 0; i < str.length; i++) {
        char a = [str characterAtIndex:i];
        NSString *s = [NSString stringWithFormat:@"%c",a];
        UIImageView *dot = (UIImageView *)[self.view viewWithTag:(333 + s.intValue)];
        if (dot != nil) {
            dot.backgroundColor = [UIColor redColor];
        }
    }
    
}

- (void)clearDot
{
    for (int i = 0; i < 9; i++) {
        UIImageView *dot = (UIImageView *)[self.view viewWithTag:(333 + i)];
        if (dot != nil) {
            dot.backgroundColor = [UIColor whiteColor];
        }
    }
}


- (void)gesturePassword:(NSString *)pwd
{
    
    if (pwd.length < 4) {
        tLabel.text = LOCAL(@"drawAlert", @"");
        return;
    }
    
    
    if (firstPwd == nil) {
        self.firstPwd = [NSString stringWithFormat:@"%@",pwd];
        [self setDot:self.firstPwd];
        tLabel.text = LOCAL(@"reDraw", @"");
    }
    else
    {
        if ([firstPwd isEqualToString:pwd])
        {
            // 设置成功. 保存在userdefault
            tLabel.text = LOCAL(@"settingSuccess", @"");

            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"setgessuccess", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            [self performSelector:@selector(leftButtonClick:) withObject:nil afterDelay:1.0f];
            
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:self.firstPwd forKey:GESTUREPASSWORD];
            [userdefault setObject:@"1" forKey:SWITHGESTURE];
            
        }
        else
        {
            tLabel.text = LOCAL(@"differentDraw", @"");
            // 提示两次手势不一致 重新设置.
            
            self.firstPwd = nil;
            [self clearDot];
        }
    }
}

- (void)forgetGesPwd:(UIButton *)sender
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"forgetGesMsg", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"reLogin", @""), nil];
    [alert show];
}
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 1) {
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault removeObjectForKey:GESTUREPASSWORD];
        [userdefault setObject:@"0" forKey:SWITHGESTURE];
        // 退出登录.
    }
}


- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.firstPwd = nil;
    [super dealloc];
}

@end
