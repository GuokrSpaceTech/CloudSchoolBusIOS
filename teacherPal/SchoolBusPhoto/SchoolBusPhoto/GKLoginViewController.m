//
//  GKLoginViewController.m
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import "GKLoginViewController.h"
#import "GKMainViewController.h"
#import "GKUserLogin.h"
#import "MTAuthCode.h"
#import "GKAppDelegate.h"
#import "GKUserLogin.h"
#import "GKLoaderManager.h"
#import "Student.h"
#import "GKSchoolTag.h"
@interface GKLoginViewController ()

@end

@implementation GKLoginViewController
//@synthesize autoImgV,remImgV;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    UIImage *helper= IMAGENAME(IMAGEWITHPATH(NSLocalizedString(@"jiaoshiLogin", @"")));
    
    [_jiaoshiLogin setImage:helper];
    
    _forgetpass.text=NSLocalizedString(@"forgetpass", @"");
   
    _userName.placeholder=NSLocalizedString(@"classaccount", @"");
    _passWord.placeholder=NSLocalizedString(@"passwordlogin", @"");
    [_loginBtn setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
    GKUserLogin *user=[GKUserLogin currentLogin];
    
   // _forgetpass.frame=CGRectMake(10,self.view.frame.size.height-5, 300, 20);
    

    
    NSLog(@"%f",self.view.frame.size.height);
    //记住密码*******************************
    NSUserDefaults *Default=[NSUserDefaults standardUserDefaults];
    //判定是否设定了记住密码
    if([Default objectForKey:REMEMBERPSAAWORD])
    {
        //remImgV.hidden = NO;
        //判定最后一次登录的状态是否成功，及判定帐号和密码是否存在
        if ([user getLastLogin])
        {
            _userName.text=user._userName;
            _passWord.text=user._passWord;
        }
        
        
    }
    else
    {
        //remImgV.hidden = YES;
    }
    

    
    // Do any additional setup after loading the view from its nib.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!textField.window.isKeyWindow)
    {
        [textField.window makeKeyAndVisible];
    }
    CGRect frame = self.view.frame;
    //    NSLog(@"%f",frame.origin.y);
    if (_passWord==textField || _userName == textField)
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.25];
        
        
        frame.origin.y = 10 - (iphone5 ? 30 : 120);
        //        frame.size.height +=50;
        self.view.frame = frame;
        
        [UIView commitAnimations];
    }
    
}

- (void)endEdit
{
    if ([_passWord isFirstResponder] || [_userName isFirstResponder])
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.25];
        
        CGRect frame = self.view.frame;
        frame.origin.y = ios7 ? 0 : 20;
        
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.userName])
        [self.passWord becomeFirstResponder];
    if([textField isEqual:self.passWord])
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.25];
        
        CGRect frame = self.view.frame;
        frame.origin.y = ios7 ? 0 : 20;
        
        self.view.frame = frame;
        
        [UIView commitAnimations];
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self endEdit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginBtn release];
    [_userName release];
    [_passWord release];
    self.forgetpass=nil;
//    self.remImgV=nil;
//    self.autoImgV=nil;
    [_jiaoshiLogin release];
    [super dealloc];
}

//-(IBAction)autoLogin:(id)sender
//{
//    
//    autoImgV.hidden = !autoImgV.hidden;
//    
//    if (!autoImgV.hidden) {
//        remImgV.hidden = NO;
//    }
//    
//    
//}
/// 记住密码
//- (IBAction)rember:(UIButton *)sender
//{
//
//    
//    remImgV.hidden = !remImgV.hidden;
//    
//}



- (IBAction)loginBtnClick:(id)sender {
     // [self loginSucess];
   // [self.view endEditing:YES];
    GKAppDelegate *delegate=APPDELEGATE;
    if(![delegate connectedToNetWork])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"WIFI", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    if([_userName.text isEqualToString:@""] || [_passWord.text isEqualToString:@""] || _userName.text==nil || _passWord.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"mimainput", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
      [self endEdit];
    GKUserLogin *user=[GKUserLogin currentLogin];
    [user clearSID];
    user._userName=_userName.text;
    user._passWord=_passWord.text;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_userName.text,@"username",[MTAuthCode authEncode:_passWord.text authKey:@"mactop" expiryPeriod:0],@"password",@"",@"token", nil];
    NSString *sss=[MTAuthCode authEncode:_passWord.text authKey:@"mactop" expiryPeriod:0];
    
    NSString * jimi=[MTAuthCode authDecode:sss authKey:@"mactop" expiryPeriod:0];

    NSLog(@"mima:%@---%@",sss,jimi);
    //NSLog(@"%@",[MTAuthCode authDecode:sss authKey:@"mactop" expiryPeriod:0]);
    [[EKRequest Instance] EKHTTPRequest:tsignin parameters:dic requestMethod:POST forDelegate:self];
    
       _loginBtn.enabled=NO;



    

    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
 
}
-(void)loginSucess
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    _loginBtn.enabled=YES;
    GKUserLogin *user=[GKUserLogin currentLogin];
    user._loginState=LOGINSERVER;
    user.badgeNumber=[userDefault objectForKey:@"BADGE"];
    [user updateLastLogin];
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
//    if (autoImgV.hidden)
//    {
//        [defaultUser removeObjectForKey:AUTOLOGIN];
//    }
//    else
//    {
//        [defaultUser setObject:AUTOLOGINVALUE forKey:AUTOLOGIN];
//      
//    }
    
    
    //判定是否设定了记住密码
    //if(remImgV.hidden)
   // {
       // [defaultUser removeObjectForKey:REMEMBERPSAAWORD];
   // }
    //else
    //{
        [defaultUser setObject:REMEMBERPSAAWORDVALUE forKey:REMEMBERPSAAWORD];
    //}
    
   // [defaultUser setObject:@"5" forKey:@"HEADERBACKGROUND"];

    
    
 
    
//    dispatch_sync(dispatch_get_global_queue(<#dispatch_queue_priority_t priority#>, <#unsigned long flags#>)(), ^{
//       
//        GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
//        [manager getLoadingPicFromCoreData];
//    });
//
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GKLoaderManager *manager=[GKLoaderManager createLoaderManager];
      [ manager getLoadingPicFromCoreData];
        
    });
    
    [BPush bindChannel];
    
    GKMainViewController *mainVC=[[GKMainViewController alloc]initWithNibName:@"GKMainViewController" bundle:nil];
    [self presentViewController:mainVC animated:YES completion:^{
    
        
    }];
    
    [mainVC release];
   

}




-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
  
    NSString *st=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",st);
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    GKUserLogin *user=[GKUserLogin currentLogin];
    if(method==tsignin && code==1)
    {
    
        if(dic!=nil)
        {
            user._sid=[dic objectForKey:@"sid"];
        }
        
        [[EKRequest Instance] EKHTTPRequest:classinfo parameters:nil requestMethod:GET forDelegate:self];
        
        //[self loginSucess];
    }
    else if(method==tsignin)
    {
        if(code==-3 || code==-1013 || code==-4)
        {

            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"mimaerr", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        if(code==-1010)
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"account", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
//            [alert show];
//            [alert release];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"mimaerr", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
           _loginBtn.enabled=YES;
    }
    
    if(method==classinfo && code==1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        NSDictionary *classInformation=[dic objectForKey:@"classinfo"];
        ClassInfo *info=[[ClassInfo alloc]init];
        info.address=[classInformation objectForKey:@"address"];
        info.city=[classInformation objectForKey:@"city"];
        info.classid=[classInformation objectForKey:@"classid"];
        info.classname=[classInformation objectForKey:@"classname"];
        info.phone=[classInformation objectForKey:@"phone"];
        info.province=[classInformation objectForKey:@"province"];
        info.schoolname=[classInformation objectForKey:@"schoolname"];
        info.uid=[NSString stringWithFormat:@"%@",[classInformation objectForKey:@"uid"]];
        user.classInfo=info;
        [info release];

        
        NSDictionary *teacherInfo=[dic objectForKey:@"teacher"];
        GKTeacher *teacher=[[GKTeacher alloc]init];
        teacher.avatar=[teacherInfo objectForKey:@"avatar"];
        teacher.ismainid=[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"ismainid"]];
        teacher.mobile=[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"mobile"]];
        teacher.sex=[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"sex"]];
        teacher.teacherid=[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"teacherid"]];
        teacher.nikename=[teacherInfo objectForKey:@"nikename"];
        teacher.teachername=[teacherInfo objectForKey:@"teachername"];
        user.teacher=teacher;
        [teacher release];
        
        NSMutableArray *studentArr=[[NSMutableArray alloc]init];
        NSArray *_studentArr=[dic objectForKey:@"studentinfo"];
        for (int i=0; i<[_studentArr count]; i++) {
            
            NSDictionary *studentInfo=[_studentArr objectAtIndex:i];
            Student *student=[[Student alloc]init];
            student.absence=[studentInfo objectForKey:@"absence"];
            student.age=[studentInfo objectForKey:@"age"];
            student.avatar=[studentInfo objectForKey:@"avatar"];
            student.birthday=[studentInfo objectForKey:@"birthday"];
            student.cnname=[studentInfo objectForKey:@"cnname"];
            student.enname=[studentInfo objectForKey:@"enname"];
            student.filesize=[studentInfo objectForKey:@"filesize"];
            student.isabsence=[studentInfo objectForKey:@"isabsence"];
            student.isattendance=[studentInfo objectForKey:@"isattendance"];
            student.islock=[studentInfo objectForKey:@"islock"];
            student.mobile=[studentInfo objectForKey:@"mobile"];
            student.sex=[studentInfo objectForKey:@"sex"];
            student.studentid=[studentInfo objectForKey:@"studentid"];
            student.studentno=[studentInfo objectForKey:@"studentno"];
            student.isinstalled=[studentInfo objectForKey:@"isinstalled"];
            student.online=[studentInfo objectForKey:@"online"];
            student.uid=[studentInfo objectForKey:@"uid_student"];
            student.stunumber=[studentInfo objectForKey:@"studentno"];
            student.orderendtime=[studentInfo objectForKey:@"orderendtime"];
            student.healthstate=[studentInfo objectForKey:@"healthstate"];
            student.username=[NSString stringWithFormat:@"%@",[studentInfo objectForKey:@"username"]];
            student.parentid=[NSNumber numberWithInt:[[studentInfo objectForKey:@"parentid"] integerValue]];
            [studentArr addObject:student];
            [student release];
            
        }
        user.studentArr=studentArr;
        [studentArr release];
        
        
         [[EKRequest Instance] EKHTTPRequest:setting parameters:nil requestMethod:GET forDelegate:self];
    }
    else if(method==classinfo)
    {
           _loginBtn.enabled=YES;
    }
    
    if(method==setting &&code==1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",dic);
        
      //  user.upIP=[dic objectForKey:@"clientip"];
        
        NSArray *tagArr=[dic objectForKey:@"tag"];
        NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
        for (int i=0; i<[tagArr count]; i++) {
            GKSchoolTag *tag=[[GKSchoolTag alloc]init];
            tag.tagid=[NSString stringWithFormat:@"%@",[[tagArr objectAtIndex:i] objectForKey:@"tagid"]];
            tag.tagname=[[tagArr objectAtIndex:i] objectForKey:@"tagname"];
            tag.tagname_en=[[tagArr objectAtIndex:i] objectForKey:@"tagname_en"];
            [tmpArr addObject:tag];
            [tag release];
        }
        
        user.photoTagArray=tmpArr;
        
//        if ([[dic objectForKey:@"photo_tag"] isKindOfClass:[NSArray class]])
//        {
//            user.photoTagArray = [dic objectForKey:@"photo_tag"];
//            NSLog(@"photo_tag : %@",user.photoTagArray);
//        }
//        else
//        {
//            NSLog(@"photo_tag type error");
//        }
//        
        
        
        [self loginSucess];
    }
    else if(method==setting)
    {
          _loginBtn.enabled=YES;
    }
    
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    _loginBtn.enabled=YES;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassWord:nil];
    [self setForgetpass:nil];
    [self setJiaoshiLogin:nil];
    [_loginBtn release];
//    self.remImgV=nil;
//    self.autoImgV=nil;

    
    [super viewDidUnload];
}
@end
