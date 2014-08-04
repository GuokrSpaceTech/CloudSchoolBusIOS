//
//  GKReportHistoryViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-29.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportHistoryViewController.h"
#import "KKNavigationController.h"
#import "GKReport.h"
#import "NSDate+convenience.h"
#import "GKReportContentViewController.h"
@interface GKReportHistoryViewController ()

@end

@implementation GKReportHistoryViewController
@synthesize _tableView;
@synthesize _slimeView;;
@synthesize _refreshFooterView;
@synthesize isLoading;
@synthesize isMore;
@synthesize list;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)autoDragScrollLoading
{
    [_tableView setContentOffset:CGPointMake(0, -50) animated:NO];
    _slimeView.loading = YES;
    _slimeView.alpha = 0.0f;
    _slimeView.broken = YES;
    
    [_slimeView scrollViewDidScrollToPoint:CGPointMake(0, -50)];
    [_slimeView scrollViewDidEndDraging];
    [_slimeView pullApart];
}
-(void)dealloc
{
    self._tableView=nil;
    self._slimeView=nil;
    self.list=nil;
    self._refreshFooterView=nil;

    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
      titlelabel.text=@"已发布班级报告";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
     _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    list=[[NSMutableArray alloc]init];
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor blackColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    [_tableView addSubview:self._slimeView];

    UIView *noView=[[UIView alloc]initWithFrame:CGRectMake(320/2.0-303/4,self.view.frame.size.height/2.0-262/4-30, 303/2, 262/2+30) ];
    noView.tag=232;
    UIImageView *noImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 303/2, 262/2)];
    noImage.image=IMAGENAME(IMAGEWITHPATH(@"NOData"));
    [noView addSubview:noImage];
    [noImage release];
    
    [self.view addSubview:noView];
    [noView release];
    
    [self setNOView:YES];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];

    [self loadNotice:dic];
    // Do any additional setup after loading the view.
}
-(void)setNOView:(BOOL)an
{
    UIView *view=[self.view viewWithTag:232];
    
    view.hidden=an;
}

-(void)loadNotice:(NSDictionary *)pram
{
    NSLog(@"%@",pram);
   // [[EKRequest Instance]EKHTTPRequest:tnotice parameters:pram requestMethod:GET forDelegate:self];
    [[EKRequest Instance]EKHTTPRequest:report parameters:pram requestMethod:GET forDelegate:self];
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    // 修改提示错误 网络错误11
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);
    
    if(method==report && code==1)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        
        if([[parm objectForKey:@"starttime"] isEqualToString:@"0"] && [[parm objectForKey:@"endtime"] isEqualToString:@"0"])
        {
            // 下拉刷新
            [list removeAllObjects];
            if([arr count]<15)
            {
                isMore=NO;
            }
            else
                isMore=YES;
            for (int i=0; i<[arr count]; i++) {
                NSDictionary *dic=[arr objectAtIndex:i];
                GKReport *report=[[GKReport alloc]init];
                report.reportid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                report.createtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createtime"]];
                report.title=[dic objectForKey:@"title"];
                report.contentArr=[dic objectForKey:@"content"];
                report.studentArr=[dic objectForKey:@"studentname"];
                report.reporttime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"reporttime"]];
                report.teachername=[dic objectForKey:@"teachername"];
                report.reportname=[dic objectForKey:@"reportname"];
                report.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
                [list addObject:report];
                [report release];
                
            }
            
            
        }
        else
        {
            // 下拉刷新
            if([arr count]<15)
            {
                isMore=NO;
            }
            else
                isMore=YES;
            isLoading=NO;
            
            for (int i=0; i<[arr count]; i++) {
                NSDictionary *dic=[arr objectAtIndex:i];
                GKReport *report=[[GKReport alloc]init];
                report.reportid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                report.createtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createtime"]];
                report.title=[dic objectForKey:@"title"];
                report.contentArr=[dic objectForKey:@"content"];
                report.studentArr=[dic objectForKey:@"studentname"];
                report.teachername=[dic objectForKey:@"teachername"];
                report.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
                [list addObject:report];
                [report release];
                
            }


            
            
        }
        
        //dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];
        
    }
    if([list count]==0)
    {
        [self setNOView:NO];
    }
    else
    {
        [self setNOView:YES];
    }
    if(self._refreshFooterView)
    {
        [self._refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
    [_slimeView endRefresh];
    [_tableView reloadData];

        
        
    
}
-(void)leftClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280,20)];
        label.backgroundColor=[UIColor clearColor];
        label.tag=100;
        [cell.contentView addSubview:label];
        [label release];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 280,20)];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.tag=101;
        timeLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        
        
        UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
        lineImageView.backgroundColor=[UIColor clearColor];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        
    }
    
    GKReport *report=[self.list objectAtIndex:indexPath.row];
    UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UILabel *timelabel=(UILabel *)[cell.contentView viewWithTag:101];
    
    NSDate *pdate=[NSDate dateWithTimeIntervalSince1970:[report.reporttime intValue]];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"yyyy-MM-dd";
   NSString * tmp = [NSString stringWithFormat:@"%@",[format stringFromDate:pdate]];
    
    
    titleLabel.text=[NSString stringWithFormat:@"%@ %@ %@",report.reportname,tmp,report.title];
    timelabel.text=[self timeStr:report.createtime];
    
    
    
    return cell;
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKReportContentViewController *contentVC=[[GKReportContentViewController alloc]init];
    contentVC.report=[list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:contentVC animated:YES];
    [contentVC release];
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    //    [self showHUD:YES];
   // NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];

    [self loadNotice:dic];
    //theRefreshPos = EGORefreshHeader;
    //[self requestNoticeData:nil];
}
-(void)setFooterView
{
    
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        _refreshFooterView.hidden = NO;
        _refreshFooterView.frame = CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height);
    }
    else
    {
        LoadMoreTableFooterView *refreshFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        refreshFooterView.delegate = self;
        [_tableView addSubview:refreshFooterView];
        [refreshFooterView release];
        
        self._refreshFooterView = refreshFooterView;
        self._refreshFooterView.backgroundColor=[UIColor clearColor];
    }
    
}
-(void)removeFooterView
{
    //_refreshFooterView.hidden = YES;
    
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}



- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    
    GKReport *sc = [self.list lastObject];
    NSString *lastTime = sc.createtime;
//    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",nil];
    [self loadNotice:param];
    isLoading=YES;
    
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self reloadTableViewDataSource:aRefreshPos];
}


- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	return isLoading; // should return if data source model is reloading
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


//返回刷新时间的回调方法
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date]; // should return date data source was last changed
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
