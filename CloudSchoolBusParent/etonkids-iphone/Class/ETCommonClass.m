//
//  ETCommonClass.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETCommonClass.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "EKRequest.h"
#import "MTAuthCode.h"
#import "ETCoreDataManager.h"
#import "ETLoginViewController.h"

@implementation ETCommonClass
@synthesize preSid;

- (void)requestLoginWithComplete:(CompleteBlock)block
{
    
    cBlock = [block copy];
    UserLogin *user = [UserLogin currentLogin];
    
    if (user.loginStatus == LOGIN_OFF)
    {
        AppDelegate *delegate = SHARED_APP_DELEGATE;
        
        [[EKRequest Instance]clearSid];
        
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:user.regName,@"username",[MTAuthCode authEncode:user.passWord authKey:@"mactop" expiryPeriod:0],@"password", delegate.token,@"token", nil];
        
        [[EKRequest Instance] EKHTTPRequest:signin parameters:param requestMethod:POST forDelegate:self];
        
    }
    else
    {
        cBlock(nil);
        
    }
    
}

- (void)changeChildByClass:(NSString *)cid student:(NSString *)stuid WithComplete:(CompleteBlock)block
{
    cBlock = [block copy];
    
    
    
    if ([[EKRequest Instance] userSid] != nil)
    {
        self.preSid = [NSString stringWithFormat:@"%@",[[EKRequest Instance] userSid]];
    }
    
    [[EKRequest Instance] clearSid];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:cid, @"uid_class", stuid, @"uid_student", nil];
    [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:POST forDelegate:self];
}


- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    UserLogin *user = [UserLogin currentLogin];
    
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
    
    if (method == signin)
    {
        
        if (param != nil) {
            if (code == 1)
            {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:user.uid_class, @"uid_class", user.uid_student, @"uid_student", nil];
                [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:POST forDelegate:self];
            }
        }
        
        else
        {
            if (code == 1)
            {
                [ETCommonClass logoutAndClearUserMessage];
            }
            
        }
        
        
    }
    else if (method == unit && code == 1)
    {
        user.loginStatus=LOGIN_SERVER;
        [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
    }
    
    //成功获取学生信息
    else if(method == student && code == 1)
    {
        id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"学生信息返回格式错误");
            return;
        }
        NSDictionary *dic = result;
        NSLog(@"%@",dic);

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
        user.uid_student = [NSString stringWithFormat:@"%@",[dic objectForKey:@"student_uid"]];
        user.inactive=[NSString stringWithFormat:@"%@",[dic objectForKey:@"inactive"]];
        user.healtState=[NSString stringWithFormat:@"%@",[dic objectForKey:@"healthstate"]];
        user.tuition_time=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tuition_time"]];
        [[EKRequest Instance] EKHTTPRequest:classinfo parameters:nil requestMethod:GET forDelegate:self];
        
        
    }
    else if(method == classinfo && code == 1)
    {
        id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"班级信息返回格式错误");
            return;
        }
        NSDictionary *dic = result;
        NSDictionary * dic11 = [dic objectForKey:@"classinfo"];
        user.schoolname = [dic11 objectForKey:@"schoolname"];
        user.uid_class = [NSString stringWithFormat:@"%@",[dic11 objectForKey:@"uid"]];
        
        [[EKRequest Instance] EKHTTPRequest:setting parameters:nil requestMethod:GET forDelegate:self];
        
    }
    else if(method == setting && code == 1)
    {
        id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"setting接口返回格式错误");
            return;
        }
        NSDictionary *dic = result;
        
        NSDictionary * attendance_type = [dic objectForKey:@"attendance_type"];
        
        user.attendancetype = attendance_type;
        [ETCoreDataManager saveUser];
        cBlock(nil);
    }
    else if (code == -1115)
    {
        
        if (preSid != nil) {
            [[EKRequest Instance] saveUserSid:preSid];
        }
        
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        NSError *err = [[[NSError alloc] initWithDomain:@"login" code:code userInfo:nil] autorelease];
        cBlock(err);
    }
    else
    {
        NSError *err = [[[NSError alloc] initWithDomain:@"login" code:code userInfo:nil] autorelease];
        cBlock(err);
    }
    
    
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    cBlock(error);
}


+ (void)logoutAndClearUserMessage
{
    [[EKRequest Instance] clearSid];
    
    [UserLogin clearLastPassword];
    
    [ETCommonClass clearUserMessage];
    
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    appDel.loginViewController.passWordField.text = @"";
//    appDel.loginViewController.remImgV.hidden = YES;
//    appDel.loginViewController.autoImgV.hidden = YES;
    
    
    [appDel.bottomNav dismissModalViewControllerAnimated:YES];
}

+ (void)clearUserMessage
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    [userdefault setObject:@"0" forKey:SWITHGESTURE];
    [userdefault removeObjectForKey:AUTOLOGIN];
    [userdefault removeObjectForKey:REMEMBERPSAAWORD];
//    [userdefault removeObjectForKey:GESTUREPASSWORD];
    [userdefault removeObjectForKey:@"TEXTFONT"];
    
    //    NSLog(@"%@,%@",[userdefault objectForKey:AUTOLOGIN],[userdefault objectForKey:REMEMBERPSAAWORD]);
    
    [ETCoreDataManager removeAllActivity];
    [ETCoreDataManager removeAllArticalData];
    [ETCoreDataManager removeAllMyActivity];
    [ETCoreDataManager removeAllNotices];
    [ETCoreDataManager removeAllFood];
    [ETCoreDataManager removeAllSchedule];
    [ETCoreDataManager removeAllNoStartActivity];
    [ETCoreDataManager removeAllImportantNotices];
    [ETCoreDataManager removeAllCalendar];
    [ETCoreDataManager removeAllAttendance];
    
    
}


- (void)mutiDeviceLogin
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"mutilDevice", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    
    UserLogin * user = [UserLogin currentLogin];
    if(user.loginStatus==LOGIN_OFF)
    {
        
        [ETCommonClass logoutAndClearUserMessage];
        return;
    }
    
    
    [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
}


+ (void)createHelpWithTag:(int)tag image:(UIImage *)img
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"help_%d",tag]];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    //判断文件是否存在，判断是否第一次运行程序
    if ([fm fileExistsAtPath:path] == NO)
    {
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIImageView *helpImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, del.window.frame.size.width, del.window.frame.size.height)];
        helpImgV.userInteractionEnabled = YES;
        helpImgV.tag = tag; 
        helpImgV.image = img;
        [del.window addSubview:helpImgV];
        [helpImgV release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[ETCommonClass class] action:@selector(removeHelp:)];
        [helpImgV addGestureRecognizer:tap];
        [tap release];
        
    }
}
+ (void)removeHelp:(UIGestureRecognizer *)sender
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //拼接文件路径
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"help_%d",sender.view.tag]];
    //调用文件管理器
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}


- (void)dealloc
{
    [cBlock release];
    [super dealloc];
}


@end
