//
//  ETVerifyViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-29.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETVerifyViewController.h"
#import "ETKids.h"
#import "ETVerifyPasswordViewController.h"
#import "UserLogin.h"
#import "ETCoreDataManager.h"
#import "ETCommonClass.h"

@interface ETVerifyViewController ()

@end

@implementation ETVerifyViewController
@synthesize mobile,key,timer,isChangeBind,isForgetPwd;

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
    if (isChangeBind)
    {
        middleLabel.text = LOCAL(@"bindmobile", @"");
    }
    else
    {
        if (isForgetPwd)
        {
            middleLabel.text = LOCAL(@"forgotpwdtitle", @"");
        }
        else
        {
            middleLabel.text = LOCAL(@"bindmobile", @"");
        }
        
    }
    
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    verifyTF.placeholder = LOCAL(@"mssageverify", @"");
    
    tishiLabel.text = [NSString stringWithFormat:LOCAL(@"tishiverify", @""),self.mobile] ;
    
    countTime = 180;
    
    sendAgain.hidden = YES;
    [sendAgain setTitle:LOCAL(@"sendTitle", @"") forState:UIControlStateNormal];
    [sendAgain setTitle:LOCAL(@"sendTitle", @"") forState:UIControlStateHighlighted];
    
    [nextButton setTitle:LOCAL(@"next", @"") forState:UIControlStateNormal];
    [nextButton setTitle:LOCAL(@"next", @"") forState:UIControlStateHighlighted];
    
    countdownLab.text = [NSString stringWithFormat:LOCAL(@"countdown", @""),countTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    
}

- (IBAction)doClickCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)countdown
{
    sendAgain.hidden = YES;
    countdownLab.hidden = NO;
    
    if (countTime <= 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        sendAgain.hidden = NO;
        countdownLab.hidden = YES;
    }
    
    
    
    countdownLab.text = [NSString stringWithFormat:LOCAL(@"countdown", @""),countTime--];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tishiLabel release];
    [verifyTF release];
    [nextButton release];
    [sendAgain release];
    [countdownLab release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [tishiLabel release];
    tishiLabel = nil;
    [verifyTF release];
    verifyTF = nil;
    [nextButton release];
    nextButton = nil;
    [sendAgain release];
    sendAgain = nil;
    [countdownLab release];
    countdownLab = nil;
    
    [super viewDidUnload];
}
- (IBAction)doNext:(id)sender {
    
    if ([verifyTF.text isEqualToString:@""]) {
        
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
        
    }
    if (self.key == nil || ![self.key isEqualToString:verifyTF.text]) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"verifyerror",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    
    if (!isChangeBind)
    {
        if (isForgetPwd)
        {
            //忘记密码  去 添加新密码
            
            ETVerifyPasswordViewController *vp = [[ETVerifyPasswordViewController alloc] init];
            vp.mobile = self.mobile;
            vp.verifyCode = self.key;
//            vp.verifyCode = verifyTF.text;
            [self.navigationController pushViewController:vp animated:YES];
            [vp release];
        }
        else // 添加绑定
        {
            if(HUD==nil)
            {
                HUD=[[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:HUD];
                [HUD release];
                [HUD show:YES];
                
            }
            NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.mobile, @"mobile",self.key,@"key",nil];
            [[EKRequest Instance] EKHTTPRequest:bindTel parameters:param requestMethod:POST forDelegate:self];
        }
        
    }
    else
    {
        if(HUD==nil)
        {
            HUD=[[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:HUD];
            [HUD release];
            [HUD show:YES];
            
        }
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.mobile, @"mobile",self.key,@"key",nil];
        [[EKRequest Instance] EKHTTPRequest:bindreplace parameters:param requestMethod:POST forDelegate:self];
        
    }
    
    
    

}

- (IBAction)doSendAgain:(id)sender {
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
        
    }
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.mobile, @"mobile",nil];
    [[EKRequest Instance] EKHTTPRequest:forgetpwd parameters:param requestMethod:GET forDelegate:self];
    
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
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
        if (code == 1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"alreadySend", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            countTime = 180;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            
        }
        else if(code==-1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"手机号错误" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else if(code==-2)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"系统不存在此用户" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if(code==-3)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"插入数据库失败" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if(code==-4)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"发送短信失败" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            [self LoginFailedresult:LOCAL(@"fail",  @"信息修改失败,稍后请重试")];
        }
    }
    else if (method == bindreplace || method == bindTel)
    {
        NSString *str;
        switch (code) {
            case 1:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                str = LOCAL(@"bindsuccess", @"绑定成功");
                
                UserLogin *user = [UserLogin currentLogin];
                user.ischeck_mobile = @"1";
                user.mobile = self.mobile;
                
                [ETCoreDataManager saveUser];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEMYACCOUNT" object:nil];
                
                break;
            }
            case -1:
            {
                str = LOCAL(@"pidnull", @"pid为空");
                break;
            }
            case -2:
            {
                str = LOCAL(@"telenull", @"手机号码为空");
                break;
            }
            case -3:
            {
                str = LOCAL(@"verifynull", @"手机验证码为空");
                break;
            }
            case -4:
            {
                str = LOCAL(@"verifyerror", @"手机验证码错误或者已经使用");
                break;
            }
            case -5:
            {
                str = LOCAL(@"bindfail", @"绑定失败");
                break;
            }
                
            default:
                str = LOCAL(@"busy", @"");
                break;
                
        }
        if (str != nil) {
            ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alertview show];
        }

    }
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void)LoginFailedresult:(NSString *)str
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
