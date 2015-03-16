//
//  GKRoute.m
//  etonkids-iphone
//
//  Created by wen peifang on 15-3-16.
//  Copyright (c) 2015年 wpf. All rights reserved.
//

#import "GKRoute.h"

@implementation GKRoute
-(id)init
{
    if(self=[super init])
    {
        _stationList=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)dealloc
{
    self.stationList=nil;
    self.routename=nil;
    [super dealloc];
}
@end
