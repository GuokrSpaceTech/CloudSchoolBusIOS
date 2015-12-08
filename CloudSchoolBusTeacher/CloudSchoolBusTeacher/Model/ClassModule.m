//
//  ClassModule.m
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/8/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "ClassModule.h"

@implementation ClassModule
-(instancetype)initWithModuleDict:(NSDictionary *)classModule
{
    if(self = [super init])
    {
        _title = classModule[@"title"];
        _icon  = classModule[@"icon"];
        _url   = classModule[@"url"];
    }
    return self;
}
@end
