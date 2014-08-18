//
//  GKTempature.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKTempature.h"

@implementation GKTempature
-(void)dealloc
{
    self.name=nil;
    self.tempature=nil;
    self.state=nil;
    self.otherstate=nil;
    self.studentid=nil;
  
    [super dealloc];
}
@end
