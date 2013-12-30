//
//  GKMarketGird.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKMarketGird.h"
#import "UIImageView+WebCache.h"
#import "GKUserLogin.h"
@implementation GKMarketGird
@synthesize market;
@synthesize titleLabel,creditLabel;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        

//        [self addGestureRecognizer:tap];
//        [tap release];
        
        
        imageViewBG=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 198/2, 198/2)];
        imageViewBG.backgroundColor=[UIColor clearColor];
        imageViewBG.image=IMAGENAME(IMAGEWITHPATH(@"back-1"));
        [self addSubview:imageViewBG];
        [imageViewBG release];
        
        
        
        markerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 198/2-14, 198/2-14)];
        markerImageView.backgroundColor=[UIColor clearColor];

        [self addSubview:markerImageView];
        [markerImageView release];

        

       
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 198/2+5, 80, 20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:10];
     //   titleLabel.text=@"名称:洗衣服大袋";
        [self addSubview:titleLabel];
        
        
        creditLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 198/2+5+15, 80, 20)];
        creditLabel.backgroundColor=[UIColor clearColor];
        creditLabel.textColor=[UIColor redColor];
        creditLabel.font=[UIFont boldSystemFontOfSize:10];
       // creditLabel.text=@"名称:3200";
        [self addSubview:creditLabel];
        
        
        
        buyButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame=CGRectMake(82, 110, 22, 22);
        [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"box-1")) forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buyButton];
        
    }
    return self;
}
-(void)girdClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"taptaptap");
    //GKAppDelegate *appdelegate=APPDELEGATE;
  //  [self convertRect:<#(CGRect)#> fromView:<#(UIView *)#>]; tap.view
    
   // UIWindow *win=[APPDELEGATE];
    
   
    if([delegate respondsToSelector:@selector(tapGirdView:marker:)])
    {
        [delegate tapGirdView:self marker:self.market];
    }
}
-(void)buyClick:(UIButton *)btn
{
      NSLog(@"click click");
    
   // GKUserLogin *user=[GKUserLogin currentLogin];
    
   // user.credit_last=@"11";
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buyConfirm", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
    [alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(buttonIndex==0)
    {
        NSLog(@"fdfd");
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:market.marketId,@"goodsid", nil];
        [[EKRequest Instance]EKHTTPRequest:Creditshop parameters:dic requestMethod:POST forDelegate:self];
        
        
        
    }
    if(buttonIndex==1)
    {
        NSLog(@"111");
    }
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(method==Creditshop && code==1)
    {
      //  NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
       // NSLog(@"%@",str);
        GKUserLogin *user=[GKUserLogin currentLogin];
        
        // user.credit_last=@"11";
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        user.credit=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit"]];
        
        user.credit_orders=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_orders"]];
        user.credit_last=[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_last"]];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buysucess", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if(method==Creditshop)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"buyfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    
//    "network"="网络故障，请稍后重试";
//    "buysucess"="购买成功";
//    "buyfailed"="购买失败";
    
}
-(void)setMarket:(GKMarket *)_market
{
    [market release];
    market=[_market retain];
    GKUserLogin *user=[GKUserLogin currentLogin];
    if([user.credit_last floatValue] < [market.marketCredits floatValue])
    {
        [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"box-2")) forState:UIControlStateNormal];
        buyButton.enabled=NO;
    }
    else
    {
        
        [buyButton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"box-1")) forState:UIControlStateNormal];
        buyButton.enabled=YES;
    }
    if(_market)
    {
        tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(girdClick:)];
        tap.numberOfTapsRequired=1;
        [self addGestureRecognizer:tap];
        [tap release];
        titleLabel.frame= CGRectMake(5, 198/2+5, 80, 20);
        creditLabel.frame=CGRectMake(5, 198/2+5+15, 80, 20);
        buyButton.frame=CGRectMake(82, 110, 22, 22);
        imageViewBG.frame=CGRectMake(5, 5, 198/2, 198/2);
        markerImageView.frame=CGRectMake(15, 15, 198/2-23, 198/2-20);
        [markerImageView setImageWithURL:[NSURL URLWithString:market.marketUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        titleLabel.text=[NSString stringWithFormat:@"名称：%@",market.marketName];
        creditLabel.text=[NSString stringWithFormat:@"积分：%@",market.marketCredits];
    }
    else
    {
        
        if (tap) {
            [self   removeGestureRecognizer:tap];
            tap = nil;
        }
        
         imageViewBG.frame=CGRectZero;
        titleLabel.frame=CGRectZero;
        creditLabel.frame=CGRectZero;
        buyButton.frame=CGRectZero;
        markerImageView.frame=CGRectZero;
        
        
        [self removeGestureRecognizer:tap];
    }
    

    
    
    
}
-(void)dealloc
{
    self.market=nil;
    self.titleLabel=nil;
    self.creditLabel=nil;
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
