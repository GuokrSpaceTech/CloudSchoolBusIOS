
#import "ETFeedBackViewController.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "NetWork.h"
#import "ETKids.h"
#import "keyedArchiver.h"
@interface ETFeedBackViewController ()

@end

@implementation ETFeedBackViewController
@synthesize feedContent,emailField;
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
    [super viewDidLoad];

    self.emailField.delegate = self;
    self.feedContent.delegate = self;
    

    [self.sendBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"sendN", @"SetingSend.png")] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"sendH", @"SetingSend1.png")] forState:UIControlStateHighlighted];
    
    //loca
    
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"cancelButtonSelect", @"CancelSelect.png")] forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"cancelButton", @"Cancel.png")] forState:UIControlStateNormal];

    emailField.placeholder=LOCAL(@"InputEmail", @"请输入邮箱");
    

}
-(void)keyBoardCHange:(NSNotification *)notification
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITextField_Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
    
	[UIView commitAnimations];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2f];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
	[UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.view.frame.origin.y <0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma --
- (IBAction)sendPressed:(id)sender {
    
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_OFF)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    if([feedContent.text length]==0)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"输入内容不能为空" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if(![NetWork connectedToNetWork])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if(HUD==nil)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
        [delegate.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }

    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:emailField.text,@"email",feedContent.text,@"content",nil];
    [[EKRequest Instance] EKHTTPRequest:feedback parameters:param requestMethod:POST forDelegate:self];
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
-(void) getErrorInfo:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
    
}
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if (code == -1113)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"mutilDevice", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.loginStatus==LOGIN_OFF)
        {
            
            [[EKRequest Instance] clearSid];
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
            return;
        }
        
        
        [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
        
    }
    else if (method == feedback) {
        NSString *msg;
        if(code == 1)
            msg = LOCAL(@"success",  @"发送成功");
        else
            msg =LOCAL(@"fail",  @"发送失败,稍后请重试");
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:msg delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        
        
        [self.feedContent resignFirstResponder];
        [self.emailField resignFirstResponder];
    }
    
    else if (method == signin && code == 1)
    {
        [[EKRequest Instance] clearSid];
        UserLogin *user=[UserLogin currentLogin];
        user.loginStatus=LOGIN_OFF;
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
    }
    
    
}
#pragma --
#pragma UIAlertView_Delegate
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(alertView.tag == 1)
    {
        [self cancelPressed:nil];
    }
}
#pragma --
- (IBAction)cancelPressed:(id)sender
{
    self.feedContent.text=@"";
    self.emailField.text=@"";
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [feedContent release];
    [emailField release];
    [_sendBtn release];
    [_cancelBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [self setFeedContent:nil];
    [self setEmailField:nil];
    [self setSendBtn:nil];
    [self setCancelBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}

@end
