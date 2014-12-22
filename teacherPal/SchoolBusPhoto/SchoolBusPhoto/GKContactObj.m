//
//  GKContactObj.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-18.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKContactObj.h"

@implementation GKContactObj
-(void)dealloc
{
    self.cnname=nil;
    self.content=nil;
    self.type=nil;
    self.from_id=nil;
    self.state=nil;
    [super dealloc];
}
@end
