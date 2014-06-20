//
//  GKDisapperView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-19.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKDisapperView.h"

@implementation GKDisapperView
@synthesize textLabel;
@synthesize activityView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor=[UIColor clearColor];
        [self addSubview:bgView];
        [bgView release];
        
        orgFrame=frame;
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-150 , frame.size.height/2-25, 300, 100)];
       // imageView.backgroundColor=[UIColor colorWithRed:147/255.0f green:222/255.0f blue:239/255.0f alpha:1.0f];
        imageView.backgroundColor=[UIColor blackColor];
        imageView.alpha=0.9;
        [self addSubview:imageView];
        [imageView release];
        
        activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center=CGPointMake(150, 20);
        [imageView addSubview:activityView];
        activityView.hidesWhenStopped=YES;

        
        textLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.numberOfLines=0;
    
        textLabel.font=[UIFont systemFontOfSize:15];
        textLabel.textColor=[UIColor whiteColor];
        if(IOSVERSION>=6.0)
            textLabel.textAlignment=NSTextAlignmentCenter;
        else
            textLabel.textAlignment=UITextAlignmentCenter;
        [imageView addSubview:textLabel];
    
    }
    return self;
}

-(void)setactiveStop:(BOOL)an
{
    if(an)
    {
        [activityView stopAnimating];

        textLabel.frame=CGRectMake(5, 5, 290, 90);
        
    }
    else
    {
        [activityView startAnimating];
        textLabel.frame=CGRectMake(5, 40, 290, 40);
    }
}
-(void)dealloc
{
    self.textLabel=nil;
    self.activityView=nil;
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
