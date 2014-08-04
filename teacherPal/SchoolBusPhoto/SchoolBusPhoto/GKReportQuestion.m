//
//  GKReportQuestion.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-30.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportQuestion.h"

@implementation GKReportQuestion
@synthesize type,title,op1,op2,op3;

-(void)dealloc
{
    self.title=nil;
    self.type=nil;
    self.op3=nil;
    self.op1=nil;
    self.op2=nil;
    [super dealloc];
}
@end
