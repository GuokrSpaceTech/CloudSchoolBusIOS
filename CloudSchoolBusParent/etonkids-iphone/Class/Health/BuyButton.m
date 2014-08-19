//
//  BuyButton.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-19.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "BuyButton.h"

@implementation BuyButton

- (id)initWithFrame:(CGRect)frame title1:(NSString *)_title title2:(NSString *)title2 image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor=[UIColor clearColor];
        [self addSubview:view];
        [view release];
        
        
        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        iamgeView.userInteractionEnabled=YES;
        iamgeView.image=[UIImage imageNamed:@"health_buy_btn_BG.png"];
        [view addSubview:iamgeView];
        [iamgeView release];
        
        UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
        iconImage.image=image;
        [self addSubview:iconImage];
        [iconImage release];
    
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(45, 2, self.frame.size.width-50, 20)];
        label.text=_title;
        label.font=[UIFont systemFontOfSize:14];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
        [label release];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(45, 23, self.frame.size.width-50, 20)];
        label2.text=title2;
        label2.font=[UIFont systemFontOfSize:12];
        label2.textColor=[UIColor grayColor];
        label2.backgroundColor=[UIColor clearColor];
        label2.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label2];
        [label2 release];
        
    }
    return self;
}
-(void)dealloc
{

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
