//
//  GKMarketCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKMarketCell.h"
#import "GKAppDelegate.h"
#import "GKMarketDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "GKAppDelegate.h"
#import "UIImageView+WebCache.h"
@implementation GKMarketCell
@synthesize market;
@synthesize buyButton;
@synthesize goodsDesc,goodsImageView,jifenLabel,goodsLabel;
@synthesize delegate;
//@synthesize girdOne,girdThree,girdTwo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         self.backgroundColor=[UIColor clearColor];

        
        goodsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 75, 76)];
        goodsImageView.backgroundColor=[UIColor clearColor];;
        [self.contentView addSubview:goodsImageView];

        
        
        goodsLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 210, 20)];
        goodsLabel.backgroundColor=[UIColor clearColor];
        goodsLabel.font=[UIFont systemFontOfSize:15];
        goodsLabel.text=@"fdfdfdsfdsfsdfdsfsdfdsf";
        goodsLabel.textColor=[UIColor colorWithRed:110/255.0 green:165/255.0 blue:174/255.0 alpha:1];
        [self.contentView addSubview:goodsLabel];
        
        jifenImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 35, 15, 10)];
        jifenImageView.image=IMAGENAME(IMAGEWITHPATH(@"jifen"));
        [self.contentView addSubview:jifenImageView];
        [jifenImageView release];
        
        jifenLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 28, 180, 20)];
        jifenLabel.backgroundColor=[UIColor clearColor];
        jifenLabel.font=[UIFont systemFontOfSize:15];
        jifenLabel.text=@"fdfdf";
        jifenLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:jifenLabel];
        
        goodsDesc=[[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 15)];
        goodsDesc.backgroundColor=[UIColor clearColor];
        goodsDesc.font=[UIFont systemFontOfSize:10];
        goodsDesc.textColor=[UIColor grayColor];
        goodsDesc.numberOfLines=0;
        goodsDesc.lineBreakMode=NSLineBreakByWordWrapping;
       
        [self.contentView addSubview:goodsDesc];
        
        UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0 , 90, 320, 2)];
        lineImageView.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [self.contentView addSubview:lineImageView];
        [lineImageView release];
        
        
        
        buyButton=[UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame=CGRectMake(240, 25, 60, 24);
        [buyButton setTitle:NSLocalizedString(@"order", @"") forState:UIControlStateNormal];

         buyButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [buyButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:buyButton];
        

    }
    return self;
}
-(void)buyClick:(UIButton *)btn
{
   
    
    
    NSLog(@"%@",[[[btn superview] superview] superview]);
    UITableView *tab=(UITableView *)[[[btn superview] superview] superview];
    for (UIView *view in tab.subviews) {
        if([view isKindOfClass:[GKMarketCell class]])
        {
            if(view.tag==self.tag)
                continue;
            GKMarketCell *cell=(GKMarketCell *)view;
            
            cell.buyButton.selected=NO;;
        }
    }
    
     buyButton.selected=!buyButton.selected;
    
    
    [delegate clickBuy:self isselected:buyButton.selected market:market];
    
}



-(void)setbuyButton:(BOOL)select
{
    buyButton.selected=select;
}
-(void)setMarket:(GKMarket *)_market
{
    [market release];
    market=[_market retain];
    
    if([_market.marketCredits integerValue] ==0)
    {
        
        buyButton.hidden=YES;
        jifenImageView.hidden=YES;
        jifenLabel.hidden=YES;
        
    }
    else
    {
        buyButton.hidden=NO;
        jifenLabel.hidden=NO;
        jifenImageView.hidden=NO;
    }
    
    GKUserLogin *user=[GKUserLogin currentLogin];
    goodsLabel.text=market.marketName;
    jifenLabel.text=market.marketCredits;
    goodsDesc.text=market.marketIntro;
    [goodsImageView setImageWithURL:[NSURL URLWithString:market.marketUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    CGSize size=[market.marketIntro sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font= [UIFont systemFontOfSize:10];
    
    if(size.height>font.lineHeight *3)
    {
      //  k(100, 50, 200, 30)];
        goodsDesc.frame=CGRectMake(100, 50, 200, font.lineHeight*3);
    }
    else
    {
        goodsDesc.frame=CGRectMake(100, 50, 200, size.height);
    }
    
    if([user.credit_last floatValue] < [market.marketCredits floatValue])
    {
        buyButton.enabled=NO;
         [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"buyButtonEnable"))  forState:UIControlStateNormal];
    }
    else
    {
        buyButton.enabled=YES;
        [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"buyButtonN")) forState:UIControlStateNormal];
        [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"buyButtonS")) forState:UIControlStateSelected];
    }
    
}
-(void)dealloc
{
//    self.girdTwo=nil;
//    self.girdThree=nil;
//    self.girdOne=nil;
    self.market=nil;
    self.goodsLabel=nil;
    self.goodsImageView=nil;
    self.goodsDesc=nil;
   // self.buyButton=nil;
    self.jifenLabel=nil;
    [super dealloc];
}


//-(void)tapGirdView:(GKMarketGird *)girdView marker:(GKMarket *)mark
//{
//    
//    GKAppDelegate *delegate=APPDELEGATE;
//    CGRect rect=[self.contentView convertRect:girdView.frame fromView:delegate.window];
//
//    
//    NSLog(@"%f-----%f-----%f -------%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
//    
//    
//    GKMarketDetailView *markView=[[GKMarketDetailView alloc]initWithFrame:delegate.window.bounds];
//    markView.market=mark;
//    [delegate.window addSubview:markView];
//    [markView release];
//    
//
//    
//
//    
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
