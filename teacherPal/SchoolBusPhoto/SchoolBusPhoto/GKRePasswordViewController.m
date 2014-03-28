//
//  GKRePasswordViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-18.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKRePasswordViewController.h"
#import "MTAuthCode.h"
#import "KKNavigationController.h"
@interface GKRePasswordViewController ()

@end

@implementation GKRePasswordViewController
@synthesize oldPassword,PasswordNew,PasswordNewCon;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.oldPassword=nil;
    self.PasswordNewCon=nil;
    self.PasswordNew=nil;
    [super dealloc];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(ios7)
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 20+navigationView.frame.size.height, 320, self.view.frame.size.height-20-navigationView.frame.size.height)];
        view.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
        [self.view addSubview:view];
        [view release];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    }

    self.titlelabel.text=NSLocalizedString(@"passwordalter", @"");
    
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    UIButton *sendbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendbutton.frame=CGRectMake(270, 5, 50, 35);
    [sendbutton setBackgroundImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [sendbutton setBackgroundImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];

    sendbutton.tag=102;
    [sendbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:sendbutton];


    
    NSArray *arrlable=[NSArray arrayWithObjects:NSLocalizedString(@"oldPass", @""),NSLocalizedString(@"newPass", @""),NSLocalizedString(@"confromPass", @""), nil];
     NSArray *arrplace=[NSArray arrayWithObjects:NSLocalizedString(@"Enter", @""),NSLocalizedString(@"Set", @""),NSLocalizedString(@"Confirm", @""), nil];
    int hight=navigationView.frame.size.height;
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 20+(ios7?(20+hight):hight) + i*(20+30), 100, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[arrlable objectAtIndex:i];
        if(IOSVERSION<6.0)
            label.textAlignment=UITextAlignmentLeft;
        else
            label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        [label release];
        
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(100, 22+(ios7?(20+hight):hight) + i*(20+30), 200, 26)];
        
        textfield.borderStyle=UITextBorderStyleRoundedRect;
        [self.view addSubview:textfield];
        textfield.secureTextEntry=YES;
        textfield.delegate=self;
        textfield.tag=i+986;
        textfield.font=[UIFont systemFontOfSize:15];
        textfield.placeholder=[arrplace objectAtIndex:i];
        [textfield release];
        
    }

    
	// Do any additional setup after loading the view.
}
-(void)Failedresult:(NSString *)str
{
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}
-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    UITextField *old=(UITextField *)[self.view viewWithTag:0+986];
     UITextField *passnew=(UITextField *)[self.view viewWithTag:1+986];
     UITextField *passnewCon=(UITextField *)[self.view viewWithTag:2+986];
    
    
    if([old.text length]==0||[passnew.text length]==0 || [passnewCon.text length]==0)
    {
        [self Failedresult:NSLocalizedString(@"input", @"输入不能为空") ];
    
        return;
    }
    if(![passnew.text isEqualToString:passnewCon.text])
    {
        [self Failedresult:NSLocalizedString(@"diff", @"两次密码输入不同")];
 
        return;
    }


    
   
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:[MTAuthCode authEncode:old.text authKey:@"mactop" expiryPeriod:0],@"old", [MTAuthCode authEncode:passnew.text authKey:@"mactop" expiryPeriod:0],@"new", nil];
        [[EKRequest Instance] EKHTTPRequest:tpassword parameters:param requestMethod:POST forDelegate:self];
    
 
    
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method parm:(NSDictionary *)parm resultCode:(int) code
{
    if(method == tpassword) {
        
        if(code!=1)
        {
            if(code==-1012)
            {
                [self Failedresult:NSLocalizedString(@"OidErr", @"")];
            }
            else if(code==-3 || code==-31 ||  code==-32)
            {
                [self Failedresult:NSLocalizedString(@"otherErr", @"")];
            }
            else if(code==-4)
            {
                [self Failedresult:NSLocalizedString(@"diffoldNew", @"新旧密码不能相同")];
                
                
            }
            else
            {
                [self Failedresult:NSLocalizedString(@"fail", @"")];
            }
            
            return ;
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"提示") message:NSLocalizedString(@"changePwdSuccess", @"密码修改成功,请重新登陆") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"确定") otherButtonTitles:nil];
           
            [alert show];
            [alert release];
            
            
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [delegate loginout];
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
}
@end
