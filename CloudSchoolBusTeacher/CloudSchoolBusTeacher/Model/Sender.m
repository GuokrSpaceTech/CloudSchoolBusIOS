//
//  Sender.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Sender.h"

@implementation Sender
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _avatar = dic[@"avatar"];
        _classname = dic[@"classname"];
        _senderid = [NSString stringWithFormat:@"%@",dic[@"id"]];
        _name = dic[@"name"];
        _role = [NSString stringWithFormat:@"%@",dic[@"role"]];
    }
    return self;
}
@end
