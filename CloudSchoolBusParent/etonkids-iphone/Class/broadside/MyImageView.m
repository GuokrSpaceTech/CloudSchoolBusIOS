//
//  MyImageView.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-12.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView
@synthesize path;
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
    self.path=nil;
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
