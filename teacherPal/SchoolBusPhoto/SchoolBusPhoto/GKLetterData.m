//
//  GKLetterData.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKLetterData.h"

@implementation GKLetterData
@synthesize dateKey,letterArr;


-(id)init
{
    if(self=[super init])
    {
        letterArr=[[NSMutableArray alloc]init];
    }
    return self;
}


-(void)dealloc
{
    self.letterArr=nil;
    self.dateKey=nil;
    [super dealloc];
}
@end
