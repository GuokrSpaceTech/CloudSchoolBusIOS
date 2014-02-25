//
//  myProgressView.m
//  ListenBooks
//
//  Created by wpf on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "myProgressView.h"

@implementation myProgressView
@synthesize processLabel;
@synthesize progress=progress_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    
        

        
        
        
        processView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:processView];
        processView.progress=0;
        processView.backgroundColor=[UIColor clearColor];
    
        [processView release];
        
        processLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 40, 20)];
        processLabel.backgroundColor=[UIColor clearColor];
        processLabel.font=[UIFont systemFontOfSize:10];
        processLabel.textColor=[UIColor colorWithRed:74/255.0 green:154/255.0 blue:177/255.0 alpha:1];
        processLabel.textAlignment=UITextAlignmentCenter;
        processLabel.text=@"0%";
        [self addSubview:processLabel];
        [self setProgress:0];
        
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
-(void)setProgress:(CGFloat)progress
{
    progress_=progress;
    
  
    if( progress_==0 )
    {
        
        processLabel.text=[NSString stringWithFormat:@"%.0f%%",progress_*100];
    }
    else if( progress_==1 )
    {
        
        processLabel.text=[NSString stringWithFormat:@"%.0f%%",100.0];
        
    }    
    else if( progress_>0&&progress_<1 )
    {
     
       
        processLabel.text=[NSString stringWithFormat:@"%.0f%%",progress_*100];
    }
    processView.progress=progress;
}

-(void)dealloc
{
    [processLabel release];
       [super dealloc];
}
@end
