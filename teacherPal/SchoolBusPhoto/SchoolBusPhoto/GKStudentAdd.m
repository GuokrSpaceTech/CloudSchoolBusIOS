//
//  GKStudentAdd.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKStudentAdd.h"

@implementation GKStudentAdd
-(id)init
{
    if(self=[super init])
    {
        self.isSelect=NO;
    }
    return self;
}
-(void)dealloc
{
    self.classUID=nil;
    self.classID=nil;;
    self.studentID=nil;
    self.studentUID=nil;
    self.studentName=nil;
    self.parentTel=nil;
    self.birthday=nil;;

    self.className=nil;
    
    [super dealloc];
}
@end
