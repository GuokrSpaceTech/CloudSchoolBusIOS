//
//  CBLoginInfo.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBLoginInfo.h"
#import "School.h"
#import "Student.h"
#import "RCIM.h"
#import "CBDateBase.h"
@implementation CBLoginInfo
static CBLoginInfo * logininfo = nil;
+ (CBLoginInfo*)shareInstance
{
    if(logininfo == nil)
    {
        logininfo = [[self alloc]init];
    }
    return logininfo;
}
-(void)getSid:(NSDictionary *)parm
{
    [[EKRequest Instance] EKHTTPRequest:login parameters:parm requestMethod:POST forDelegate:self];
}
-(void)getBaseInfo
{
    [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:self];
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    if(method == login)
    {
        if(self.successBlock)
        {
            self.successBlock(NO);
        }
    }
    else if (method == baseinfo)
    {
        if(self.baseInfoBlock)
        {
            self.baseInfoBlock(NO);
        }
    }
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    if(method == login && [[param allKeys] containsObject:@"token"])
    {
        if(code == 1)
        {
            
            NSDictionary * dic = response;
            NSString * sid = dic[@"sid"];
           
            NSString * rogngyuntoken =dic[@"rongtoken"];
            self.rongToken = rogngyuntoken;
        
            _sid = sid;
            _state = LoginOn;
            [[CBDateBase sharedDatabase] insertDataToLoginInfoTable:@([self.userid intValue]) token:self.token phone:self.phone sid:self.sid rong:self.rongToken];
            
            [self connectRongYun];
            self.successBlock(YES);
        }
        else
        {
            self.successBlock(NO);
        }
    }
    else if(method == baseinfo)
    {
        if(code == 1)
        {
            NSDictionary * baseinfo = response;
            NSArray * schoolarr = baseinfo[@"schools"];
            for (int i = 0; i < schoolarr.count; i++) {
                NSDictionary * schooldic = schoolarr[i];
                School * school = [[School alloc]initWithSchoolDic:schooldic];
                [_schoolArr addObject:school];
            }
            
            
            NSArray * stuArr = baseinfo[@"students"];
            for (int i=0; i<stuArr.count; i++) {
                Student * st = [[Student alloc]initWithDic:stuArr[i]];
                if(i == 0)
                {
                    _currentStudentId = st.studentid;
                }
                [_studentArr addObject:st];
            }
            _isRequesBaseInfo = YES;
            self.baseInfoBlock(YES);
            
        }
        else
        {
            self.baseInfoBlock(NO);
        }
    }


}
-(void)destory
{
    logininfo = nil;
}
-(instancetype)init
{
    if(self = [super init])
    {
        _schoolArr = [[NSMutableArray alloc]init];
        _studentArr = [[NSMutableArray alloc]init];
        _state = LoginOff;
        _isRequesBaseInfo = NO;
    }
    return self;
}
-(void)baseInfoIsExist:(sessionNotOver)block
{
    self.baseInfoBlock = block;
    
    [self loginSid:^(BOOL isLogin) {
        if(isLogin)
        {
            if(_isRequesBaseInfo)
            {
                self.baseInfoBlock(YES);
            }
            else
            {
                [self getBaseInfo];
            }
        }
    }];
    

    
}
-(void)loginSid:(loginSuccess)block
{
    self.successBlock = block;
    
    if(self.state == LoginOn)
    {
        block(YES);
    }
    else
    {
        NSDictionary * dic = @{@"mobile":self.phone,@"token":self.token};
        [self getSid:dic];
    }
}
-(void)getSid
{
    
}
-(void)connectRongYun
{
    [[RCIM sharedRCIM] disconnect];
    [RCIM connectWithToken:self.rongToken completion:^(NSString *userId) {
        NSLog(@"--------  %@ ------",userId);
    } error:^(RCConnectErrorCode status) {
        
    }];
}
@end
