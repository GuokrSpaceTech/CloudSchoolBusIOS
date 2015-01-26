//
//  ChildhealthViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-28.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ChildhealthViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "ETCoreDataManager.h"
@interface ChildhealthViewController ()

@end

@implementation ChildhealthViewController
@synthesize healthField;
@synthesize healthState;
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
    self.healthField=nil;
    self.healthState=nil;
    [super dealloc];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
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
    
 
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = NSLocalizedString(@"spectialqingkuang", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //  [rightButton setTitle:@"对号" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    
    
    
    healthField=[[UITextField alloc]initWithFrame:CGRectMake(10, NAVIHEIGHT + (ios7 ? 20 : 0)+20, 300, 35)];
    healthField.borderStyle=UITextBorderStyleRoundedRect;
    healthField.delegate=self;
    [self.view addSubview:healthField];
    

    if(healthState==nil || [healthState isEqualToString:@""])
    {
        healthField.placeholder=NSLocalizedString(@"guoming", @"");
    }
    else
    {
        healthField.placeholder=healthState;
    }
    healthField.clearButtonMode=UITextFieldViewModeAlways;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5,healthField.frame.size.height+healthField.frame.origin.y+5, 300, 35)];
    label.text=NSLocalizedString(@"heathnote", @"");
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:14];
    label.lineBreakMode=NSLineBreakByCharWrapping;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor grayColor];
    [self.view addSubview:label];
    [label release];
    
    
//    UIButton *xbutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [xbutton setBackgroundImage:[UIImage imageNamed:@"clean.png"] forState:UIControlStateNormal];
//    xbutton.frame=CGRectMake(0, 0, 18, 18);
//    [xbutton addTarget:self action:@selector(cleanClick:) forControlEvents:UIControlEventTouchUpInside];
//    healthField.rightView=xbutton;

    

   // healthField.rightViewMode=UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

-(void)rightButtonClick:(UIButton *)btn
{
    [healthField resignFirstResponder];
    if([healthField.text isEqualToString:@""] || healthField.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:healthField.text,@"health", nil];
    [[EKRequest Instance] EKHTTPRequest:student parameters:dic requestMethod:POST forDelegate:self];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==student && code==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        UserLogin *user=[UserLogin currentLogin];
        user.healtState=healthField.text;
        
        
        [ETCoreDataManager saveUser];
        
        NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        [center postNotificationName:@"CHILDINFO" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
