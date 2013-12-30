//
//  GKButton.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-25.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKButton.h"

@implementation GKButton
@synthesize student;
@synthesize isSelect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
    }
    return self;
}
-(void)setIsSelect:(BOOL)_isSelect
{
    isSelect=_isSelect;
    
    if(isSelect==YES)
    {
        
        //duihao
        if (![self viewWithTag:1000]) {
            UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 22, 2, 20, 20)];
            iamgeView.image= IMAGENAME(IMAGEWITHPATH(@"duihao"));
            iamgeView.tag=1000;
            [self addSubview:iamgeView];
            [iamgeView release];
        }
        
        
    }
    else
    {
        
        UIImageView *iamge=(UIImageView *)[self viewWithTag:1000];
        if(iamge)
        {
            //            NSLog(@"%d",self.tag);
            [iamge removeFromSuperview];
            iamge=nil;
        }
      
    }
}
-(void)dealloc
{
    self.student=nil;
    [super dealloc];
}


//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(5,25, contentRect.size.width-10, 15);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
