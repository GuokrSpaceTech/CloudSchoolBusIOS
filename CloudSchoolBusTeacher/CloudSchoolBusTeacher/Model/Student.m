//
//  Student.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Student.h"

@implementation Student
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _studentid = [NSString stringWithFormat:@"%@",dic[@"studentid"]];
        _sex = [NSString stringWithFormat:@"%@",dic[@"sex"]];
        _cnname = [NSString stringWithFormat:@"%@",dic[@"cnname"]];
        _avatar = [NSString stringWithFormat:@"%@",dic[@"avatar"]];
        _nickname = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
        _classid = dic[@"classid"];
        _classids = dic[@"classids"];
        _birthday = [NSString stringWithFormat:@"%@",dic[@"birthday"]];
        _pictureid = dic[@"pictureid"];
        _relaton = [NSString stringWithFormat:@"%@",dic[@"relation"]];
    }
    return self;
}
@end
