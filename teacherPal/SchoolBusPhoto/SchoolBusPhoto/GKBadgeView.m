//
//  GKBadgeView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-15.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKBadgeView.h"

@implementation GKBadgeView
@synthesize bagde;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setBagde:(int)_bagde
{
    bagde=_bagde;
    
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if(bagde==0)
    {
        return;
    }
    //NSString *tishistr=[[NSBundle mainBundle] pathForResource:@"tishi" ofType:@"png"];
    UIImage *iamge=IMAGENAME(IMAGEWITHPATH(@"tishi"));
    [iamge drawInRect:rect];
    
    [[UIColor whiteColor] set];
    NSString *str=[NSString stringWithFormat:@"%d",self.bagde];
    
    [str drawInRect:rect withFont:[UIFont systemFontOfSize:9] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
}


@end
