
#import "ETLoginViewController.h"
#import "AppDelegate.h"
#import "UserLogin.h"
#import "LeveyTabBarController.h"
#import "ETClassViewController.h"
#import "ETChildViewController.h"
#import "ETNoticeViewController.h"
#import "ETSettingViewController.h"
#import "NetWork.h"
#import "ETKids.h"

#import "Modify.h"
#import "MTAuthCode.h"

#import <QuartzCore/QuartzCore.h>
#import "ETForgetPasswordViewController.h"
#import "ETBottomViewController.h"
#import "ETChangeGestureViewController.h"
#import "ETNavigationController.h"

@interface ETLoginViewController ()
-(void)LoginSuccess;
@end

@implementation ETLoginViewController
@synthesize userNameField,passWordField;
@synthesize leveyTabBarController;
@synthesize setNavigation;
@synthesize childNavigation,shareNavigation,noticeNavigation;
@synthesize Timealertview,resultSelectChild;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/// 自动登录
//-(IBAction)autoLogin:(id)sender
//{

//    autoImgV.hidden = !autoImgV.hidden;
//    
//    if (!autoImgV.hidden) {
//        remImgV.hidden = NO;
//    }
    
    
//}
/// 记住密码
//- (IBAction)rember:(UIButton *)sender
//{
//    NSUserDefaults *Default=[NSUserDefaults standardUserDefaults];
//    if([Default objectForKey:REMEMBERPSAAWORD])
//    {
//        [Default removeObjectForKey:REMEMBERPSAAWORD];
////        UIButton *button=(UIButton *)[self.view viewWithTag:REMEMBERP];
////        [button setImage:[UIImage imageNamed:@"UnSelected.png"] forState:UIControlStateNormal];
//        remImgV.hidden = YES;
//    }
//    else
//    {
//        [Default setObject:REMEMBERPSAAWORDVALUE forKey:REMEMBERPSAAWORD];
////        UIButton *button=(UIButton *)[self.view viewWithTag:REMEMBERP];
////        [button setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
////        [self.remberBt setImage:[UIImage imageNamed:@"Selected.png"] forState:UIControlStateNormal];
//        remImgV.hidden = NO;
//        
//    }
    
//    remImgV.hidden = !remImgV.hidden;
 
//}
/// 忘记密码
- (IBAction)forget:(UIButton*)sender
{
    
    ETForgetPasswordViewController *forget = [[ETForgetPasswordViewController alloc] init];
    forget.isBind = NO;
    ETNavigationController *nav = [[ETNavigationController alloc] initWithRootViewController:forget];
    [self presentModalViewController:nav animated:YES];
    [forget release];
    [nav release];
    
//    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:[NSString stringWithFormat:@"%@",SERVICE_NUMBER] delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"call", @""), nil];
//    alert.tag=888;
//    [alert show];

}

- (void)viewWillAppear:(BOOL)animated
{
    
//    [self setNeedsStatusBarAppearanceUpdate];
    // 调整坐标
    if (iphone5)
    {
        titleImgV.frame = CGRectMake(26, 49, titleImgV.frame.size.width, titleImgV.frame.size.height);
        versionImgV.frame = CGRectMake(231, 51, versionImgV.frame.size.width, versionImgV.frame.size.height);
        loginBackImgV.frame = CGRectMake(12, 171, loginBackImgV.frame.size.width, loginBackImgV.frame.size.height);
        accountImgV.frame = CGRectMake(32, 253, accountImgV.frame.size.width, accountImgV.frame.size.height);
        userNameField.frame = CGRectMake(100, 267, userNameField.frame.size.width, userNameField.frame.size.height);
        pwdImgV.frame = CGRectMake(32, 322, pwdImgV.frame.size.width, pwdImgV.frame.size.height);
        passWordField.frame = CGRectMake(100, 336, passWordField.frame.size.width, passWordField.frame.size.height);
        self.loginBtn.frame = CGRectMake(48, 399, self.loginBtn.frame.size.width, self.loginBtn.frame.size.height);
        self.forgetBt.frame = CGRectMake(187, 509, self.forgetBt.frame.size.width, self.forgetBt.frame.size.height);
        
    }
    else
    {
        titleImgV.frame = CGRectMake(26, 31, titleImgV.frame.size.width, titleImgV.frame.size.height);
        versionImgV.frame = CGRectMake(231, 33, versionImgV.frame.size.width, versionImgV.frame.size.height);
        loginBackImgV.frame = CGRectMake(12, 127, loginBackImgV.frame.size.width, loginBackImgV.frame.size.height);
        accountImgV.frame = CGRectMake(32, 209, accountImgV.frame.size.width, accountImgV.frame.size.height);
        userNameField.frame = CGRectMake(100, 223, userNameField.frame.size.width, userNameField.frame.size.height);
        pwdImgV.frame = CGRectMake(32, 278, pwdImgV.frame.size.width, pwdImgV.frame.size.height);
        passWordField.frame = CGRectMake(100, 292, passWordField.frame.size.width, passWordField.frame.size.height);
        self.loginBtn.frame = CGRectMake(48, 355, self.loginBtn.frame.size.width, self.loginBtn.frame.size.height);
        self.forgetBt.frame = CGRectMake(187, 437, self.forgetBt.frame.size.width, self.forgetBt.frame.size.height);
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
    
    versionImgV.image = [UIImage imageNamed:LOCAL(@"versionImage", @"")];
    
    self.userNameField.delegate = self;
    self.passWordField.delegate = self;
    [self.loginBtn setTitle:LOCAL(@"loginButton", @"") forState:UIControlStateNormal];

    self.userNameField.placeholder = LOCAL(@"usernameplaceholder", @"");
    self.passWordField.placeholder = LOCAL(@"passwordplaceholder", @"");

    [self.forgetBt setTitle:LOCAL(@"forgotpwdtitle?", @"") forState:UIControlStateNormal];
    

    UserLogin *user=[UserLogin currentLogin];
    
    
    NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
    //判定是否设定了自动登录
    
//    NSLog(@"%@,%@",[defaultUser objectForKey:AUTOLOGIN],[defaultUser objectForKey:REMEMBERPSAAWORD]);
    if([defaultUser objectForKey:AUTOLOGIN])
    {
//        remImgV.hidden = NO;
//        autoImgV.hidden = NO;
        //判定最后一次登录的状态是否成功，及判定帐号和密码是否存在
        if ([user getLastLogin])
        {
            userNameField.text=user.regName;
//            passWordField.text=user.passWord;
        }
    }
    else
    {
//        autoImgV.hidden = YES;
    }
    //记住密码*******************************
    
    //判定是否设定了记住密码
//    if([defaultUser objectForKey:REMEMBERPSAAWORD])
//    {
//        remImgV.hidden = NO;
        //判定最后一次登录的状态是否成功，及判定帐号和密码是否存在
//        if ([user getLastLogin])
//        {
//            userNameField.text=user.regName;
//            passWordField.text=user.passWord;
//        }

        
//    }
//    else
//    {
//        remImgV.hidden = YES;
//    }
    
    
    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:@"TestFirst"];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    //判断文件是否存在，判断是否第一次运行程序
    if ([fm fileExistsAtPath:path] == NO)
    {
        
        UIView *guideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 568 : 480))];
        guideView.tag = 5555;
        [self.view addSubview:guideView];
        [guideView release];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              guideView.frame.size.width,
                                                                              guideView.frame.size.height)];
        scroll.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
        scroll.contentSize = CGSizeMake(320, 960);
        scroll.contentOffset = CGPointMake(0, 960 - guideView.frame.size.height);
        [guideView addSubview:scroll];
        [scroll release];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 960)];
        imgV.image = [UIImage imageNamed:@"guide3dot0.png"];
        [scroll addSubview:imgV];
        [imgV release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((320 - 183)/2, 310, 183, 33)];
        [btn setTitle:LOCAL(@"guidebutton", @"") forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"guidebtnBack.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doStart:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:btn];
        
        
    }
    else
    {
        
    }

}

- (void)doStart:(id)sender
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:@"TestFirst"];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    UIView *v = (UIView *)[self.view viewWithTag:5555];
    [UIView animateWithDuration:0.5 animations:^{
        v.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
//    NSLog(@"%f",frame.origin.y);
    if (passWordField==textField || userNameField == textField)
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.25];
        
        
        frame.origin.y = 20 - (iphone5 ? 30 : 120);
//        frame.size.height +=50;
        self.view.frame = frame;
        
        [UIView commitAnimations];
    }
   
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    return YES;
    
}



-(void)backLogin111:(NSNotification *)no
{
    
    passWordField.text = @"";
    
    [UserLogin clearLastLogin];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loginBackground
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    
    UserLogin *user = [UserLogin currentLogin];


        [UserLogin clearLastLogin];
        [user updateLastLogin];
        //本地信息存储

    [self performSelectorOnMainThread:@selector(LoginSuccess) withObject:nil waitUntilDone:YES];
 
    [pool drain];                            
}

#pragma EKRequest_Delegate
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    NSLog(@"%@",error);
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    UserLogin *user=[UserLogin currentLogin];

    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
    NSLog(@"%@，%@",dic,[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    NSLog(@"error code %d",code);
    //登录成功后获取学生信息
    
    if (code == -1115) {
        
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    if(method == signin && code == 1)
    {
        id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        if ([result isKindOfClass:[NSDictionary class]])
        {
            [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
        }
        else if ([result isKindOfClass:[NSArray class]])
        {
            self.resultSelectChild = result;
            
            [ETCoreDataManager saveUserChildren:self.resultSelectChild ByAccount:userNameField.text];
            
            if (resultSelectChild.count <= 0)
            {
                if(HUD)
                {
                    [HUD removeFromSuperview];
                    HUD=nil;
                }
                
                // 提示 为空
            }
            else if (resultSelectChild.count == 1)// 如果为一个学生
            {
                NSDictionary *dic = [resultSelectChild objectAtIndex:0];
                NSString *cid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_class"]];
                NSString *stuid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_student"]];
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:cid, @"uid_class", stuid, @"uid_student", nil];
                
                user.uid_class = cid;
                user.uid_student = stuid;
                
                [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:POST forDelegate:self];
            }
            else    // 多个学生
            {
                
                if(HUD)
                {
                    [HUD removeFromSuperview];
                    HUD=nil;
                }
                
                NSMutableArray *titleArr = [NSMutableArray array];
                for (int i = 0; i < resultSelectChild.count; i++) {
                    NSDictionary *dic = [resultSelectChild objectAtIndex:i];
                    NSString *str = [NSString stringWithFormat:@"%@   %@",[dic objectForKey:@"nikename"],[dic objectForKey:@"classname"]];
                    [titleArr addObject:str];
                }
                
                
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"selectchild", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitlesArray:titleArr];
                alert.tag = 3333;
                [alert show];
            }
        }
        
      
    }    else if (method == unit && code == 1)
    {
//        NSString *s = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
        
        [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
    }
    //成功获取学生信息
    else if(method == student && code == 1)
    {
        user.regName=userNameField.text;
        user.passWord=passWordField.text;
        user.studentId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"studentid"]];
        user.age=[NSString stringWithFormat:@"%@",[dic objectForKey:@"age"]];
        user.birthday=[NSString stringWithFormat:@"%@",[dic objectForKey:@"birthday"]];
        user.cnname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
        user.enname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"enname"]];
        user.mobile=[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
        user.nickname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nikename"]];
        user.parent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"parent"]];
        user.sex=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
        user.className = [NSString stringWithFormat:@"%@",[dic objectForKey:@"classname"]];
        user.avatar = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        user.allowmutionline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"allow_muti_online"]];
        user.ischeck_mobile = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ischeck_mobile"]];
        user.skinid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skinid"]];
        user.username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        user.orderTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ordertitle"]];
        user.orderEndTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderendtime"]];

        [[EKRequest Instance] EKHTTPRequest:classinfo parameters:nil requestMethod:GET forDelegate:self];
        
        
        
        NSString *birthday=[NSString stringWithFormat:@"%@",[dic objectForKey:@"birthday"]];
      //   stri=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
        if(birthday)
        {
            NSArray *dateArr=[birthday componentsSeparatedByString:@"-"];
            
            int month=[[dateArr objectAtIndex:1] integerValue];
            int day=[[dateArr objectAtIndex:2] integerValue];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            UILocalNotification *local=[[[UILocalNotification alloc]init] autorelease];
            
            if(local)
            {
                
                
                NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
                
                NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
                
                [components setMonth:month];
                [components setDay:day];
                [components setHour:8];
                [components setMinute:1];
                [components setSecond:1];
                local.fireDate = [calendar dateFromComponents:components];
                NSLog(@"--------------------%@ -- %@ ",[calendar dateFromComponents:components],user.cnname);
                local.timeZone=[NSTimeZone defaultTimeZone];
                
                local.alertBody=[NSString stringWithFormat:@"宝宝%@的生日",user.cnname];
                local.alertAction=@"确定";
                local.soundName=UILocalNotificationDefaultSoundName;
                local.hasAction=YES;
                local.repeatInterval=NSYearCalendarUnit;
                
                // int count= [UIApplication sharedApplication].applicationIconBadgeNumber;
                local.applicationIconBadgeNumber=1;
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:user.cnname,@"birthday", nil];
                local.userInfo=dic;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:local];
                
            }
            
        }

        
        
    }
    else if(method == classinfo && code == 1)
    {
        
        NSDictionary * dic11 = [dic objectForKey:@"classinfo"];
        user.schoolname=[dic11 objectForKey:@"schoolname"];
        //ModifyData.Schoolname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"schoolname"]];
        //user.schoolname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"schoolname"]];
//         ModifyData.Schoolname=user.schoolname;
        [[EKRequest Instance] EKHTTPRequest:setting parameters:nil requestMethod:GET forDelegate:self];

    }
    else if(method == setting && code == 1)
    {
        NSDictionary * attendance_type = [dic objectForKey:@"attendance_type"];
        
        user.attendancetype = attendance_type;
//        user.pull_rate = [dic objectForKey:@"pull_rate_student"];
//        NSString *pStr = [NSString stringWithFormat:@"1310"];
//        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month",nil];
//        [[EKRequest Instance] EKHTTPRequest:attendance parameters:param requestMethod:GET forDelegate:self];
        
        [self loginBackground];
        
    }
    else
    {
        if(method==signin && code!=1)
        {
            [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"LoginErr",  @"") waitUntilDone:NO];
            return;
        }
        [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy",  @"网络故障,稍后请重试") waitUntilDone:NO];
    }
}
#pragma --
#pragma UITextView_Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}


/**
 *	@brief 日期比较.
 *  @param dateDic : 日期字典.
 *  @return 布尔值
 */
- (BOOL) compareDutyDate:(NSDictionary *) dateDic
{
    NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
    NSMutableString * year = [NSMutableString stringWithCapacity:1];
    [year setString:[NSString stringWithFormat:@"20%@",[attendaceday substringToIndex:2]]];
    NSString * month = [attendaceday substringWithRange:NSMakeRange(2, 2)];
    
    NSString * day = [attendaceday substringWithRange:NSMakeRange(4, 2)];
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate * myDate = [format dateFromString:dateStr];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:myDate];

    NSDateComponents *components_A = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSInteger myMonth = [components month];
    NSInteger currMonth = [components_A month];
    NSInteger myYear = [components year];
    NSInteger currYear = [components_A year];
    NSInteger myDay = [components month];
    NSInteger currDay = [components_A month];
    
    [format release];
    
    if(myMonth == currMonth && myYear == currYear && myDay == currDay)
        return YES;

    return NO;
}
- (IBAction)loginButonPressed:(id)sender {
    
    [self preferredStatusBarStyle];
    
    if(![NetWork connectedToNetWork])
    {
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if([userNameField.text isEqualToString:@""]||[passWordField.text isEqualToString:@""] || userNameField.text==nil || userNameField.text==nil)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"11" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
        
         ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"logininput", @"输入不能为空")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

//    UserLogin *user=[UserLogin currentLogin];
//    user.loginStatus=LOGIN_SERVER;

    else
    {
      [self Login];
    }

}


-(void)Login
{
    [self endEdit];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
        
    }
    [[EKRequest Instance]clearSid];
    NSLog(@"%@",delegate.token);
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameField.text,@"username",[MTAuthCode authEncode:self.passWordField.text authKey:@"mactop" expiryPeriod:0],@"password", delegate.token,@"token", nil];
    [[EKRequest Instance] EKHTTPRequest:signin parameters:param requestMethod:POST forDelegate:self];
    
    
    

}

- (void)changeChild
{
    
}


-(void)LoginFailedresult:(NSString *)str
{
    UserLogin *user=[UserLogin currentLogin];
    user.loginStatus=LOGIN_OFF;
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    
    

}


/// 登录成功

-(void)LoginSuccess
{
   
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    UserLogin *user=[UserLogin currentLogin];
    user.loginStatus=LOGIN_SERVER;
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
//    if (autoImgV.hidden)
//    {
//        [defaultUser removeObjectForKey:AUTOLOGIN];
//    }
//    else
//    {
    [defaultUser setObject:AUTOLOGINVALUE forKey:AUTOLOGIN];
    if (![defaultUser objectForKey:@"AutoPlay"]) {
        [defaultUser setObject:@"0" forKey:@"AutoPlay"];
    }

    [ETCoreDataManager saveUser];

    
    

        [defaultUser setObject:user.skinid forKey:@"HEADERBACKGROUND"];

    
    
    
    NSLog(@"auto  %@",[defaultUser objectForKey:AUTOLOGIN]);
    // 刷新tabbar 数据  应该刷新所有controller数据  首页 如果无数据应自动加载，其他清空 当点击时加载
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if (![userdefault objectForKey:SWITHGESTURE] || [[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"0"])
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"tishishoushi", @"提醒：为保证您的账户安全，请开启手势密码保护。") delegate:self cancelButtonTitle:LOCAL(@"skip", @"") otherButtonTitles:LOCAL(@"open", @""), nil];
        alert.tag=777;
        [alert show];
    }

    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    ETBottomViewController *bVC = [[ETBottomViewController alloc] init];
    delegate.bottomVC = bVC;
    [bVC release];
    
    ETBottomNavigationController *bNC = [[ETBottomNavigationController alloc] initWithRootViewController:delegate.bottomVC];
    delegate.bottomNav = bNC;
    [bNC release];
    
    
    [self presentModalViewController:delegate.bottomNav animated:YES];
    
    [delegate bind]; // 绑定推送
//    ETClassViewController *classVC = [[delegate.bottomVC.leveyTabBarController viewControllers] objectAtIndex:0];
//    [classVC slimeStartLoading];
    
    
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if(alertView.tag==777)
    {
        
        if(index==1)
        {
            AppDelegate *appDel = SHARED_APP_DELEGATE;
            ETChangeGestureViewController *gesVC = [[ETChangeGestureViewController alloc] init];
            [appDel.bottomNav pushViewController:gesVC animated:YES];
            [gesVC release];
            
            //            ETRePassWordViewController  *et=[[ETRePassWordViewController alloc]initWithNibName:@"ETRePassWordViewController" bundle:nil];
            //            [self.navigationController pushViewController:et animated:YES];
            //            [et release];
        }
        return;
    }
    else if (alertView.tag == 888)
    {
        if (index == 1) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",SERVICE_NUMBER];
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:num]];
        }
    }
    
    else if (alertView.tag == 3333)
    {
        if (index != resultSelectChild.count) { //如果不是最后一个按钮，即取消按钮
            
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            if(HUD==nil)
            {
                HUD=[[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:HUD];
                [HUD release];
                [HUD show:YES];
            }
            
            UserLogin *user = [UserLogin currentLogin];
            NSDictionary *dic = [resultSelectChild objectAtIndex:index];
            NSString *cid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_class"]];
            NSString *stuid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_student"]];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:cid, @"uid_class", stuid, @"uid_student", nil];
            
            user.uid_class = cid;
            user.uid_student = stuid;
            
            [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:POST forDelegate:self];
        }
    }
}

#pragma KeyBoard Hide
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
}
- (void)endEdit
{
    if ([passWordField isFirstResponder] || [userNameField isFirstResponder])
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.25];
        
        CGRect frame = self.view.frame;
        frame.origin.y = ios7 ? 0 : 20;
        
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}

#pragma --
#pragma UITextField_Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.userNameField])
       [self.passWordField becomeFirstResponder];
    if([textField isEqual:self.passWordField])
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
#pragma --
- (void)dealloc {
    self.userNameField=nil;
    self.passWordField=nil;
    self.leveyTabBarController=nil;
    
    self.setNavigation=nil;
    self.childNavigation=nil;
    self.shareNavigation=nil;
    self.noticeNavigation=nil;
    
    [_loginBtn release];
    

    
    [titleImgV release];
    [versionImgV release];
    [loginBackImgV release];
    [accountImgV release];
    [pwdImgV release];
    [super dealloc];
}
- (void)viewDidUnload {
    self.leveyTabBarController=nil;
    
    self.setNavigation=nil;
    self.childNavigation=nil;
    self.shareNavigation=nil;
    self.noticeNavigation=nil;
    [self setUserNameField:nil];
    [self setPassWordField:nil];
    
    [self setLoginBtn:nil];
    [titleImgV release];
    titleImgV = nil;
    [versionImgV release];
    versionImgV = nil;
    [loginBackImgV release];
    loginBackImgV = nil;
    [accountImgV release];
    accountImgV = nil;
    [pwdImgV release];
    pwdImgV = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    
//    return NO;
//    
//}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
