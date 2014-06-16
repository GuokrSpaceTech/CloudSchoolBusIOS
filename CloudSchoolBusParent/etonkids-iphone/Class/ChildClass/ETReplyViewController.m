//
//  ETReplyViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETReplyViewController.h"
//#define NAVIHEIGHT 44
#import "ETKids.h"
#import "NetWork.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "AppDelegate.h"
#import "ETCommonClass.h"

@interface ETReplyViewController ()

@end

@implementation ETReplyViewController
@synthesize textview;
@synthesize sharecontent;
@synthesize string;
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
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.90 alpha:1.0];
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"blackNavigationbar.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(5, 9, 75, 26);
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTintColor:[UIColor whiteColor]];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [leftButton setTitle:LOCAL(@"back", @"") forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"leftNavigation.png"] forState:UIControlStateNormal];
    [leftButton  setBackgroundImage:[UIImage imageNamed:@"clickLeftNavigation"] forState:UIControlStateHighlighted];
    [self.view addSubview:leftButton];
    
       
    middleView =[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:middleView];
    middleView.hidden=YES;
    [middleView release];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 12, 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"replyComment", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    
    
    self.textview=[[UITextView alloc]initWithFrame:CGRectMake(10,NAVIHEIGHT+10, 300, 180)];
    self.textview.font=[UIFont systemFontOfSize:15];
    self.textview.delegate=self;
    self.textview.text=LOCAL(@"please", @"");
    self.textview.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.95 alpha:1.0];
    self.textview.userInteractionEnabled=YES;
    [self.view addSubview:self.textview];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//回车键textview回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    NSString * toString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (self.textview == textView)  //判断是否时我们想要限定的那个输入框
    {
        if ([toString length] >70) { //如果输入框内容大于70则弹出警告
            
            self.textview.text = [toString substringToIndex:70];
            ETCustomAlertView *alert = [[[ETCustomAlertView alloc] initWithTitle:nil message:LOCAL(@"Can not", @"") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease];
            [alert show];
            return NO;
        }
    }
    
    return YES;
}
-(void)leftButtonClick:(UIButton*)sender
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)rightButtonClick:(UIButton*)sender
{
    [self.textview resignFirstResponder];
    if ([self.textview.text isEqualToString:@""])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"empty", @"") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:LOCAL(@"cancle", @"取消"), nil];
        [alert show];
        
    }
    else
    {
        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.loginStatus==LOGIN_OFF)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            return;
        }
//        if(![NetWork connectedToNetWork])
//        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
//            
//            [self.view setNeedsLayout];
//            return;
//        }
        
        if(HUD==nil)
        {
            if(HUD==nil)
            {
                AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
                [delegate.window addSubview:HUD];
                [HUD show:YES];
                [HUD release];
            }
            
        }
        
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"article",@"itemtype",string,@"itemid",self.textview.text,@"content",nil];
        [[EKRequest Instance] EKHTTPRequest:comment parameters:param requestMethod:POST forDelegate:self];
    }
}
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (method == comment) {
        NSString *msg;
        if(code == 1)
        {
            msg = LOCAL(@"success",  @"发送成功");
        }
        else
        {
            msg =LOCAL(@"fail",  @"发送失败,稍后请重试");
        }
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:msg delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        
    }
    else if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma EKProtocol_Delegate
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
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TabBarHidden" object:nil];
    [textview release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextview:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
