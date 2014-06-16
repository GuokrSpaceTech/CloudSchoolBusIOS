//
//  ETGestureCheckViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETGestureCheckViewController.h"
#import "ETKids.h"
#import <QuartzCore/QuartzCore.h>
#import "UserLogin.h"
#import "UIImageView+WebCache.h"
#import "ETLoginViewController.h"
#import "ETCommonClass.h"

@interface ETGestureCheckViewController ()

@end

@implementation ETGestureCheckViewController

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
    if (ios7)
        [self setNeedsStatusBarAppearanceUpdate];
    
    
    UIImageView *photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    photoImageView.center = CGPointMake(160, iphone5 ? 30+60 : 60);
    photoImageView.backgroundColor=[UIColor clearColor];
    photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImageView.layer.borderWidth = 2;
    photoImageView.layer.cornerRadius = 20.0f;
    photoImageView.userInteractionEnabled=YES;
    photoImageView.layer.shouldRasterize = YES;
    photoImageView.layer.masksToBounds = YES;
    [self.view addSubview:photoImageView];
    [photoImageView release];
    
    UserLogin * user = [UserLogin currentLogin];
    [photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        photoImageView.image = image;
        
    }];
    
    
    
    tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + 70 + (iphone5 ? 30 : 0), 320, 30)];
    tLabel.text = LOCAL(@"qingshurushoushi", @"");
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textColor = [UIColor blackColor];
    tLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:tLabel];
    [tLabel release];
    
    ETLockView *lockV = [[ETLockView alloc] initWithFrame:CGRectMake(0, 460 - 290 - 15 + (iphone5 ? 30 : 0), 250, 250)];
    lockV.center = CGPointMake(160, 280 + (iphone5 ? 30 : 0));
    lockV.delegate = self;
    [self.view addSubview:lockV];
    [lockV release];
    
    //    NSLog(@"%f",self.view.frame.size.height);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, (iphone5 ? 548 : 460) - 30 + (ios7 ? 20 : 0), 320, 30)];
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [button setTitle:LOCAL(@"forgetGesture", @"") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgetGesPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    num = 5;
    
}

- (void)gesturePassword:(NSString *)pwd
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *gPwd = [userdefault objectForKey:GESTUREPASSWORD];
    
    

    
    if (gPwd == nil) {
        
        NSLog(@"手势密码为空");
        
        return;
    }
    else
    {
        if (pwd.length < 4) {
            return;
        }
        
        if ([gPwd isEqualToString:pwd])
        {
            [self dismissModalViewControllerAnimated:YES];
            
        }
        else
        {
            tLabel.textColor = [UIColor redColor];
            num-- ;
            if (num <= 0)
            {
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"errorPwdMsg", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"") otherButtonTitles:nil, nil];
                alert.tag = 888;
                [alert show];
            }
            tLabel.text = [NSString stringWithFormat:LOCAL(@"errorGesPwd", @""),num];
            // 提示两次手势不一致 重新设置.
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
    
    if (alertView.tag == 888)
    {
        if (index == 0)
        {
            //退出登录.
            
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:GESTUREPASSWORD];
            [userdefault setObject:@"0" forKey:SWITHGESTURE];
            
            [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
            
                                      
        }
    }
    else
    {
        if (index == 1) {
//            [self dismissModalViewControllerAnimated:NO];
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:GESTUREPASSWORD];
            [userdefault setObject:@"0" forKey:SWITHGESTURE];
            // 退出登录.
            
            [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
            
            
            
        }
    }
    
    
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if (method == signin && code == 1) {
        if (param == nil) {
            [self dismissModalViewControllerAnimated:NO];
            [ETCommonClass logoutAndClearUserMessage];
        }
        
    }
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return NO;
    
}

@end
