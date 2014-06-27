//
//  ETForgetPasswordViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-21.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETForgetPasswordViewController.h"
#import "ETCommonClass.h"
#import "ETVerifyViewController.h"
#import "ETVerifyPasswordViewController.h"
#import "ETCoreDataManager.h"

@interface ETForgetPasswordViewController ()

@end

@implementation ETForgetPasswordViewController
@synthesize isBind,key;

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
    
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(doClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    if (isBind)//绑定页面
    {
        middleLabel.text = LOCAL(@"bindmobile", @"");
        tishiLab.text = LOCAL(@"bindtishi", @"");
        serviceBtn.hidden = YES;
        phonelabel.hidden = YES;
        
        [nextBtn setTitle:LOCAL(@"ok", @"") forState:UIControlStateNormal];
        [nextBtn setTitle:LOCAL(@"ok", @"") forState:UIControlStateHighlighted];
    }
    else //
    {
        middleLabel.text = LOCAL(@"forgotpwdtitle", @"");
        tishiLab.text = LOCAL(@"forgettishi", @"手机号账号可自主找回密码，该号码不会对其他人公开。");
        serviceBtn.hidden = NO;
        phonelabel.hidden = NO;
        
        [nextBtn setTitle:LOCAL(@"next", @"") forState:UIControlStateNormal];
        [nextBtn setTitle:LOCAL(@"next", @"") forState:UIControlStateHighlighted];
    }
    
    
//    telephoneTF.placeholder = LOCAL(@"telephoneplaceholder", @"");
    phonelabel.text = LOCAL(@"forgotpwd", @"");
    serviceBtn.center = phonelabel.center;
    
//    NSLog(@"%f,%f",phonelabel.center.x,phonelabel.center.y);
    
    
    
    
    [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateNormal];
    [getVerifyBtn setTitle:LOCAL(@"getverify", @"") forState:UIControlStateHighlighted];
    getVerifyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
//    verifyTF.placeholder = LOCAL(@"verifyplaceholder", @"");
    tishiVerify.text = LOCAL(@"qingshuruyanzhengma", @"");
    countTime = 180;
    
    
    messageAlert.text = LOCAL(@"messagealert", @"");
    
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     -50,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    }];
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
    
    [telephoneTF release];

    [tishiLab release];


    [serviceBtn release];
    [nextBtn release];
    [phonelabel release];
    [verifyTF release];
    [getVerifyBtn release];
    [tishiVerify release];
    [messageAlert release];
    [super dealloc];
}
- (void)viewDidUnload {
    [telephoneTF release];
    telephoneTF = nil;

    [tishiLab release];
    tishiLab = nil;


    [serviceBtn release];
    serviceBtn = nil;
    [nextBtn release];
    nextBtn = nil;
    [phonelabel release];
    phonelabel = nil;
    [verifyTF release];
    verifyTF = nil;
    [getVerifyBtn release];
    getVerifyBtn = nil;
    [tishiVerify release];
    tishiVerify = nil;
    [messageAlert release];
    messageAlert = nil;
    [super viewDidUnload];
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
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    NSString *aaa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"aaaa %@",aaa);
    NSLog(@"error code : %d",code);
    
    if(method == forgetpwd || method == bindTel)
    {
        if(code == 1 || code == -9)
        {
            // push next
            
            
            
            if ([param objectForKey:@"key"]) {
                
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"bindsuccess", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
                [alert show];
                
                UserLogin *user = [UserLogin currentLogin];
                user.ischeck_mobile = @"1";
                user.mobile = [NSString stringWithFormat:@"%@",[param objectForKey:@"mobile"]];
                
                [ETCoreDataManager saveUser];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEMYACCOUNT" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            if (code == -9) {
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"messagealert", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
                [alert show];
            }
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            NSLog(@"%@",dic);
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            
            self.key = [dic objectForKey:@"key"];
            
            getVerifyBtn.userInteractionEnabled = NO;
            
            /*
            ETVerifyViewController *verify = [[ETVerifyViewController alloc] init];
            verify.mobile = telephoneTF.text;
            verify.key = [dic objectForKey:@"key"];
            verify.isChangeBind = NO;
            if (method == forgetpwd)
            {
                verify.isForgetPwd = YES;
            }
            else
            {
                verify.isForgetPwd = NO;
            }
            
            [self.navigationController pushViewController:verify animated:YES];
            [verify release];*/
            
        }
        else if(code==-1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"手机号错误" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else if(code==-2)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"shoujihaomaweibangding", @"该手机号码尚未绑定") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
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
        else if (code == -8)
        {//不发送短信
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosendmsg", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (code == -10)
        {//不发送短信
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"该手机号码已经绑定过" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        else
        {
            [self LoginFailedresult:LOCAL(@"fail",  @"信息修改失败,稍后请重试")];
        }
        
    }
    

}
#pragma EKRequest_Delegate
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
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}


-(void)success
{
    ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"forgotsuccess",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alertview show];
    
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)doClickCancel:(id)sender {
    if (isBind)//绑定页面
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (BOOL)checkMobile
{
    if ([telephoneTF.text isEqualToString:@""] || telephoneTF.text == nil) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        
        return NO;
    }
    
    if (telephoneTF.text.length != 11) {
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"mobileformaterror",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        
        return NO;
    }
    
    return YES;
}


- (IBAction)doNext:(id)sender {
    
    
    if (isBind)
    {
        if (![self checkMobile]) return;
        
        
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
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:telephoneTF.text, @"mobile",self.key,@"key",nil];
        [[EKRequest Instance] EKHTTPRequest:bindTel parameters:param requestMethod:POST forDelegate:self];
    }
    else
    {
        if (![self checkMobile]) return;
        
        
        if (self.key == nil || ![self.key isEqualToString:verifyTF.text]) {
            
            ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"verifyerror",@"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alertview show];
            
            
            
            return;
            
        }
        
        ETVerifyPasswordViewController *vp = [[ETVerifyPasswordViewController alloc] init];
        vp.mobile = telephoneTF.text;
        vp.verifyCode = self.key;
        //            vp.verifyCode = verifyTF.text;
        [self.navigationController pushViewController:vp animated:YES];
        [vp release];
    }
    
    
    
    
    
    
    
}

- (IBAction)callService:(id)sender
{
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:[NSString stringWithFormat:@"%@",SERVICE_NUMBER] delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"call", @""), nil];
    alert.tag=888;
    [alert show];
    
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (alertView.tag == 888) {
        if (index == 1) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",[SERVICE_NUMBER stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}

- (IBAction)getVerify:(id)sender {
    
    if (![self checkMobile]) {
        return;
    }
    
    if (self.isBind)
    {
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:telephoneTF.text, @"mobile",nil];
        [[EKRequest Instance] EKHTTPRequest:bindTel parameters:param requestMethod:GET forDelegate:self];
    }
    else
    {
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:telephoneTF.text, @"mobile",nil];
        [[EKRequest Instance] EKHTTPRequest:forgetpwd parameters:param requestMethod:GET forDelegate:self];
    }
}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
////- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
////{
////    
////    return YES;
////    
////}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}



@end
