//
//  CYDetailCell.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "CYDetailCell.h"
#import "UIImageView+WebCache.h"
#import "ProblemContent.h"
#import "ETKids.h"
#import "NSDate+convenience.h"

#define BGTAG 100
#define PICTAG 1000
@implementation CYDetailCell
@synthesize detail;
@synthesize labelcontent;
@synthesize timelabel;
@synthesize namelabel,levelLabel;
@synthesize photoImageView;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *BGImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        BGImageView.backgroundColor=[UIColor clearColor];
        BGImageView.tag=BGTAG;
        [self.contentView addSubview:BGImageView];
        [BGImageView release];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDoctorClick:)];
        tap.numberOfTapsRequired=1;
        
        photoImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        photoImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:photoImageView];
        [photoImageView addGestureRecognizer:tap];
        [tap release];

        namelabel=[[UILabel alloc]initWithFrame:CGRectZero];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.font=[UIFont systemFontOfSize:12];
        namelabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:namelabel];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
            namelabel.textAlignment=NSTextAlignmentCenter;
        else
            namelabel.textAlignment=UITextAlignmentCenter;
        
        levelLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        levelLabel.backgroundColor=[UIColor clearColor];
        levelLabel.font=[UIFont systemFontOfSize:12];
        levelLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:levelLabel];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
            levelLabel.textAlignment=NSTextAlignmentCenter;
        else
            levelLabel.textAlignment=UITextAlignmentCenter;
        
        
        timelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 20)];
        timelabel.backgroundColor=[UIColor clearColor];
        timelabel.font=[UIFont systemFontOfSize:12];
        timelabel.textColor=[UIColor blackColor];

        if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
            timelabel.textAlignment=NSTextAlignmentCenter;
        else
            timelabel.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:timelabel];
        
        labelcontent=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        labelcontent.backgroundColor=[UIColor clearColor];
        labelcontent.font=[UIFont systemFontOfSize:14];
        labelcontent.textColor=[UIColor blackColor];
        labelcontent.userInteractionEnabled=YES;
        
        
        labelcontent.numberOfLines=0;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
            labelcontent.lineBreakMode=NSLineBreakByWordWrapping;
        else
            labelcontent.lineBreakMode=UILineBreakModeWordWrap;
        [self.contentView addSubview:labelcontent];
    }
    return self;
}
-(void)setDetail:(ProblemDetail *)_detail
{
    [detail release];
    detail=[_detail retain];
    
    labelcontent.frame=CGRectZero;
    for (UIView *view in [self.contentView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView=(UIImageView *)view;
            if(imageView.tag>=PICTAG)
            {
                [imageView removeFromSuperview];
            }
        }
    }


    NSString *time = [_detail.created_time_ms substringToIndex:10];
    //
    NSLog(@"%@",time);
    int cDate = [[NSDate date] timeIntervalSince1970];
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    int sub = cDate - time.intValue;
    
    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,LOCAL(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60)
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),LOCAL(@"hoursago", @"")];
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
    
  //  cell.timeLatel.text=dateStr;

    photoImageView.frame=CGRectZero;
    namelabel.frame=CGRectZero;
    levelLabel.frame=CGRectZero;
    timelabel.text=dateStr;

    if([_detail.type isEqualToString:@"p"])
    {
        // 左气泡
        for (int i=0; i<[_detail.contentArr count]; i++) {
            ProblemContent *pro=[_detail.contentArr objectAtIndex:i];
            float cellheight=20;
            if([pro.type isEqualToString:@"text"])
            {
                CGSize size=[pro.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                labelcontent.text=pro.text;
                labelcontent.backgroundColor=[UIColor clearColor];
                labelcontent.frame=CGRectMake(22, cellheight+20 , size.width, size.height);
                cellheight+=(size.height+20+10);
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(10, 10+20, size.width+20, labelcontent.frame.origin.y + labelcontent.frame.size.height-20);
                //(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
                bgView.backgroundColor=[UIColor colorWithRed:250/255.0 green:249/255.0 blue:243/255.0 alpha:1];

            }
            else if([pro.type isEqualToString:@"image"])
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(22 , cellheight + 15 , 60, 90)];
                imageView.backgroundColor=[UIColor clearColor];
                
                NSString *imagestr=[NSString stringWithFormat:@"%@",pro.text];
                
                [imageView setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    imageView.userInteractionEnabled=YES;

                }];
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(12, cellheight+10 + 20, 60+20, 90+20);
                bgView.backgroundColor=[UIColor colorWithRed:250/255.0 green:249/255.0 blue:243/255.0 alpha:1];
                cellheight+=(90+20);
                imageView.tag=PICTAG;
                [self.contentView addSubview:imageView];
                [imageView release];
                

            }
            
        }
 
    }
    else if ([_detail.type isEqualToString:@"d"])
    {
        
        photoImageView.frame=CGRectMake(320-10-30, 30, 30, 30);
        namelabel.frame=CGRectMake(320-10-30-5, 60, 40, 15);
        levelLabel.frame=CGRectMake(320-10-30-5, 75, 40, 15);
        
        namelabel.text=@"洪金宝";
        levelLabel.text=@"意思";
        for (int i=0; i<[_detail.contentArr count]; i++)
        {
            ProblemContent *pro=[_detail.contentArr objectAtIndex:i];
            float cellheight=20;
            if([pro.type isEqualToString:@"text"])
            {
                CGSize size=[pro.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                labelcontent.text=pro.text;
                
                labelcontent.frame=CGRectMake(320-20-size.width-2 -40, cellheight+20  , size.width, size.height);
                
                // 5 8 12  10
                //cellheight+=(size.height );
                cellheight+=(size.height + 20 + 10);
                
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(320-size.width-30 -40 , 10 + 20, size.width +20, labelcontent.frame.origin.y + labelcontent.frame.size.height-20);
                
                bgView.backgroundColor=[UIColor colorWithRed:173/255.0 green:219/255.0 blue:68/255.0 alpha:1];

            }
            else if([pro.type isEqualToString:@"image"])
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(320-20-60 -40 , cellheight +15 , 60, 90)];
                imageView.backgroundColor=[UIColor clearColor];
                imageView.tag=PICTAG;
                NSString *imagestr=[NSString stringWithFormat:@"%@",pro.text];
                
                [imageView setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

                    imageView.userInteractionEnabled=YES;

                }];
                
                [self.contentView addSubview:imageView];
                [imageView release];
              
                UIImageView *bgView=(UIImageView *)[self.contentView viewWithTag:BGTAG];
                bgView.frame=CGRectMake(320-60-30 -40, 10 + 20, 60 +20, 90+10);
                cellheight+=(90+20);
                bgView.backgroundColor=[UIColor colorWithRed:173/255.0 green:219/255.0 blue:68/255.0 alpha:1];

            }

          
        }

        

    }
    
}
-(void)tapDoctorClick:(UIGestureRecognizer *)tap
{
    if(delegate && [delegate respondsToSelector:@selector(clickToDoctorDetailController)])
    {
        [delegate clickToDoctorDetailController];
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.detail=nil;
    self.labelcontent=nil;
    self.timelabel=nil;
    self.photoImageView=nil;
    self.levelLabel=nil;
    self.namelabel=nil;
    [super dealloc];
}
@end
