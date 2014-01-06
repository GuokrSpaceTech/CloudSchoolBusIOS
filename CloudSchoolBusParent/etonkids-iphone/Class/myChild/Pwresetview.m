//
//  Pwresetview.m
//  etonkids-iphone
//
//  Created by Simon on 13-8-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "Pwresetview.h"
#import "ETKids.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "keyedArchiver.h"
#import "GTMBase64.h"
#import "NetWork.h"
#import "MTAuthCode.h"
#import "ETCommonClass.h"

@implementation Pwresetview
@synthesize textview,logTextfield,StudentTextfield,imageview;
@synthesize logLabel,StudentLabel,canclebutton,okbutton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //背景图片
       imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        imageview.image=[UIImage imageNamed:@"loginBack.png"];
        [self addSubview:imageview];
        [imageview release];
        //if (!iphone5) {
            //height=30;
            //温馨提示
            self.textview=[[UITextView alloc]initWithFrame:CGRectMake(20,height, 280,100)];
            self.textview.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.96 alpha:1.0];
            [imageview addSubview:self.textview];
            self.textview.delegate=self;
            self.textview.textColor = [UIColor colorWithRed:86/255.0 green:102/255.0f blue:139/255.0 alpha:1.0f];
            self.textview.font=[UIFont systemFontOfSize:15];
            self.textview.userInteractionEnabled=NO;
//            self.textview.text=@"请输入学生学号和登陆手机号码进行验证，验证成功后，密码会自动修复为初始密码111111，请登陆后及时更新!";
            self.textview.text = @"若我们核对正确，自动重置密码为：111111";
            //‘’‘’‘
            logLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, height+120, 80, 30)];
            logLabel.text=@"手机号";
        logLabel.textColor = [UIColor colorWithRed:86/255.0 green:102/255.0f blue:139/255.0 alpha:1.0f];
            logLabel.backgroundColor=[UIColor clearColor];
            [imageview addSubview:logLabel];
            [logLabel release];
            
            StudentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,height+170, 80, 30)];
            StudentLabel.text=@"学号";
        StudentLabel.textColor = [UIColor colorWithRed:86/255.0 green:102/255.0f blue:139/255.0 alpha:1.0f];
            StudentLabel.backgroundColor=[UIColor clearColor];
            [imageview addSubview:StudentLabel];
            [StudentLabel release];
            
            logTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100,height+120, 200, 30)];
            logTextfield.borderStyle = UITextBorderStyleRoundedRect;
            logTextfield.delegate=self;
            logTextfield.placeholder = @"请输入登陆使用的手机号码";
            logTextfield.textAlignment=UITextAlignmentLeft;
            logTextfield.clearButtonMode = UITextFieldViewModeAlways;
            logTextfield.font = [UIFont fontWithName:@"Arial" size:14.0f];
            logTextfield.clearsOnBeginEditing = YES;
            [self addSubview:logTextfield];
            
            StudentTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100,height+170,200, 30)];
            StudentTextfield.borderStyle = UITextBorderStyleRoundedRect;
            StudentTextfield.delegate=self;
            StudentTextfield.placeholder = @"请输入学生学号";
            StudentTextfield.textAlignment=UITextAlignmentLeft;
            StudentTextfield.clearButtonMode = UITextFieldViewModeAlways;
            StudentTextfield.font = [UIFont fontWithName:@"Arial" size:14.0f];
            StudentTextfield.clearsOnBeginEditing = YES;
            [self addSubview:StudentTextfield];
            
            
            canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            canclebutton.frame=CGRectMake(30,height+240, 82, 30);
//            [canclebutton setTitle:@"取消" forState:UIControlStateNormal];
        [canclebutton setImage:[UIImage imageNamed:LOCAL(@"cancelButton", @"")] forState:UIControlStateNormal];
        [canclebutton setImage:[UIImage imageNamed:LOCAL(@"cancelButtonSelect", @"")] forState:UIControlStateHighlighted];
            [canclebutton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:canclebutton];
            
            
            okbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            [okbutton setImage:[UIImage imageNamed:LOCAL(@"okButton", @"")] forState:UIControlStateNormal];
            [okbutton setImage:[UIImage imageNamed:LOCAL(@"okButtonSelect", @"")] forState:UIControlStateHighlighted];
            okbutton.frame=CGRectMake(175,height+240, 82, 30);
//            [okbutton setTitle:@"确定" forState:UIControlStateNormal];
            [okbutton addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:okbutton];

        
        if (!iphone5) {
            height=30;
            
            self.textview.frame=CGRectMake(20,height, 280,100);
            logLabel.frame=CGRectMake(20, height+120+30, 80, 30);
            StudentLabel.frame=CGRectMake(20,height+170+30, 80, 30);
            logTextfield.frame=CGRectMake(100,height+120+30, 200, 30);
            StudentTextfield.frame=CGRectMake(100,height+170+30,200, 30);
            canclebutton.frame=CGRectMake(30,height+240+30+20, 80, 30);
            okbutton.frame=CGRectMake(175,height+240+30+20, 80, 30);
        }
        else
        {
           height=60;
           self.textview.frame=CGRectMake(20,height, 280,100);
           logLabel.frame=CGRectMake(20, height+120+30, 80, 30);
           StudentLabel.frame=CGRectMake(20,height+170+30, 80, 30);
           logTextfield.frame=CGRectMake(100,height+120+30, 200, 30);
            StudentTextfield.frame=CGRectMake(100,height+170+30,200, 30);
            canclebutton.frame=CGRectMake(30,height+240+30+20, 80, 30);
            okbutton.frame=CGRectMake(175,height+240+30+20, 80, 30);
            
        }
      
    }
    return self;
}


-(void)cancle:(UIButton*)sender
{
    [UIView animateWithDuration:.1 animations:^{
        self.frame=CGRectMake(-320, 0, 320, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
  
}
-(void)showHUD:(BOOL) animation
{
    if(animation)
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
    else
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
    }
}
-(void)ok:(UIButton*)sender
{
    if([logTextfield.text isEqualToString:@""]||[StudentTextfield.text isEqualToString:@""])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"input", @"输入不能为空")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if(![NetWork connectedToNetWork])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        [self setNeedsLayout];
        return;
    }
    else
    {
        [self senderbutton];
   
   }
}
-(void)senderbutton
{
    if(HUD==nil)
    {
        [self showHUD:YES];
        
    }
    if([StudentLabel.text isEqualToString:@""] || [logTextfield.text isEqualToString:@""])
        return;
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:[MTAuthCode authEncode:self.logTextfield.text authKey:@"mactop" expiryPeriod:0],@"mobile",[MTAuthCode authEncode:self.StudentTextfield.text authKey:@"mactop" expiryPeriod:0],@"studentno", nil];
    [[EKRequest Instance] EKHTTPRequest:forgot parameters:param requestMethod:POST forDelegate:self];

}
#pragma EKRequest_Delegate
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if(method ==forgot)
    {
        if(code == 1)
        {
            [self performSelector:@selector(success) withObject:nil];
        }
        else if(code==-1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"手机号错误" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            

        }
        else if(code==-2)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"学生号错误" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if(code==-3)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"校验失败没有匹配用户" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if(code==-4)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"密码修改失败或密码没有变化" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            [self LoginFailedresult:LOCAL(@"fail",  @"信息修改失败,稍后请重试")];
        }

    }
    
    else if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
}

#pragma EKRequest_Delegate
-(void)LoginFailedresult:(NSString *)str
{
//    if(HUD)
//    {
//        [HUD removeFromSuperview];
//        HUD=nil;
//    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) getErrorInfo:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void)success
{
    ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:@"密码重置成功" message:@"密码已重置为111111，请登录后及时修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertview show];
    [alertview release];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [logTextfield resignFirstResponder];
    [StudentTextfield resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
