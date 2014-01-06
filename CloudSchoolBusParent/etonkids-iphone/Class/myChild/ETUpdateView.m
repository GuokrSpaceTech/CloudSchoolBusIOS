//
//  ETUpdateView.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETUpdateView.h"

@implementation ETUpdateView
@synthesize titleLabel;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       
       // self.frame=CGRectMake(0, 0, 320, 50);
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newInfo.png"]];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
       
        titleLabel.font=[UIFont boldSystemFontOfSize:17];
        titleLabel.text=@"测试新信息";
        [self addSubview:titleLabel];
        
        
        
        self.userInteractionEnabled=YES;
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        [tap release];
        
    }
    return self;
}
-(void)click:(UITapGestureRecognizer *)tap
{
    NSLog(@"ddd");
    
    if(delegate&&[delegate respondsToSelector:@selector(clickView:)])
    {
        [delegate clickView:self];
    }
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
