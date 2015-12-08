//
//  Tag.m
//  CloudBusParent
//
//  Created by wenpeifang on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Tag.h"

@implementation Tag
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _isdelete = [NSString stringWithFormat:@"%@",dic[@"isdelete"]];
        _schoolid = [NSString stringWithFormat:@"%@",dic[@"schoolid"]];
        _tagid = [NSString stringWithFormat:@"%@",dic[@"tagid"]];
        _tagname = [NSString stringWithFormat:@"%@",dic[@"tagname"]];
        _tagname_en = [NSString stringWithFormat:@"%@",dic[@"tagname_en"]];
        _tagnamedesc = [NSString stringWithFormat:@"%@",dic[@"tagnamedesc"]];
        _tagnamedesc_en = [NSString stringWithFormat:@"%@",dic[@"tagnamedesc_en"]];
    }
    return self;
}
@end
