//
//  StudentDutySameYearMonth.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "StudentDutySameYearMonth.h"

@implementation StudentDutySameYearMonth
@synthesize year,month,dutyList,monthDay;

-(id)init
{
    if(self=[super init])
    {
        dutyList=[[NSMutableArray alloc]init];
        monthDay=[[NSMutableArray alloc]init];
    }
    
    return self;
}


-(void)dealloc
{

    self.monthDay=nil;
    self.dutyList=nil;
    [super dealloc];
}
@end
