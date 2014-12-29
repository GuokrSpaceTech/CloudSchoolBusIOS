
#import "ETRePassWordViewController.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "NetWork.h"
#import "ETApi.h"
#import "MTAuthCode.h"
#import "keyedArchiver.h"
#import "ETCommonClass.h"
#import "ETCustomAlertView.h"


#define NUMBERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation ETRePassWordViewController

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.conformPassWord.delegate = self;
    self.oldPassWord.delegate = self;
    self.newPassWord.delegate = self;
    self.oldPassWord.placeholder =LOCAL(@"Enter", @"") ; 
    self.conformPassWord.placeholder=LOCAL(@"Confirm", @"");
    self.newPassWord.placeholder=LOCAL(@"Set", @"");
    // 本地化
    
    UILabel *oldPass=(UILabel *)[self.view viewWithTag:1];
    oldPass.text=LOCAL(@"oldPass", @"旧密码");
    UILabel *newPass=(UILabel *)[self.view viewWithTag:2];
    newPass.text=LOCAL(@"newPass", @"新密码");
    
    
    UILabel *confrom=(UILabel *)[self.view viewWithTag:3];
    confrom.font=[UIFont systemFontOfSize:15];
    confrom.text=LOCAL(@"confromPass", @"确认");
    
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-80, 13 + (ios7 ? 20 : 0), 160, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"AlterPass",@"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    

//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
}
-(void)leftButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 发送修改密码.
-(void)rightButtonClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    if([_oldPassWord.text length]==0||[_newPassWord.text length]==0 || [_conformPassWord.text length]==0)
    {
        [self Failedresult:LOCAL(@"input", @"输入不能为空") ];
        return;
    }
    if(![_newPassWord.text isEqualToString:_conformPassWord.text])
    {
        [self Failedresult:LOCAL(@"diff", @"两次密码输入不同")];
        return;
    }
    if(![NetWork connectedToNetWork])
    {
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:[MTAuthCode authEncode:_oldPassWord.text authKey:@"mactop" expiryPeriod:0],@"old", [MTAuthCode authEncode:_newPassWord.text authKey:@"mactop" expiryPeriod:0],@"new", nil];
        [[EKRequest Instance] EKHTTPRequest:password parameters:param requestMethod:POST forDelegate:self];
        
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy",  @"网络故障,稍后请重试") waitUntilDone:NO];
}
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == password) {
        
        if(code!=1)
        {
            if(code==-1012)
            {
                [self Failedresult:LOCAL(@"OidErr", @"")];
            }
            else if(code==-3)
            {
                [self Failedresult:LOCAL(@"otherErr", @"")];
            }
            else
            {
                [self Failedresult:LOCAL(@"fail", @"")];
            }
            return ;
        }
        else
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"changePwdSuccess", @"密码修改成功,请重新登陆") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            alert.tag = 999;
            [alert show];
            
            
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (method == signin && code == 1)
    {
        if (param == nil) {
            [ETCommonClass logoutAndClearUserMessage];
        }
    }
    
}
#pragma mark--限制字符的输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.conformPassWord||textField==self.newPassWord)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }

    return YES;
}


#pragma UITextField_Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:_oldPassWord])
        [_newPassWord becomeFirstResponder];
    if([textField isEqual:_newPassWord])
       [_conformPassWord becomeFirstResponder];
    if([textField isEqual:_conformPassWord])
        [textField resignFirstResponder];
    return YES;
}


-(void)Failedresult:(NSString *)str
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (alertView.tag == 999) {
        [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
        
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    [_oldPassWord release];
    [_newPassWord release];
    [_conformPassWord release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOldPassWord:nil];
    [self setNewPassWord:nil];
    [self setConformPassWord:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}



@end
