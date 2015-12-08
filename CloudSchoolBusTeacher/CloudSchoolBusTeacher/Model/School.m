//
//  School.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "School.h"
#import "ClassModule.h"
#import "Tag.h"
@implementation School
-(instancetype)initWithSchoolDic:(NSDictionary *)schooldict
{
    if(self = [super init])
    {
        _remark = schooldict[@"remark"];
        _address = schooldict[@"address"];
        _groupid = schooldict[@"groupid"];
        _id = schooldict[@"id"];
        _tags = [[NSMutableArray alloc]init];
        NSArray *tagsArr = schooldict[@"tags"];
        for (int i = 0; i < tagsArr.count; i++) {
            Tag *tag = [[Tag alloc]initWithDic:tagsArr[i]];
            [_tags addObject:tag];
        }
        
        NSDictionary *settings=schooldict[@"settings"];
        NSArray *classModuleDictArr = settings[@"class_module"];
        _classModuleArr = [[NSMutableArray alloc] init];
        for(int i=0; i<classModuleDictArr.count; i++)
        {
            ClassModule *module = [[ClassModule alloc]initWithModuleDict:classModuleDictArr[i]];
            [_classModuleArr addObject:module];
        }
        
        _messageTypeArr = [[NSMutableArray alloc] init];
        _messageTypeArr = settings[@"message_type"];
        
        _cover = schooldict[@"cover"];
        _name = schooldict[@"name"];
        _logo = schooldict[@"logo"];
    }
    return self;
}
@end
