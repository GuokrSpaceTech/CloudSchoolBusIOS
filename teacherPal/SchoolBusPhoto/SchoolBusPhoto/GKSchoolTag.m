//
//  GKSchoolTag.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-24.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSchoolTag.h"

@implementation GKSchoolTag
-(void)dealloc
{
    self.tagdesc=nil;
    self.tagdesc_en=nil;
    self.tagid=nil;
    self.tagname=nil;
    self.tagname_en=nil;
    [super dealloc];
}
@end
