//
//  GKReportContentViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportContentViewController.h"

@interface GKReportContentViewController ()

@end

@implementation GKReportContentViewController
@synthesize _tableView;
@synthesize report;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    titlelabel.text=NSLocalizedString(@"detailreport", @"");
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor=[UIColor clearColor];
    
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 40)];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    timeLabel.text=[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.report.reporttime intValue]]];;
    [headerView addSubview:timeLabel];
    [timeLabel release];
    
    
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 40)];
    name.text=self.report.title;
    name.userInteractionEnabled=YES;
    [headerView addSubview:name];
    [name release];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick:)];
    tap.numberOfTapsRequired=1;
    [name addGestureRecognizer:tap];
    [tap release];
    
    _tableView.tableHeaderView=[headerView autorelease];
    

    
   // list=[[NSMutableArray alloc]init];
}
-(void)TapClick:(UITapGestureRecognizer *)tap
{
    
    NSMutableString *str=[[NSMutableString alloc]initWithString:@""];
    
    
    for (int i=0; i<self.report.studentArr.count; i++) {
        NSString *str1=[self.report.studentArr objectAtIndex:i];
        [str appendString:[NSString stringWithFormat:@"%@ ",str1]];
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)leftClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.report.contentArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280,20)];
        label.backgroundColor=[UIColor clearColor];
        label.tag=100;
        [cell.contentView addSubview:label];
        [label release];
        
        UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 280,20)];
        contentlabel.backgroundColor=[UIColor clearColor];
        contentlabel.tag=101;
        contentlabel.numberOfLines=0;
        contentlabel.lineBreakMode=NSLineBreakByCharWrapping;
        contentlabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:contentlabel];
        [contentlabel release];
        
        
        UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
        lineImageView.backgroundColor=[UIColor clearColor];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        
    }
    
    NSDictionary *dic=[self.report.contentArr objectAtIndex:indexPath.row];
    UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentlabel=(UILabel *)[cell.contentView viewWithTag:101];
    ;
    titleLabel.text=[NSString stringWithFormat:@"%d、%@",(indexPath.row+1),[dic objectForKey:@"title"]];
    
    
    NSString *answer=[dic objectForKey:@"answer"];
    
    CGSize size=[answer sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    contentlabel.text=[dic objectForKey:@"answer"];
    
    contentlabel.frame=CGRectMake(20, 35, 280, size.height);
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    NSDictionary *dic=[self.report.contentArr objectAtIndex:indexPath.row];
    NSString *answer=[dic objectForKey:@"answer"];
    
    CGSize size=[answer sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.height + 40;
   //    contentlabel.frame=CGRectMake(20, 35, 280, size.height);

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)dealloc
{
    
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
