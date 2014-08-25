//
//  MyButton.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton
@synthesize path;
@synthesize animArrImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        
    }
    return self;
}
-(void)anSubView
{
    animArrImage=[[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 12, 12)];
    animArrImage.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"audio_002.png"],[UIImage imageNamed:@"audio_003.png"], nil];
    animArrImage.image=[UIImage imageNamed:@"audio_001.png"];
    animArrImage.animationRepeatCount=0;
    animArrImage.animationDuration=0.5;
    [self addSubview:animArrImage];
   // [self startAnimation];
}
-(void)startAnimation
{
    [animArrImage startAnimating];
}
-(void)stopAnimation
{
    [animArrImage stopAnimating];
}
-(void)dealloc
{
    self.path=nil;
    self.animArrImage=nil;
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
