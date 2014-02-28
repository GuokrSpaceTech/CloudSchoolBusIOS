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
@synthesize photoImageView;
@synthesize backgroundView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //147 × 78
        //73  39  129130
//        photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 39)];
//        photoImageView.backgroundColor=[UIColor redColor];
//        [self addSubview:photoImageView];
//        [self.imageView sendSubviewToBack:photoImageView];
        
        
        photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 1, 65, 38)];
        photoImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:photoImageView];
        
        backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 74, 40)];
        backgroundView.backgroundColor=[UIColor clearColor];
        backgroundView.image=[UIImage imageNamed:@"谁在照片里_05.png"];
        [self addSubview:backgroundView];
        
     
        
    
        

        
      
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)layoutSubviews
{
    
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
    self.photoImageView=nil;
    self.backgroundView=nil;
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
