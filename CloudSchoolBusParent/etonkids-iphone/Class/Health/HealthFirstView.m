//
//  HealthFirstView.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-8.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "HealthFirstView.h"
#import "ETKids.h"
#import <QuartzCore/QuartzCore.h>
@implementation HealthFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView  *ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1136/2.0)];
        ImageView.backgroundColor=[UIColor clearColor];
        ImageView.image=[UIImage imageNamed:@"health_bg_clear.png"];
        [self addSubview:ImageView];
        [ImageView release];
        
        
        UIImageView  *arrowIamge=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-60, (ios7?20:0)+NAVIHEIGHT,58/2.0, 40)];
        arrowIamge.backgroundColor=[UIColor clearColor];
        arrowIamge.image=[UIImage imageNamed:@"health_bg_arrop.png"];
        [self addSubview:arrowIamge];
        [arrowIamge release];
        
        
        UIView *ContentView=[[UIView alloc]initWithFrame:CGRectMake(20, arrowIamge.frame.size.height +arrowIamge.frame.origin.y+10, 280, 350)];
        ContentView.layer.cornerRadius=10;
        ContentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:ContentView];
        
//        "Click on it to consult doctor online
//        Public hospital doctors 100% solution"
        UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, ContentView.frame.size.width, 18)];
        topLabel.backgroundColor=[UIColor clearColor];
        topLabel.text=NSLocalizedString(@"health_bg_top", @"");
        topLabel.font=[UIFont systemFontOfSize:14];
        [ContentView addSubview:topLabel];
        [topLabel release];
        
        UILabel *topLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 26, ContentView.frame.size.width, 20)];
        topLabel1.backgroundColor=[UIColor clearColor];
        topLabel1.text=NSLocalizedString(@"health_bg_top1", @"");
        topLabel1.font=[UIFont systemFontOfSize:14];
        [ContentView addSubview:topLabel1];
        [topLabel1 release];
        if(IOSVERSION>=6.0)
        {
            topLabel.textAlignment=NSTextAlignmentCenter;
            topLabel1.textAlignment=NSTextAlignmentCenter;
        }
        else
        {
            topLabel.textAlignment=UITextAlignmentCenter;
              topLabel1.textAlignment=UITextAlignmentCenter;
        }
     //   health_bg_pic
        
        
//        "health_bg_top"="点击进行在线咨询";
//        "health_bg_top1"="P公立医院主治医生100%解答";
//        "health_bg_content"="医生咨询服务是云中校车联手国内知名线上医疗团队春雨医生而定制化的服务。这里拥有15000名公立医院专家，为您提供贴心的健康服务，为孩子成长提供专业的医疗咨询。";
        
        UIImageView *picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 50, 536/2.0, 235/2.0)];
        picImageView.image=[UIImage imageNamed:@"health_bg_pic.png"];
        [ContentView addSubview:picImageView];
        [picImageView release];
        
        
        NSString *str=NSLocalizedString(@"health_bg_content", @"");
        
        CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ContentView.frame.size.width-15, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 50+235/2.0+5, ContentView.frame.size.width-15, size.height)];
        contentlabel.numberOfLines=0;;
        contentlabel.backgroundColor=[UIColor clearColor];
        contentlabel.text=str;
        contentlabel.font=[UIFont systemFontOfSize:13];
        [ContentView addSubview:contentlabel];
        [contentlabel release];
        
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(ContentView.frame.size.width/2.0 - 134/2.0, ContentView.frame.size.height-50, 134, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"health_bg_btnnomal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"health_bg_btnnoshight.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"OK" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ContentView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        

        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:@"health" forKey:@"Health"];

    [self removeFromSuperview];
    //self=nil;
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
