//
//  ClassInfo.m
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "ClassInfo.h"

@implementation ClassInfo
@synthesize address=_address;
@synthesize city=_city;
@synthesize classid=_classid;
@synthesize classname=_classname;
@synthesize phone=_phone;
@synthesize province=_province;
@synthesize schoolname=_schoolname;
@synthesize uid;

-(void)dealloc
{
    self.address=nil;
    self.city=nil;
    self.classid=nil;
    self.classname=nil;
    self.phone=nil;
    self.province=nil;
    self.schoolname=nil;
    self.uid=nil;
    [super dealloc];
}

@end


