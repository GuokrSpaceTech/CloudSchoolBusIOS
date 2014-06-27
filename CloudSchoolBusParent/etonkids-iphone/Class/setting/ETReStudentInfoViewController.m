
#import "ETReStudentInfoViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "NetWork.h"
#import "ETApi.h"
#import "GTMBase64.h"
#import "keyedArchiver.h"
#import "RegexKitLite.h"
#import "Modify.h"
#import "CustomActionSheet.h"
#import "ETCommonClass.h"

@implementation ETReStudentInfoViewController
@synthesize datepick,originName,originDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.nickName.text=ModifyData.Name;
    self.age.text=ModifyData.birthday;
    
    self.originDate = [NSString stringWithFormat:@"%@",self.age.text];
    self.originName = [NSString stringWithFormat:@"%@",self.nickName.text];
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
    
    
    
    self.nickName.delegate = self;
    self.age.delegate = self;
    [self.age addTarget:self action:@selector(textFieldDoneTime:)forControlEvents:UIControlEventTouchDown];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * headerData = [userDefault objectForKey:@"HEADERPHOTO"];
    if(headerData != nil)
    {
        UIImage * headerImg = [UIImage imageWithData:headerData];
        [self.headerBtn setBackgroundImage:headerImg forState:UIControlStateNormal];
    }
    else
    {
        
        UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.avatar != nil)
        [self.headerBtn setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:nil];
    }

    _LabelClickHeader.text=LOCAL(@"Avatar", @"点击图片更换头像");
    _NickNameLabel.text=LOCAL(@"NickName", @"修改昵称");
    _birthday.text=LOCAL(@"Birthday", @"修改生日");
    
    _studentInfoL.text=LOCAL(@"studentInfo", @"修改孩子信息");
    
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"cancelButtonSelect", @"CancelSelect.png")] forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"cancelButton", @"Cancel.png")] forState:UIControlStateNormal];

    [self.okBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"okButton",@"OK.png")] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:LOCAL(@"okButtonSelect", @"OKSelect.png")] forState:UIControlStateHighlighted];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BIRTHDAY:) name:@"POSTONE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(down:) name:@"POSTTOW" object:nil];
    

}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect startFrame,endFrame;
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect = self.view.frame;
    rect.origin.y -= 50;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    
	[UIView commitAnimations];
}
-(void)BIRTHDAY:(NSNotification*)sender
{
    NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString  *datastring=[formatter stringFromDate:datepick.date];
    self.age.text=datastring;
    
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
	[UIView commitAnimations];
}
-(void)down:(NSNotification*)sender
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
	[UIView commitAnimations];
 
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    
    if ([toBeString length] > 12) {
        textField.text = [toBeString substringToIndex:12];
        ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"limitChar", @"字符少于12个字") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
       
        return NO;
    }
    
    return YES;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.nickName])
    {
        [textField resignFirstResponder];
    }
    if([textField isEqual:self.age])
    {
        [textField resignFirstResponder];
    }
    return YES;
}  
-(void)textFieldDoneTime:(id)sender
{
    [self.nickName resignFirstResponder];
    CustomActionSheet* sheet = [[CustomActionSheet alloc] initWithHeight:284.0f
                                                          WithSheetTitle:@""];
    datepick = [[UIDatePicker alloc] init];
    [datepick sizeToFit];
    datepick.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
    [formate setDateFormat:@"yyyy-MM-dd"];
    datepick.date = [formate dateFromString:self.age.text];
    
    //NSLog(@"%@",[formate dateFromString:self.age.text]);
    
    [sheet.view addSubview:datepick];
    [sheet showInView:self.view];
    [sheet release];
//    NSString *lan= NSLocalizedString(@"Lanague", @"2");
//    if([lan isEqualToString:@"1"])
//    {
//        datepick.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    }
//    else
//    {
//        datepick.locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    }
//    [datepick.locale release];
    [self performSelector:@selector(back) withObject:nil];
}
#pragma performSelector back
-(void)back
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    CGRect rect = self.view.frame;
    rect.origin.y -= 70;
    self.view.frame = rect;
    [UIView commitAnimations];
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
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
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
    else if(method == student)
    {
        if(code == 1)
        {
            //更新孩子信息
            @try
            {
                UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
                
                NSDateFormatter * format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd"];
                NSString * currYear = [format stringFromDate:[NSDate date]];
                NSArray * arr = [self.age.text componentsSeparatedByString:@"-"];
                NSString * realYear = nil;
                if(arr!=nil)
                {
                    realYear = [arr objectAtIndex:0];
                }
                int realAge = [currYear intValue] - [realYear intValue];
                
                user.age = [NSString stringWithFormat:@"%d",realAge];
                user.nickname = self.nickName.text;
                [keyedArchiver setArchiver:@"LOGIN" withData:user forKey:@"LOGIN"];
                NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
                [center postNotificationName:@"CHILDINFO" object:nil];

            }
            @catch (NSException *exception)
            {
                NSLog(@"exception:%@",exception.description);
            }
            
            NSLog(@"%@",LOCAL(@"success", @"信息修改成功"));
            
            
            self.originDate = [NSString stringWithFormat:@"%@",self.age.text];
            self.originName = [NSString stringWithFormat:@"%@",self.nickName.text];
            
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"信息修改成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
            
            [self.view setNeedsLayout];
        }
        else
        {
            [self Failedresult:LOCAL(@"fail",  @"信息修改失败,稍后请重试")];
        }
    }
    else if(method ==avatar)
    {
        if(code == 1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
            
            [self.view setNeedsLayout];
        }
    }
    
    else if (method == signin && code == 1)
    {
        [[EKRequest Instance] clearSid];
        UserLogin *user=[UserLogin currentLogin];
        user.loginStatus=LOGIN_OFF;
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
    }
    
    
    
}
#pragma UIAlertView_Delegate
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(alertView.tag == 1)
    {
        [self cancel:nil];
    }
    if(alertView.tag == 2)
    {
        [self.headerBtn setBackgroundImage:self.headImage forState:UIControlStateNormal];
        NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        [center postNotificationName:@"PHOTO" object:nil];
    }
}
#pragma --
#pragma --
- (IBAction)confirm:(id)sender
{
    
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_OFF)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
        
            return;
    }
    


    
    
        if ([self.originName isEqualToString:self.nickName.text] && [self.originDate isEqualToString:self.age.text])
        {
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"noChangeInfo", @"未修改信息") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
        }
    
    NSString * regex = @"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$";
    BOOL isMatch = [self.age.text isMatchedByRegex:regex];
    if(isMatch ==NO)
    {
            if ([self.age.text  isEqualToString:@""])
            {
                self.age.text=ModifyData.birthday;
                self.age.textColor=[UIColor clearColor];
            }
        
            else    
            {
            [self Failedresult:LOCAL(@"formatBirth", @"请输入正确的生日格式,如2005-12-02")];
            return;
            }
    }

    if(![NetWork connectedToNetWork])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        [self.view setNeedsLayout];
        return;
    }
   
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
        if ([self.nickName.text isEqualToString:@""])
        {
            self.nickName.text=ModifyData.Name;
            self.nickName.textColor=[UIColor clearColor];
        }
  
    }
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.nickName.text,@"nikename",self.age.text,@"birthday",nil];
    ModifyData.birthday=[param objectForKey:@"birthday"];
    ModifyData.Name=[param objectForKey:@"nikename"];
    self.nickName.text=ModifyData.Name;
    self.age.text=ModifyData.birthday;

    [[EKRequest Instance] EKHTTPRequest:student parameters:param requestMethod:POST forDelegate:self];
    
}

-(void)Failedresult:(NSString *)str

{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
    [alert show];
    
    [self.view setNeedsLayout];
}
- (IBAction)cancel:(id)sender
{
    self.nickName.text=@"";
    self.age.text=@"";
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeHeader:(id)sender
{
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_OFF)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
        [alert show];
       
        return;
    }

    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
    [action showInView:self.view.window];
    [action release];
}
#pragma UIActionSheed_Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
            return;
        }
        //TabBarHidden//0
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
        
    }
    if(buttonIndex==1)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    if(buttonIndex==2)
    {
        NSLog(@"fdfdf");
    }
    
}

#pragma --

#pragma UIImagePickerController_Delegate
- (void)saveImage:(UIImage *)image
{
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:mydata forKey:@"HEADERPHOTO"];
    [userDefault synchronize];
    self.headImage = image;
    if(HUD==nil)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

        HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
        HUD.labelText=LOCAL(@"upload", @"正在上传头像");   //@"正在上传头像";
        [delegate.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    NSString * base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [[EKRequest Instance] EKHTTPRequest:avatar parameters:param requestMethod:POST forDelegate:self];
    [base64 release];
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
}

#pragma --

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PHOTO" object:nil];
    
    [_nickName release];
    [_age release];
    [_headerBtn release];
    [_okBtn release];
    [_cancelBtn release];
    [_LabelClickHeader release];
    [_NickNameLabel release];
    [_birthday release];
    [_studentInfoL release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setNickName:nil];
    [self setAge:nil];
    [self setHeaderBtn:nil];;
    [self setOkBtn:nil];
    [self setCancelBtn:nil];
    
    [self setLabelClickHeader:nil];
    [self setNickNameLabel:nil];
    [self setBirthday:nil];
    [self setStudentInfoL:nil];
    [super viewDidUnload];
}


//- (BOOL)shouldAutorotate
//{
//    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
//    //        return YES;
//    //    }
//    return NO;
//}
//
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
