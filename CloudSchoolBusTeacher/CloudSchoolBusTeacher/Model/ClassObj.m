//
//  ClassObj.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "ClassObj.h"
#import "Teacher.h"
@implementation ClassObj
-(instancetype)initWithClassDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _teacherArr = [[NSMutableArray alloc]init];
        
        _classid = dic[@"classid"];
        _className = dic[@"classname"];
        _schoolid = dic[@"schoolid"];
        _dutyid = dic[@"dutyid"];
        _remark = dic[@"remark"];
        
        _studentidArr = dic[@"student"];
        
        NSArray * arr = dic[@"teacher"];
        for (int i = 0; i < arr.count; i++) {
            Teacher *teacher = [[Teacher alloc]initWithDic:arr[i]];
            teacher.className = _className;
            [_teacherArr addObject:teacher];
        }
        
    }
    return self;
}
@end
