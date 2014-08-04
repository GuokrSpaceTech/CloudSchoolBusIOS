//
//  GKReport.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReport.h"

@implementation GKReport
@synthesize title,reportid,contentArr,teachername,studentArr,createtime,type,reporttime,reportname;
-(id)init
{
    if(self=[super init])
    {
        contentArr=[[NSMutableArray alloc]init];
    }

    return self;
}
-(void)dealloc
{
    self.type=nil;
    self.title=nil;
    self.reportid=nil;
    self.contentArr=nil;
    self.teachername=nil;
    self.createtime=nil;
    self.studentArr=nil;
    self.reportname=nil;
    self.reporttime=nil;
    [super dealloc];
}
@end
