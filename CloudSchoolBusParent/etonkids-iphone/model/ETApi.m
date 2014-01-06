//
//  ETApi.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 3/8/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ETApi.h"

#define MT_ERR_OK               0
#define MT_ERR_WRONG_NETWORK    10001
#define MT_ERR_WRONG_USER       10002
#define MT_ERR_WRONG_PASS       10003

#define MT_ERR_NOEXIST_STUDENT  10005
#define MT_ERR_NOEXIST_CLASS    10006
#define MT_ERR_WRONG_EMAIL      10008
#define MT_ERR_WRONG_INVITECODE 10009

@implementation ETApi

//10001	网络故障
//10002	账号不存在
//10003	密码错误

+ (NSString*)errStrFromCode:(NSInteger)errCode
{
    switch (errCode)
    {
        case MT_ERR_OK:
            return @"操作成功!";
            
        case MT_ERR_WRONG_PASS:
            return @"密码错误";
        case MT_ERR_WRONG_NETWORK:
            return @"网络错误";
        case MT_ERR_WRONG_USER:
            return @"用户名不存在";
        case MT_ERR_NOEXIST_STUDENT:
            return @"学生不存在";
        case MT_ERR_NOEXIST_CLASS:
            return @"班级不存在";
        case MT_ERR_WRONG_EMAIL:
            return @"邮箱不存在";
        case MT_ERR_WRONG_INVITECODE:
            return @"邀请码错误";
            
    }
    
    return [[[NSString alloc] initWithFormat:@"不能识别的错误代码: %d", errCode] autorelease];
}


+(NSString *)askUrl:(NSString *)Name
{
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",SERVERURL,Name]);
    return [NSString stringWithFormat:@"%@%@",SERVERURL,Name];
}

+(id)requestData:(NSString *)urlString
              httpMethod:(NSString *)method
                httpBody:(id)bodyData

{
       NSMutableURLRequest *requeset=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    requeset.HTTPMethod=method;
    
    
    NSData * data = nil;
    if([bodyData isKindOfClass:[NSString class]])
    {
        data=[bodyData dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:bodyData];
    }
    
    [requeset setHTTPBody:data];
    
    NSError *err=nil;
    
    NSData *requstData=[NSURLConnection sendSynchronousRequest:requeset returningResponse:nil error:&err];
    
    NSString *str=[[NSString alloc]initWithData:requstData encoding:NSUTF8StringEncoding];

    if(!err)
    {
        return [NSJSONSerialization JSONObjectWithData:requstData options:nil error:&err];
    }
    

    return nil;
    
    
    
    
}




@end
