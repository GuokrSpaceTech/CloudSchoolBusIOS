//
//  GKChildReceiver.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-10.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKChildReceiver.h"

@implementation GKChildReceiver
@synthesize receiverid,pid,filepath,relationship;

-(void)dealloc
{
    self.receiverid=nil;
    self.pid=nil;
    self.filepath=nil;
    self.relationship=nil;
    [super dealloc];
}
@end
