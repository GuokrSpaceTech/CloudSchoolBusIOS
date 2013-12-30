//
//  GKUpObject.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-13.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKUpObject.h"

@implementation GKUpObject
@synthesize ftime,image,introduce,name,nameID;

-(void)dealloc
{
    self.ftime=nil;
    self.image=nil;
    self.introduce=nil;
    self.nameID=nil;
    self.name=nil;
    [super dealloc];
}
@end



