//
//  GKMarketButton.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-1.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKMarketButton.h"

@implementation GKMarketButton
@synthesize textLabel,countLabel;
@synthesize selectedIamge,noneSelectedImage;
@synthesize isSelected;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      //  self.selectedIamge=selectIamge;
       // self.noneSelectedImage=noSelctimage;
       // [self setNoneSelectedImage:noneSelectedImage];
        
        iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(1, 50-5, frame.size.width, 5)];
        iamgeView.backgroundColor=[UIColor clearColor];
        //iamgeView.image=noSelctimage;
        [self addSubview:iamgeView];
        [iamgeView release];
        
        
        
        
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
        
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.textColor=[UIColor colorWithRed:97/255.0 green:161/255.0 blue:189/255.0 alpha:1];
        textLabel.font=[UIFont systemFontOfSize:12];
        if(IOSVERSION>= 6.0)
            textLabel.textAlignment=NSTextAlignmentCenter;
        else
            textLabel.textAlignment=NSTextAlignmentCenter;

        [self addSubview:textLabel];
        
        countLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, frame.size.width, 20)];
        //countLabel.font=[UIFont systemFontOfSize:12];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.font=[UIFont systemFontOfSize:12];
        if(IOSVERSION>= 6.0)
            countLabel.textAlignment=NSTextAlignmentCenter;
        else
            countLabel.textAlignment=NSTextAlignmentCenter;
        countLabel.textColor=[UIColor colorWithRed:97/255.0 green:161/255.0 blue:189/255.0 alpha:1];
        [self addSubview:countLabel];
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        [tap release];
        

    }
    return self;
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
//    if(self.tag==224)
//    {
//        [delegate isSelectedTheButton:self isSelected:isSelected];
//        return;
//    }
    self.isSelected=YES;
    
    if([delegate respondsToSelector:@selector(isSelectedTheButton:isSelected:)])
    {
        [delegate isSelectedTheButton:self isSelected:isSelected];
    }
    
}
-(void)setIsSelected:(BOOL)_isSelected
{
    isSelected=_isSelected;

    if(isSelected)
    {
        iamgeView.image=IMAGENAME(IMAGEWITHPATH(@"select"));
        
        textLabel.textColor=[UIColor colorWithRed:255/255.0 green:156/255.0 blue:0/255.0 alpha:1];
        countLabel.textColor=[UIColor colorWithRed:255/255.0 green:156/255.0 blue:0/255.0 alpha:1];
        
    }
    else
    {
        iamgeView.image=nil;
        textLabel.textColor=[UIColor colorWithRed:87/255.0 green:172/255.0 blue:197/255.0 alpha:1];
        countLabel.textColor=[UIColor colorWithRed:87/255.0 green:172/255.0 blue:197/255.0 alpha:1];
    }
    

    
    
}
-(void)dealloc
{
    self.textLabel=nil;
    self.noneSelectedImage=nil;
    self.selectedIamge=nil;
    self.countLabel=nil;
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
