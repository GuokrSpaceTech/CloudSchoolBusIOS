//
//  ETVerifyPasswordViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-29.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETVerifyPasswordViewController.h"
#import "ETKids.h"
#import "MTAuthCode.h"
#import "ETCommonClass.h"

@interface ETVerifyPasswordViewController ()

@end

@implementation ETVerifyPasswordViewController
@synthesize verifyCode,mobile,navigationTitle;

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
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
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"forgotpwdtitle", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    newPwdTF.placeholder = LOCAL(@"Set", @"");
    confirmPwdTF.placeholder = LOCAL(@"Confirm", @"");
    [sendBtn setTitle:LOCAL(@"ok", @"") forState:UIControlStateNormal];
    

    tishiLabel.text = LOCAL(@"newpassword", @"");
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [confirmPwdTF release];
    [tishiLabel release];
    [newPwdTF release];
    [sendBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [confirmPwdTF release];
    confirmPwdTF = nil;
    [tishiLabel release];
    tishiLabel = nil;
    [newPwdTF release];
    newPwdTF = nil;
    [sendBtn release];
    sendBtn = nil;
    [super viewDidUnload];
}
- (IBAction)doSend:(id)sender {
    
    
    if ([newPwdTF.text isEqualToString:@""]) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        
        return;
    }
    if (![newPwdTF.text isEqualToString:confirmPwdTF.text]) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"diff",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        
        return;
    }
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
        
    }

    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.mobile, @"mobile",self.verifyCode,@"key",[MTAuthCode authEncode:newPwdTF.text authKey:@"mactop" expiryPeriod:0],@"password",nil];
    [[EKRequest Instance] EKHTTPRequest:forgetpwd parameters:param requestMethod:POST forDelegate:self];
    
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    NSLog(@"%d",code);
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == forgetpwd)
    {
        if (code == 1) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            NSLog(@"%@",dic);
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
        else
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)doClickCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
