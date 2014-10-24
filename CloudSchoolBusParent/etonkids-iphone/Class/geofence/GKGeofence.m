//
//  GKGeofence.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-10-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKGeofence.h"

@implementation GKGeofence
@synthesize geofenceid,name;
-(void)dealloc
{
    self.geofenceid=nil;
    self.name=nil;
    [super dealloc];
}
@end
