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
//@synthesize cBlock;

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
    
    [[EKRequest Instance] clearSid];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:cid, @"uid_class", stuid, @"uid_student", nil];
    [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:POST forDelegate:self];
}


- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    UserLogin *user = [UserLogin currentLogin];
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
    
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
        
//        if (param == nil) {
//            
//            [ETCommonClass logoutAndClearUserMessage];
//            
//        }else{
//            user.loginStatus=LOGIN_SERVER;
////            [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
//            
//            NSString *pid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]];
//            user.pid = pid;
//            
//            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pid,@"parentid", nil];
//            
//            [[EKRequest Instance] EKHTTPRequest:unit parameters:param requestMethod:GET forDelegate:self];
//            
//        }
        
        
    }
    else if (method == unit && code == 1)
    {
        user.loginStatus=LOGIN_SERVER;
        
        
        if ([param objectForKey:@"uid_class"] && [param objectForKey:@"uid_student"])
        {
            user.uid_class = [param objectForKey:@"uid_class"];
            user.uid_student = [param objectForKey:@"uid_student"];
        }
        
        
        [[EKRequest Instance] EKHTTPRequest:student parameters:nil requestMethod:GET forDelegate:self];
    }
    
    //成功获取学生信息
    else if(method == student && code == 1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
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
        [[EKRequest Instance] EKHTTPRequest:classinfo parameters:nil requestMethod:GET forDelegate:self];
        
        
    }
    else if(method == classinfo && code == 1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        NSDictionary * dic11 = [dic objectForKey:@"classinfo"];
        user.schoolname = [dic11 objectForKey:@"schoolname"];
        
        [[EKRequest Instance] EKHTTPRequest:setting parameters:nil requestMethod:GET forDelegate:self];
        
    }
    else if(method == setting && code == 1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
        NSDictionary * attendance_type = [dic objectForKey:@"attendance_type"];
        
        user.attendancetype = attendance_type;
        
        cBlock(nil);
//        NSString *pStr = [NSString stringWithFormat:@"1310"];
//        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month",nil];
//        
//        [[EKRequest Instance] EKHTTPRequest:attendance parameters:nil requestMethod:GET forDelegate:self];
    }
    else if(method == attendance && code == 1)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        NSLog(@"%@",dic);
        cBlock(nil);
    }
    else
    {
        NSError *err = [[[NSError alloc] initWithDomain:@"login" code:code userInfo:nil] autorelease];
        cBlock(err);
    }
    
    
}
- (void)getErrorInfo:(NSError *)error
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

- (void)dealloc
{
    [cBlock release];
    [super dealloc];
}


@end
