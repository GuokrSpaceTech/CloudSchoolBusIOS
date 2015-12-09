//
//  Parents.m
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/9/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "Parents.h"

@implementation Parents
-(instancetype)initWithParentsDict:(NSDictionary *)parentsDict
{
    if(self = [super init])
    {
        _mobile = parentsDict[@"mobile"];
        _avatar  = parentsDict[@"avatar"];
        _parentid = parentsDict[@"parentid"];
        _nickname = parentsDict[@"nickname"];
        _studentids = parentsDict[@"studentids"];
        _relationship = parentsDict[@"relationship"];
        _pictureid   = parentsDict[@"pictureid"];
    }
    return self;
}
@end
