//
//  ETPhoto.m
//  SchoolBusParents
//
//  Created by wen peifang on 13-8-26.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "ETPhoto.h"

@implementation ETPhoto
@synthesize isSelected,asset;
@synthesize nameId;
@synthesize date;


-(void)dealloc
{
    self.date=nil;
    self.asset=nil;
    self.nameId=nil;
    [super dealloc];
}
@end
