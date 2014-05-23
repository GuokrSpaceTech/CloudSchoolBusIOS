//
//  GKTeacher.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-9.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKTeacher.h"

@implementation GKTeacher
-(void)dealloc
{
    
    self.avatar=nil;
    self.ismainid=nil;
    self.mobile=nil;
    self.nikename=nil;
    self.teacherid=nil;
    self.teachername=nil;
    self.sex=nil;
    [super dealloc];
}
@end
