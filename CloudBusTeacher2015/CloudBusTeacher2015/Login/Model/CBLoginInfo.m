//
//  CBLoginInfo.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBLoginInfo.h"

#import <RongIMKit/RongIMKit.h>
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
-(void)getBaseInfo:(sessionNotOver)block
{
    //Try to load form DB first
\
//    [[EKRequest Instance] EKHTTPRequest:baseinfo  parameters:nil requestMethod:POST forDelegate:self];
}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{

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
        _hasValidBaseInfo = NO;
        _teacherVCIsLoading = NO;
    }
    return self;
}
-(void)baseInfoIsExist:(sessionNotOver)block
{
    self.baseInfoBlock = block;
    
    [self loginSid:^(BOOL isLogin) {
        if(isLogin)
        {
            [self getBaseInfo:block];
//            if(_hasValidBaseInfo)
//            {
//                self.baseInfoBlock(YES);
//            }
//            else
//            {
//                [self getBaseInfo];
//            }
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
    [[RCIM sharedKit] disconnect];
    [[RCIM sharedKit] connectWithToken:self.rongToken success:^(NSString *userId) {
        
    } error:^(RCConnectErrorCode status) {
        
    }];

}
@end
