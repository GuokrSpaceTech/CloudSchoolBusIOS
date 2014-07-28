//
//  GKButtonTag.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-24.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKButtonTag.h"

@implementation GKButtonTag
@synthesize phototag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc
{
    self.phototag=nil;
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
