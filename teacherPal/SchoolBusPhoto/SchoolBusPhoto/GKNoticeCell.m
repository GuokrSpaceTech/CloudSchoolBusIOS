//
//  GKNoticeCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeCell.h"
#import "NSDate+convenience.h"

#import "UIImageView+WebCache.h"
#define IMAGETAG 100
@implementation GKNoticeCell
@synthesize titleLable,timeLabel,contentlabel;
@synthesize notice;
@synthesize IconImageView;
@synthesize huizhiLabel;
@synthesize delegate;
@synthesize teachreLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        bottomView=[[UIView alloc]initWithFrame:CGRectZero];
        bottomView.backgroundColor=[UIColor whiteColor];
       
        [self.contentView addSubview:bottomView];
        //bottomView.layer.cornerRadius=5;
        [bottomView release];
        
        IconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
        IconImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:IconImageView];
        IconImageView.image=[UIImage imageNamed:@"noticeStar.png"];
        
        lineImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        lineImageView.backgroundColor=[UIColor clearColor];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [self.contentView addSubview:lineImageView];
        [lineImageView release];
        

        
        titleLable=[[UILabel alloc]initWithFrame:CGRectZero];
        titleLable.backgroundColor=[UIColor clearColor];
        titleLable.font=[UIFont systemFontOfSize:16];
        titleLable.lineBreakMode=NSLineBreakByWordWrapping;
        titleLable.numberOfLines=0;
        [self.contentView addSubview:titleLable];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:10];
        timeLabel.textColor=[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
        [self.contentView addSubview:timeLabel];
        
        teachreLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        teachreLabel.backgroundColor=[UIColor clearColor];
        teachreLabel.font=[UIFont systemFontOfSize:10];
        
        teachreLabel.textColor=[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
        [self.contentView addSubview:teachreLabel];


        
        huizhiLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        huizhiLabel.backgroundColor=[UIColor clearColor];
        huizhiLabel.font=[UIFont systemFontOfSize:10];;
        if(IOSVERSION>=6.0)
            huizhiLabel.textAlignment=NSTextAlignmentRight;
        else
            huizhiLabel.textAlignment=UITextAlignmentRight;
        [self.contentView addSubview:huizhiLabel];
        
        contentlabel=[[HTCopyableLabel alloc]initWithFrame:CGRectZero];
        contentlabel.backgroundColor=[UIColor clearColor];
        contentlabel.font=FONTSIZE;
        contentlabel.textColor=[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
        contentlabel.numberOfLines=0;
        contentlabel.lineBreakMode=NSLineBreakByTruncatingTail;
        
       
        [self.contentView addSubview:contentlabel];
        
    }
    return self;
}
-(void)setNotice:(GKNotice *)_notice
{
    [notice release];
    notice=[_notice retain];
    
    for (UIView *tempVew in [self.contentView subviews]) {
        if([tempVew isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView=(UIImageView *)tempVew;
            
            if(imageView.tag>=IMAGETAG)
            {
                [imageView removeFromSuperview];
            }
               
            
        }
    }
    

    int height=0;
    CGSize size=[_notice.noticetitle sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    titleLable.text=_notice.noticetitle;
    height+=size.height;
    titleLable.frame=CGRectMake(50, 5+5, 250, height);
   
    //titleLable.backgroundColor=[UIColor redColor];
   
    
    //height+=5;
   // topLineImageView.frame=CGRectMake(10, 10+height, 300, 1);
    height+=5;
    CGSize contentSize=[_notice.noticecontent sizeWithFont:FONTSIZE constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
    //height+=contentSize.height;
    
   // [[UIFont systemFontOfSize:15] lineHeight]
    contentlabel.text=_notice.noticecontent;
//    huizhiLabel.text=[_notice];
//    if(_notice.open==YES)
//    {
//        //如果是展开状态  显示全部内容
//        contentlabel.frame=CGRectMake(50, 10+height, 250, contentSize.height);
//        height+=contentSize.height;
//
//        NSLog(@"~~~~~~~~~~%@",_notice.noticecontent);
//        //height+=contentSize.height;
//
//    }
//    else
//    {
        //如果是闭合状态
        if(contentSize.height > [FONTSIZE lineHeight] *3)
        {
            //当内容大于3行时 显示三行
            contentlabel.frame=CGRectMake(50, 10+height, 250, [FONTSIZE lineHeight] *3);
            height+=[FONTSIZE lineHeight] *3;
        }
        else
        {
             //当内容小于3行时 显示全部
            contentlabel.frame=CGRectMake(50, 10+height, 250, contentSize.height);
            height+=contentSize.height;
        }
        
        
  //  }
    height+=5;
    //回执

    // 判断图片

    if([notice.plist count]==1)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(110,10+height,100,100)];
        imageView.backgroundColor=[UIColor clearColor];
        imageView.tag=IMAGETAG;
        [self.contentView addSubview:imageView];
        [imageView release];
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTapsRequired=1;
        [imageView addGestureRecognizer:tap];
        [tap release];
        NSString *urlStr=[[[notice.plist objectAtIndex:0] objectForKey:@"source"] stringByAppendingString:@".tiny.jpg"];
        [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                
                NSLog(@"Error : load image fail.");
                imageView.image = [UIImage imageNamed:@"imageerror.png"];
                imageView.userInteractionEnabled=NO;
                
            }
            else
            {
                
                 imageView.userInteractionEnabled=YES;
                if (cacheType == 0) { // request url
                    CATransition *transition = [CATransition animation];
                    transition.duration = 1.0f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [imageView.layer addAnimation:transition forKey:nil];
                }
            }
            
        }];

        
        height+=(100+5);
        
        
    }
    else if([notice.plist count]>1)
    {
        for (int i=0; i<MIN([notice.plist count],3); i++) {
            
            int row =i/3;
            int col=i%3;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50+col*(65+12), (10+height)+row*(65+10) , 65, 65)];
              imageView.tag=IMAGETAG+i;
            imageView.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:imageView];
            [imageView release];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            tap.numberOfTapsRequired=1;
            [imageView addGestureRecognizer:tap];
            [tap release];

             NSString *urlStr=[[[notice.plist objectAtIndex:i] objectForKey:@"source"] stringByAppendingString:@".tiny.jpg"];
            
            [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (error) {
                    imageView.userInteractionEnabled=NO;
                    NSLog(@"Error : load image fail.");
                    imageView.image = [UIImage imageNamed:@"imageerror.png"];
                    
                }
                else
                {
                    
                    imageView.userInteractionEnabled=YES;
                    if (cacheType == 0) { // request url
                        CATransition *transition = [CATransition animation];
                        transition.duration = 1.0f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        
                        [imageView.layer addAnimation:transition forKey:nil];
                    }
                }
                
            }];

        }
        
        int row=(ceil(3/3.0));
        
        height+=(row*65) +(row-1)*10 +5;
        
    }
    
    

   // NSLocalizedString(@"Confirmednotice",@"")

    
    lineImageView.frame=CGRectMake(10, 10+height+5, 300, 1);
    timeLabel.text=[self timeStr:notice.addtime];
    timeLabel.frame=CGRectMake(50, 10+height+10, 80, 15);
    teachreLabel.frame=CGRectMake(130, 10+height+10, 80, 15);
    teachreLabel.text=notice.teachername;
    
    if([notice.isconfirm integerValue]==1)
    {
        huizhiLabel.frame=CGRectMake(200, 10+height+10, 100, 15);
        huizhiLabel.textColor=[UIColor redColor];
        huizhiLabel.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"Confirmednotice",@""), [notice.sisconfirm count],NSLocalizedString(@"people",@"")];
        IconImageView.image=[UIImage imageNamed:@"noticeStar.png"];
      

    }
    else
    {
        huizhiLabel.frame=CGRectZero;
        IconImageView.image=[UIImage imageNamed:@"2.png"];
    }
    height+=20; // time 高度
    bottomView.frame=CGRectMake(10,5 , 300, 10+height+10);
 
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
   int a=  tap.view.tag-IMAGETAG;
    
    NSString *urlStr=[[notice.plist objectAtIndex:a] objectForKey:@"source"];
    
    
    
    [delegate clickImageViewLookImage:urlStr];
}

//计算时间
-(NSString *)timeStr:(NSString *)_time
{
    NSString *time = _time;
    
    int cDate = [[NSDate date] timeIntervalSince1970]; //current time
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue]; // _time 对应的data
    int sub = cDate - time.intValue; // 时间差

    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,NSLocalizedString(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60) //大于一小时 小于12小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),NSLocalizedString(@"hoursago", @"")];
    }
    else if (pDate.year == [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
        
    }
    else if (pDate.year < [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"error time"];
    }
    
    
    if (time !=nil) {
        return dateStr;
    }
    

    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.titleLable=nil;
    self.timeLabel=nil;
    self.contentlabel=nil;
    self.notice=nil;
    self.IconImageView=nil;
    self.huizhiLabel=nil;
    self.teachreLabel=nil;
    [super dealloc];
}
@end
