//
//  Food.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 3/12/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "Food.h"

@implementation Food
//@property(nonatomic,retain)NSString *week;
//@property(nonatomic,retain)NSString *breakfastA;
//@property(nonatomic,retain)NSString *breakfastB;
//@property(nonatomic,retain)NSString *lunchA;
//@property(nonatomic,retain)NSString *lunchB;
//@property(nonatomic,retain)NSString *dinner;
@synthesize week,breakfastA,breakfastB,lunchA,lunchB,dinner;
-(void)dealloc
{
    self.week=nil;
    self.breakfastB=nil;
    self.breakfastA=nil;
    self.lunchB=nil;
    self.lunchA=nil;
    self.dinner=nil;
    [super dealloc];
}
@end
