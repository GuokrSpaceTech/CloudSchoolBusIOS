//
//  Teacher.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _dutyid = dic[@"dutyid"];
        _mobile = dic[@"mobile"];
        _schoolid = dic[@"schoolid"];
        _nickname = dic[@"nickname"];
        _avatar = dic[@"avatar"];
        _classes = dic[@"classes"];
        _teacherid = dic[@"teacherid"];
        _realname = dic[@"realname"];
        _duty = dic[@"duty"];
        _sex = dic[@"sex"];
        _pictureid = dic[@"pictureid"];
        
        _name = dic[@"name"];
    }
    return self;
}
@end
