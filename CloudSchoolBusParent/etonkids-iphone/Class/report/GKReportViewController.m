//
//  GKReportViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-6.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKReportViewController.h"
#import "ETKids.h"
#import "NSDate+convenience.h"
#import "GKReport.h"
#import "GKSearchViewController.h"
#import "GKReportContentViewController.h"
@interface GKReportViewController ()

@end

@implementation GKReportViewController
@synthesize _tableView;
@synthesize list;
@synthesize _slimeView;;
@synthesize _refreshFooterView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{

    self._tableView=nil;
    self.list=nil;
    self._slimeView=nil;
    self._refreshFooterView=nil;
    [super dealloc];
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
    middleLabel.text =NSLocalizedString(@"classribao", @"");//  NSLocalizedString(@"doctor_con", @"医生咨询");
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
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder=NSLocalizedString(@"searchreport", @"");
    _searchBar.delegate=self;
    _searchBar.showsCancelButton=YES;
    
    _tableView.tableHeaderView=[_searchBar autorelease];

    
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
    
    
    list=[[NSMutableArray alloc]init];
  //  currentnumber=0;
   // [self loadData:currentnumber];

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];
    
    [self loadNotice:dic];

    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    GKSearchViewController *searchVC=[[GKSearchViewController alloc]init];
    searchVC.searchcontent=searchBar.text;
    [self.navigationController pushViewController:searchVC animated:YES];
    [searchVC release];
     searchBar.text=@"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.text=@"";
}

-(void)loadNotice:(NSDictionary *)pram
{
    NSLog(@"%@",pram);
    isLoading=YES;
    // [[EKRequest Instance]EKHTTPRequest:tnotice parameters:pram requestMethod:GET forDelegate:self];
    [[EKRequest Instance]EKHTTPRequest:report parameters:pram requestMethod:GET forDelegate:self];
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    // 修改提示错误 网络错误11
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    isLoading=NO;
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);
    isLoading=NO;
    if(method==report && code==1)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        
        if([[param objectForKey:@"starttime"] isEqualToString:@"0"] && [[param objectForKey:@"endtime"] isEqualToString:@"0"])
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
                report.studentname=[dic objectForKey:@"studentname"];
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
                report.studentname=[dic objectForKey:@"studentname"];
                report.reporttime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"reporttime"]];
                report.teachername=[dic objectForKey:@"teachername"];
                report.reportname=[dic objectForKey:@"reportname"];
                report.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
                [list addObject:report];
                [report release];
                
            }
            
            
            
            
        }
        
        //dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];
        
    }
//    if([list count]==0)
//    {
//        [self setNOView:NO];
//    }
//    else
//    {
//        [self setNOView:YES];
//    }
    if(self._refreshFooterView)
    {
        [self._refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
    [_slimeView endRefresh];
    [_tableView reloadData];
    
    
    
    
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

- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        lineImageView.image=[UIImage imageNamed:@"cellline.png"];
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
    
    
    titleLabel.text=[NSString stringWithFormat:@"%@ %@",report.reportname,tmp];
    timelabel.text=[self timeStr:report.createtime];
    
    
    if(indexPath.row==[self.list count]-1)
    {
        if(isMore)
            [self setFooterView];
        else
            [self removeFooterView];
    }
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
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];
    
    [self loadNotice:dic];
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
