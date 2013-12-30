//
//  GKNODataView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-19.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKNODataView.h"

@implementation GKNODataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-303/4, frame.size.height/2-229/4-40, 303/2, 229/2)];
        imageView.image=IMAGENAME(IMAGEWITHPATH(@"NOData"));
        [self addSubview:imageView];
        [imageView release];
        
    }
    return self;
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
