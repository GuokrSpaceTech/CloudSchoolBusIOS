//
//  GKDvrObj.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKDvrObj.h"

@implementation GKDvrObj
-(void)dealloc
{
    self.channeldesc=nil;
    self.channelid=nil;
    self.dvr_name=nil;
    self.dvrid=nil;
    [super dealloc];
}
@end
