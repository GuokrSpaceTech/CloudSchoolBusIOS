//
//  StudentDuty.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "StudentDuty.h"

@implementation StudentDuty
@synthesize inTime,outTime,date,result;
@synthesize year,month,day;
-(void)dealloc
{
    self.inTime=nil;
    self.outTime=nil;
    self.date=nil;
    self.result=nil;
    [super dealloc];
}
@end
