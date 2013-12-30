//
//  Student.m
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "Student.h"

@implementation Student


@synthesize  absence,
avatar,
age,
birthday,
cnname,
enname,
filesize,
isabsence,
isattendance,
islock,
mobile,
sex,
studentid,
studentno,
isinstalled,
online,
uid,
stunumber;

-(void)dealloc
{
    self.absence=nil;
    self.avatar=nil;
    self.birthday=nil;
    self.cnname=nil;
    self.enname=nil;
    self.filesize=nil;
    self.isattendance=nil;
    self.isabsence=nil;
    self.islock=nil;
    self.mobile=nil;
    self.sex=nil;
    self.studentid=nil;
    self.studentno=nil;
    self.isinstalled=nil;
    self.online=nil;
    self.age=nil;
    self.uid=nil;
    self.stunumber=nil;
    [super dealloc];
}
@end
