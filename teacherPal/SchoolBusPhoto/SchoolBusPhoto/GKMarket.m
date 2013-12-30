//
//  GKMarket.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKMarket.h"

@implementation GKMarket
@synthesize marketCredits,marketName,marketUrl;
@synthesize marketId,marketIntro,marketfext;
@synthesize status,addtime;
@synthesize num;
-(id)init
{
    if(self=[super init])
    {
        [self setMarketCredits:@""];
        [self setMarketName:@""];
        [self setMarketUrl:@""];
        [self setMarketIntro:@""];
    }
    
    return self;
}

-(void)dealloc
{
    self.marketUrl=nil;
    self.addtime=nil;
    self.status=nil;
    self.num=nil;
    self.marketName=nil;
    self.marketCredits=nil;
    self.marketId=nil;
    self.marketIntro=nil;
    self.marketfext=nil;
    [super dealloc];
}
@end
