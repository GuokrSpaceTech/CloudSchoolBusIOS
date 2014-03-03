//
//  ETChangeBindViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETChangeBindViewController.h"
#import "ETKids.h"
#import "ETVerifyViewController.h"
#import "UserLogin.h"
#import "ETCommonClass.h"
#import "ETCoreDataManager.h"

@interface ETChangeBindViewController ()

@end

@implementation ETChangeBindViewController
@synthesize key,mobile,timer;

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
    middleLabel.text = LOCAL(@"bindmobile", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
//    UserLogin *user = [UserLogin currentLogin];
//    oldMobileTF.text = user.mobile;
    
    [nextBtn setTitle:LOCAL(@"ok", @"") forState:UIControlStateNormal];
    [nextBtn setTitle:LOCAL(@"ok", @"") forState:UIControlStateHighlighted];
    
    tishiLabel1.text = LOCAL(@"change1", @"");
    tishiLabel2.text = LOCAL(@"change2", @"");
    tishiLabel3.text = LOCAL(@"change3", @"");
    
    countTime = 180;
    
    [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateNormal];
    [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateHighlighted];
    
    tishiVerify.text = LOCAL(@"qingshuruyanzhengma", @"");
    
    oldMobileTF.placeholder = LOCAL(@"placeholder1", @"");
    newMobileTF.placeholder = LOCAL(@"placeholder2", @"");
    verifyTF.placeholder = LOCAL(@"placeholder3", @"");
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     -160,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
        
    }];
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
        
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)doClickCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
    
    [tishiLabel1 release];
    [tishiLabel2 release];
    [tishiLabel3 release];
    [oldMobileTF release];
    [newMobileTF release];
    [nextBtn release];
    
//    self.popToVC = nil;
    
    [getVerifyBtn release];
    [verifyTF release];
    [tishiVerify release];
    [super dealloc];
}
- (void)viewDidUnload {
    [tishiLabel1 release];
    tishiLabel1 = nil;
    [tishiLabel2 release];
    tishiLabel2 = nil;
    [tishiLabel3 release];
    tishiLabel3 = nil;
    [oldMobileTF release];
    oldMobileTF = nil;
    [newMobileTF release];
    newMobileTF = nil;
    [nextBtn release];
    nextBtn = nil;
    [getVerifyBtn release];
    getVerifyBtn = nil;
    [verifyTF release];
    verifyTF = nil;
    [tishiVerify release];
    tishiVerify = nil;
    [super viewDidUnload];
}
- (IBAction)getVerify:(id)sender {
    if ([oldMobileTF.text isEqualToString:@""])
    {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if ([newMobileTF.text isEqualToString:@""])
    {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    UserLogin *user = [UserLogin currentLogin];
    //    oldMobileTF.text = user.mobile;
    if (![oldMobileTF.text isEqualToString:user.mobile]) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"phoneNumberError",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
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
    
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:oldMobileTF.text, @"historymobile",newMobileTF.text,@"newsmobile",nil];
    [[EKRequest Instance] EKHTTPRequest:bindreplace parameters:param requestMethod:GET forDelegate:self];
    
}

- (IBAction)doNext:(id)sender {
    
    if ([oldMobileTF.text isEqualToString:@""])
    {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if ([newMobileTF.text isEqualToString:@""])
    {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    
    if (self.key == nil || ![self.key isEqualToString:verifyTF.text]) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"verifyerror",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
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
    
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.mobile, @"mobile",self.key,@"key",nil];
    [[EKRequest Instance] EKHTTPRequest:bindreplace parameters:param requestMethod:POST forDelegate:self];
    
    
}

- (void)countdown
{
    
    if (countTime <= 0)
    {
        getVerifyBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateNormal];
        [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateHighlighted];
    }
    else
    {
        NSString *title = [NSString stringWithFormat:LOCAL(@"countdown", @""),countTime--];
        [getVerifyBtn setTitle:title forState:UIControlStateNormal];
        [getVerifyBtn setTitle:title forState:UIControlStateHighlighted];
    }
    
    
    
}


- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    
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
    
    else if (method == bindreplace && [param objectForKey:@"historymobile"]) { //修改绑定
        
        NSString *str = nil;
        switch (code) {
            case 1:
            case -9:
            {
                if (code == -9) { // 提示短信延迟
                    str = LOCAL(@"messagealert", @"");
                }
                
                id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
                
                if (![result isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"修改绑定返回格式错误");
                    return;
                }
                
                NSDictionary *dic = result;
                NSLog(@"%@",dic);
                
                self.key = [dic objectForKey:@"key"];
                self.mobile = newMobileTF.text;
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
                getVerifyBtn.userInteractionEnabled = NO;
//                ETVerifyViewController *verify = [[ETVerifyViewController alloc] init];
//                verify.mobile = newMobileTF.text;
//                verify.isChangeBind = YES;
//                verify.key = [dic objectForKey:@"key"];
//                [self.navigationController pushViewController:verify animated:YES];
//                [verify release];
                
                break;
                
            }
                
            case -1:
            {
                str = LOCAL(@"sidnull", @"sid不存在");
                break;
            }
            case -2:
            {
                str = LOCAL(@"mobileformaterror", @"手机格式错误");
                break;
            }
            case -3:
            {
                str = LOCAL(@"oldmobilenull", @"原始手机号码不存在");
                break;
            }
            case -4:
            {
                str = LOCAL(@"insertdataerror", @"插入数据失败");
                break;
            }
            case -5:
            {
                str = LOCAL(@"sendfail", @"发送短信失败");
                break;
            }
            case -8: //不发送短信
            {
                str = LOCAL(@"nosendmsg", @"");
                break;
            }
            case -10:
            {
                str = @"该手机号码已经绑定过";
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
    else if (method == bindreplace && [param objectForKey:@"mobile"]) // post 发送确认
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


- (void)getErrorInfo:(NSError *)error
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alertview show];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
