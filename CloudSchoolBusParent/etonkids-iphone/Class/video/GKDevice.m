//
//  GKDevice.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKDevice.h"

@implementation GKDevice

@synthesize svrname,svrid,status,svrchns;

-(void)dealloc
{
    self.svrchns=nil;
    self.svrid=nil;
    self.status=nil;
    self.svrname=nil;
    [super dealloc];
}

//@property (nonatomic,retain)NSString *svrid;
//@property (nonatomic,retain)NSString *svrname;
//@property (nonatomic,retain)NSString *status;
//@property (nonatomic,retain)NSString *svrchns;
@end
