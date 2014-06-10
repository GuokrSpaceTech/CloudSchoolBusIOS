//
//  GKAttentance.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKAttentance.h"

@implementation GKAttentance

-(void)dealloc
{

    
    self.studentName=nil;
    self.intime=nil;
    self.outavater=nil;
    self.outtime=nil;
    self.inavater=nil;
    self.studentId=nil;
    [super dealloc];
}
@end
