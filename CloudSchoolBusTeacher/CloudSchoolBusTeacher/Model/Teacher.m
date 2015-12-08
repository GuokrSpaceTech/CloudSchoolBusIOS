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
        _avatar = dic[@"avatar"];
        _duty = dic[@"duty"];
        _teacherid = [NSString stringWithFormat:@"%@",dic[@"id"]];
        _name = dic[@"name"];
    }
    return self;
}
@end
