//
//  GKNoticeInfoViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-10.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeInfoViewController.h"
#import "GKNotice.h"
#import "KKNavigationController.h"
#import "NSDate+convenience.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
@interface GKNoticeInfoViewController ()

@end

@implementation GKNoticeInfoViewController
@synthesize notice;
@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titlelabel.text=NSLocalizedString(@"noticeDetail", @"");

    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height -navigationView.frame.size.height-navigationView.frame.origin.y ) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
   // _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
    int height=0;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headView.backgroundColor=[UIColor whiteColor];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.text=notice.noticetitle;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [headView addSubview:titleLabel];
    titleLabel.font=[UIFont systemFontOfSize:16];
    [titleLabel release];
    CGSize size=[notice.noticetitle sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    // 10  10
    
    titleLabel.frame=CGRectMake(10, 10+height, 300, size.height);
    height+=size.height+5;
    
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.text=notice.noticecontent;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.textColor=[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [headView addSubview:contentLabel];
    [contentLabel release];

    size=[notice.noticecontent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    contentLabel.frame=CGRectMake(20, 10+height, 280, size.height);
    height+=size.height+5;


    
    if([notice.plist count]==1)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(110,10+height,100,100)];
        imageView.backgroundColor=[UIColor redColor];
        [headView addSubview:imageView];
        [imageView release];
        NSString *urlStr=[[[notice.plist objectAtIndex:0] objectForKey:@"source"] stringByAppendingString:@".tiny.jpg"];
        
        [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
                
                NSLog(@"Error : load image fail.");
                imageView.image = [UIImage imageNamed:@"imageerror.png"];
                
            }
            else
            {
               
                
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
        for (int i=0; i<[notice.plist count]; i++) {
            
            int row =i/4;
            int col=i%4;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12+col*(65+12), (10+height)+row*(65+10) , 65, 65)];
            imageView.backgroundColor=[UIColor redColor];
            [headView addSubview:imageView];
            [imageView release];
            NSString *urlStr=[[[notice.plist objectAtIndex:i] objectForKey:@"source"] stringByAppendingString:@".tiny.jpg"];
            
            [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (error) {
                    
                    NSLog(@"Error : load image fail.");
                    imageView.image = [UIImage imageNamed:@"imageerror.png"];
                    
                }
                else
                {
                    
                    
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
        
        int row=(ceil([notice.plist count]/4.0));
        
        height+=(row*65) +(row-1)*10 +5;
        
    }
    
//    UILabel *timelagel=[[UILabel alloc]initWithFrame:CGRectMake(10, height+10, 100, 20)];
//    titlelabel.backgroundColor=[UIColor clearColor];
    
    
    
    UILabel *timelagelabel=[[UILabel alloc]initWithFrame:CGRectMake(200, height+10, 100, 20)];
    timelagelabel.backgroundColor=[UIColor clearColor];
    timelagelabel.font=[UIFont systemFontOfSize:10];
    timelagelabel.text=[self timeStr:notice.addtime];
    
    if(IOSVERSION>=6.0)
        timelagelabel.textAlignment=NSTextAlignmentRight;
    else
        timelagelabel.textAlignment=UITextAlignmentRight;
    timelagelabel.textColor=[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
    [headView addSubview:timelagelabel];
    [titlelabel release];
    height+=20+5;
    
    headView.frame=CGRectMake(0, 0, 320,10+height);
    _tableView.tableHeaderView=headView;
    [headView release];
    
    
    

}
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

-(void)leftClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notice.slistname count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(262, 7, 16, 16)];
        imageView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imageView];
        imageView.tag=1006;
        [imageView release];
        
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
  
    cell.textLabel.text=[notice.slistname objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    UIImageView *iamgeView=(UIImageView *)[cell.contentView viewWithTag:1006];
    
    
    if([notice.isconfirm integerValue]==1)
    {
        for (int i=0; i<[notice.sisconfirm count]; i++) {
            NSString *str=[notice.slistname objectAtIndex:indexPath.row];
            if([notice.sisconfirm containsObject:str])
            {
                iamgeView.image=[UIImage imageNamed:@"duihaohuizhi.png"];
            }
            else
            {
                iamgeView.image=nil;
            }
        }
    }
    else
    {
         iamgeView.image=nil;
    }

    
   // cell.textLabel.text=[notice.slistname objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:204/255.0 alpha:1];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 20)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    [label release];
    
    label.text=NSLocalizedString(@"sendWho",@"");
    

    
    if([notice.isconfirm integerValue]==1)
    {
        UILabel *huizlabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 20)];
        huizlabel.backgroundColor=[UIColor clearColor];
        huizlabel.font=[UIFont systemFontOfSize:14];
        [view addSubview:huizlabel];
        huizlabel.textColor=[UIColor whiteColor];
        if(IOSVERSION>=6.0)
        {
            huizlabel.textAlignment=NSTextAlignmentRight;
        }
        else
        {
             huizlabel.textAlignment=UITextAlignmentRight;
        }
        [huizlabel release];
        huizlabel.text=NSLocalizedString(@"huizhi",@"");
    }
    return [view autorelease];
}
-(void)dealloc
{
    self.notice=nil;
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
