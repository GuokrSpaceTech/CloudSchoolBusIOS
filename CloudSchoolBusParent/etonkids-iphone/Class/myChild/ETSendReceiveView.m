//
//  ETSendReceiveView.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETSendReceiveView.h"
#import "ETKids.h"
@implementation ETSendReceiveView
@synthesize photoImageView,namelabel;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setType:1];
        photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10-25)];
        photoImageView.backgroundColor=[UIColor redColor];
    
        [self addSubview:photoImageView];
        
        namelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-25, self.frame.size.width, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        if(IOSVERSION>=6.0)
            namelabel.textAlignment=NSTextAlignmentCenter;
        else
            namelabel.textAlignment=UITextAlignmentCenter;
   
        
        [self addSubview:namelabel];
        
        self.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        [tap release];
        
        
        UILongPressGestureRecognizer *longtap=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
        [self addGestureRecognizer:longtap];
        [longtap release];
        
      //  [tap requireGestureRecognizerToFail：longtap]
        [tap requireGestureRecognizerToFail:longtap];
    }
    return self;
}
-(void)tapClick:(UIGestureRecognizer *)tapGest
{
    if(tapGest.state==UIGestureRecognizerStateEnded)
    {
        if(self.type==1)
        {
            return;
        }
        else
        {
            // 增加
            
            NSLog(@"add");
            if(delegate&&[delegate respondsToSelector:@selector(tapPressViewAddNewSendReceivePeople)])
            [delegate tapPressViewAddNewSendReceivePeople];
        }
    }

}
-(void)longClick:(UIGestureRecognizer *)tap
{
     if(tap.state==UIGestureRecognizerStateEnded)
     {
         if(self.type==1)
         {
             //长按
             NSLog(@"edit");
         }
         else
         {
             return;
         }

     }
}
-(void)dealloc
{
    self.photoImageView=nil;
    self.namelabel=nil;
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
