//
//  GKReportModel.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-30.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportModel.h"

@implementation GKReportModel
@synthesize reportid,type,questionArr;
@synthesize name;
-(void)dealloc
{
    self.reportid=nil;
    self.type=nil;
    self.questionArr=nil;
    self.name=nil;
    [super dealloc];
}
-(id)init
{
    if(self=[super init])
    {
        questionArr=[[NSMutableArray alloc]init];
    }
    return self;
}
@end
