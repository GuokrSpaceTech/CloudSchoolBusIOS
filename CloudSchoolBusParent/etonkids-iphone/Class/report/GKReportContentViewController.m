//
//  GKReportContentViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportContentViewController.h"
#import "ETKids.h"
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =NSLocalizedString(@"detailreport", @"");//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor=[UIColor clearColor];
    
    
    UIImageView *iamgeviewtop=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , 1)];
    iamgeviewtop.image= [UIImage imageNamed:@"cellline.png"];
    [headerView addSubview:iamgeviewtop];
    [iamgeviewtop release];
    
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 40)];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.text=[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.report.reporttime intValue]]];;
    [headerView addSubview:timeLabel];
    [timeLabel release];
    
    
    UIImageView *iamgeviewmiddle=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-1, 0, 1, headerView.frame.size.height)];
    iamgeviewmiddle.backgroundColor=[UIColor colorWithRed:217/255.0 green:189/255.0 blue:148/255.0 alpha:1];
    [headerView addSubview:iamgeviewmiddle];
    [iamgeviewmiddle release];
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 40)];
    name.textAlignment=NSTextAlignmentCenter;
    name.text=self.report.studentname;
    name.backgroundColor=[UIColor clearColor];
    //name.userInteractionEnabled=YES;
    [headerView addSubview:name];
    [name release];
    

    
    UIImageView *iamgeview=[[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-1, self.view.frame.size.width  , 1)];
    iamgeview.image= [UIImage imageNamed:@"cellline.png"];
    [headerView addSubview:iamgeview];
    [iamgeview release];
    
    _tableView.tableHeaderView=[headerView autorelease];
    

    
   // list=[[NSMutableArray alloc]init];
}

- (void)leftButtonClick:(id)sender
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
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280,20)];
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
            lineImageView.tag=102;
        lineImageView.backgroundColor=[UIColor clearColor];
        lineImageView.image=[UIImage imageNamed:@"cellline.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        
        
        
    }
    
    NSDictionary *dic=[self.report.contentArr objectAtIndex:indexPath.row];
    UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentlabel=(UILabel *)[cell.contentView viewWithTag:101];
    

    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:102];
    titleLabel.text=[NSString stringWithFormat:@"%d、%@",indexPath.row+1,[dic objectForKey:@"title"]];
    
    
    NSString *answer=[dic objectForKey:@"answer"];
    
    CGSize size=[answer sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    contentlabel.text=[dic objectForKey:@"answer"];
    
    contentlabel.frame=CGRectMake(20, 35, 280, size.height);
    imageView.frame=CGRectMake(0, size.height+40-1, self.view.frame.size.width, 1);
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // return 60;
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
