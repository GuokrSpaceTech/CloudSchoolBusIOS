//
//  School.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "School.h"
#import "ClassObj.h"
#import "Tag.h"
@implementation School
-(instancetype)initWithSchoolDic:(NSDictionary *)schooldic
{
    if(self = [super init])
    {
        _classesArr = [[NSMutableArray alloc]init];
        _tagsArr = [[NSMutableArray alloc]init];
        
        _address = schooldic[@"address"];
        
        NSArray *classArr = schooldic[@"classes"];
        for (int i = 0; i < classArr.count; i++) {
            ClassObj *obj = [[ClassObj alloc]initWithClassDic:classArr[i]];
            
            [_classesArr addObject:obj];
        }
        
        _schoolid = [NSString stringWithFormat:@"%@",schooldic[@"schoolid"]];
        _schoolName = schooldic[@"schoolname"];
        _cover = schooldic[@"cover"];
        _logo = schooldic[@"logo"];
        
        NSArray *tagarr = schooldic[@"tags"];
        
        for (int i = 0; i < tagarr.count; i++) {
            Tag *tag = [[Tag alloc]initWithDic:tagarr[i]];
            [_tagsArr addObject:tag];
        }
        
    }
    return self;
}
@end
