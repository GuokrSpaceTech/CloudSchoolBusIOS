//
//  ProblemDetail.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ProblemDetail.h"

@implementation ProblemDetail
-(id)init
{
    if(self=[super init])
    {
        _contentArr=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)dealloc
{
    self.contentid=nil;
    self.created_time_ms=nil;
    self.type=nil;
    self.contentArr=nil;
    [super dealloc];
}
@end
