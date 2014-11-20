//
//  GKAttentanceObj.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-17.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKAttentanceObj.h"

@implementation GKAttentanceObj
@synthesize stuentid;
@synthesize attendanceArr;
@synthesize cnname;
@synthesize isAttence;
-(id)init
{
    if(self=[super init])
    {
        attendanceArr=[[NSMutableArray alloc]init];
    }
    
    return self;
}

-(void)dealloc
{
    self.stuentid=nil;
    self.attendanceArr=nil;
    self.cnname=nil;
    [super dealloc];
}
@end
