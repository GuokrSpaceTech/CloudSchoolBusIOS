//
//  GKBuyCountView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKBuyCountView.h"

@implementation GKBuyCountView
@synthesize buyCount;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor colorWithPatternImage:IMAGENAME(IMAGEWITHPATH(@"buyBG"))];
        
        UIButton *minusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"minus")) forState:UIControlStateNormal];
        minusBtn.frame=CGRectMake(45, 15, 25, 25);
        [minusBtn addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:minusBtn];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(80, 15, 85, 30)];
        imageView.image=IMAGENAME(IMAGEWITHPATH(@"countInput"));

        [self addSubview:imageView];
        [imageView release];
     
        
        countLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 85, 30)];
        countLabel.text=@"1";
        countLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:countLabel];
        if(IOSVERSION>=6.0)
            countLabel.textAlignment=NSTextAlignmentCenter;
        else
            countLabel.textAlignment=UITextAlignmentCenter;
        [countLabel release];
        
        count=1;
        
        UIButton *plusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"plus")) forState:UIControlStateNormal];
        plusBtn.frame=CGRectMake(175, 15, 25, 25);
         [plusBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        
        
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"OK")) forState:UIControlStateNormal];
        [okBtn setTitle:NSLocalizedString(@"ok", @"") forState:UIControlStateNormal];
        okBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        okBtn.frame=CGRectMake(250, 15, 60, 24);
        [okBtn addTarget:self action:@selector(OKClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:okBtn];
        //UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)];
        
    }
    return self;
}
-(void)OKClick:(UIButton *)btn
{
    buyCount(count);
}
-(void)minus:(UIButton *)btn
{
    if(count>=2)
    {
        count--;
    }
    countLabel.text=[NSString stringWithFormat:@"%d",count];
}

-(void)add:(UIButton *)btn
{
    count++;
    countLabel.text=[NSString stringWithFormat:@"%d",count];
}

-(void)dealloc
{
    self.buyCount=nil;
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
