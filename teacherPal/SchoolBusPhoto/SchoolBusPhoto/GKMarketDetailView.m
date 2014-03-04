//
//  GKMarketDetailView.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKMarketDetailView.h"
#import "UIImageView+WebCache.h"
@implementation GKMarketDetailView
@synthesize market;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
 
        UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-588/2.0)/2.0, (frame.size.height-588/2)/2.0 + 50, 588/2.0, 588/2.0)];
        bgImageView.userInteractionEnabled=YES;
        bgImageView.backgroundColor=[UIColor clearColor];
        bgImageView.image=IMAGENAME(IMAGEWITHPATH(@"back-2")) ;
        [self addSubview:bgImageView];

        [bgImageView release];
        
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"box-3"))forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(bgImageView.frame.size.width+bgImageView.frame.origin.x - 22 -5 , bgImageView.frame.origin.y +5 , 22, 22);
        [self addSubview:button];
        
       // NSOutputStream
        nameLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 20)];
        
        nameLable.backgroundColor=[UIColor clearColor];
      
        nameLable.font=[UIFont boldSystemFontOfSize:15];
        [bgImageView addSubview:nameLable];
        
        CreditLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 280, 20)];
        CreditLable.backgroundColor=[UIColor clearColor];
        
        CreditLable.font=[UIFont boldSystemFontOfSize:15];
        CreditLable.textColor=[UIColor redColor];
        [bgImageView addSubview:CreditLable];
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 280, 140)];
        [bgImageView addSubview:imageView];
        [imageView release];
        
        textView=[[UITextView alloc]initWithFrame:CGRectMake(10, bgImageView.frame.size.height-110, 280, 100)];
        textView.editable=NO;
        textView.scrollEnabled=YES;
        [bgImageView addSubview:textView];
        
        
    }
    return self;
}

-(void)setMarket:(GKMarket *)_market
{
    [market release];
    market=[_market retain];
    nameLable.text=[NSString stringWithFormat:@"名称:%@",market.marketName];
    CreditLable.text=[NSString stringWithFormat:@"积分:%@",market.marketCredits];
    textView.text=[NSString stringWithFormat:@"积分:\n%@",market.marketIntro];
    
//    [imageView setImageWithURL:[NSURL URLWithString:market.marketUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        
//    }];
    
    [imageView setImageWithURL:[NSURL URLWithString:market.marketUrl] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
}
-(void)closeClick:(UIButton *)btn
{
    [self removeFromSuperview];
}
-(void)dealloc
{
    self.market=nil;
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
