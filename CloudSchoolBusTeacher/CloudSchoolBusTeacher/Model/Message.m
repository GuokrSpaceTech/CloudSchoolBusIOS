//
//  Message.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Message.h"

@implementation Message
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _desc = dic[@"description"];
        _messageid = [NSString stringWithFormat:@"%@",dic[@"messageid"]];
        _apptype = [NSString stringWithFormat:@"%@",dic[@"apptype"]];
        _ismass = [NSString stringWithFormat:@"%@",dic[@"ismass"]];
        _body = dic[@"body"];
        _sendtime = [NSString stringWithFormat:@"%@",dic[@"sendtime"]];
        _title = dic[@"title"];
        _tag = dic[@"tag"];
        _isconfirm = [NSString stringWithFormat:@"%@",dic[@"isconfirm"]];
        _isreaded = [NSString stringWithFormat:@"%@",dic[@"isreaded"]];
        _studentid = [NSString stringWithFormat:@"%@",dic[@"studentid"]];
        
        NSDictionary * tmp = dic[@"sender"];
        _sender = [[Sender alloc]initWithDic:tmp];
        
    }
    return self;
}
-(id)bodyObject
{
    NSData * data = [_body dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
    return obj;
}
@end
