//
//  GKHealthListViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKHealthListViewController.h"
#import "ETKids.h"
#import "GKHealthCell.h"
#import "MD5.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "UserLogin.h"
#import "CYProblem.h"
#import "NSDate+convenience.h"
#import "GKHealthDetaiViewController.h"
#import "HealthFirstView.h"
@interface GKHealthListViewController ()

@end

@implementation GKHealthListViewController
@synthesize _tableView;
@synthesize dateArr;
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    NSString * health =[user objectForKey:@"Health"];
    if(health==nil)
    {
        CGRect rect=[UIScreen mainScreen].bounds;
        HealthFirstView *firstView=[[HealthFirstView alloc]initWithFrame:CGRectMake(0, 0,rect.size.width,rect.size.height)];
        firstView.backgroundColor=[UIColor clearColor];
        
        
        AppDelegate *delegate=SHARED_APP_DELEGATE;
        
        [delegate.window addSubview:firstView];
        [firstView release];
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
    middleLabel.text =  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];

    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 70, 28)];
    [rightButton setCenter:CGPointMake(320 - 10 - 70/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:NSLocalizedString(@"doctor_tiwen", @"提问") forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"health_button.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"health_buttoned.png"] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:rightButton];
    
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

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

    
    dateArr=[[NSMutableArray alloc]init];
    currentnumber=0;
    [self loadData:currentnumber];
    

    
    UILabel *alertLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0-20, self.view.frame.size.width, 30)];
    alertLabel.backgroundColor=[UIColor clearColor];
    alertLabel.text=@"您尚未提问过，马上提问吧";
    alertLabel.tag=10000;
    alertLabel.hidden=YES;
    alertLabel.textColor=[UIColor grayColor];
    alertLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:alertLabel];

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

-(void)refreshDetailVC
{
      currentnumber=0;
    [self loadData:0];
    isUpfresh=YES;
}
-(void)loadData:(int)number
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
    isLoading=YES;
    int time= [[NSDate date] timeIntervalSince1970];
    UserLogin *user=[UserLogin currentLogin];
    

//    [resuest setPostValue:user.username forKey:@"user_id"];
    
    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,user.username,@"testchunyu"];
    //
    NSString *sign=[MD5 md5:string];
    
    NSString *atime= [NSString stringWithFormat:@"%d",time];
    NSString *parm=[NSString stringWithFormat:@"user_id=%@&sign=%@&atime=%@&start_num=%@&count=%@",user.username,sign,atime,[NSNumber numberWithInt:number],@"20"];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem/list/my?%@",parm]];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];

    [request setDelegate:self];
    //    //配置代理为本类
    [request setTimeOutSeconds:10];
    //    //设置超时
    [request setDidFailSelector:@selector(urlRequestFailed:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
    //    
    [request startAsynchronous];
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request
{
    NSLog(@"%@",request.responseHeaders);
    isLoading=NO;
    NSLog(@"%@",request.responseString);
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    id  resst=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if([resst isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic=resst;
        
        if([[dic objectForKey:@"error"] intValue]==1)
        {
            NSLog(@"%@",[dic objectForKey:@"error_msg"]);
            
  
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:[dic objectForKey:@"error_msg"]  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];

            
        
        }
    }
    else
    {
        NSArray *arr=resst;
        if([arr count]==20)
        {
            currentnumber=currentnumber+[arr count];
            hasmore=YES;
        }
        else
        {
            hasmore=NO;
        }
        if(isUpfresh)
        {
            [dateArr removeAllObjects];
        }
        for (int i=0; i<[arr count]; i++) {
            CYProblem * problem=[[CYProblem alloc]init];
            NSDictionary *dic=[arr objectAtIndex:i];
            NSDictionary *dicinfo=[dic objectForKey:@"problem"];
            // problem.status=@"c";
            problem.status=[dicinfo objectForKey:@"status"];
            problem.created_time=[dicinfo objectForKey:@"created_time"];
            problem.ask=[dicinfo objectForKey:@"ask"];
            problem.problemId=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"id"]];
            problem.title=[dicinfo objectForKey:@"title"];
            problem.created_time_ms=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"created_time_ms"]];
            problem.clinic_name=[dicinfo objectForKey:@"clinic_name"];
            [dateArr addObject:problem];
            [problem release];
        }
        if(self._refreshFooterView)
        {
            [self._refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
            [self removeFooterView];
        }
        [_slimeView endRefresh];
         UILabel *label=(UILabel *)[self.view viewWithTag:10000];
        if([dateArr count]==0)
        {
           
            label.hidden=NO;
//            alertLabel.tag=10000;
//            alertLabel.hidden=YES;
        }
        else
        {
        
            label.hidden=YES;

        }
        
        [_tableView reloadData];
    }
    

}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];

    NSLog(@"%@",request.error.description);
    isLoading=NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 137+20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateArr count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    GKHealthCell *cell=(GKHealthCell *)[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[GKHealthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
    }
    CYProblem *problem=[dateArr objectAtIndex:indexPath.row];
    if(hasmore)
        [self setFooterView];
    else
        [self removeFooterView];
    cell.titleLatel.text=problem.clinic_name;
    cell.contentLatel.text=problem.ask;
    
    //----- calculate time -----------
    NSString *time = [problem.created_time_ms substringToIndex:10];
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
    
//    "doctor_new"="新问题";
//    "doctor_renling"="已认领";
//    "doctor_newrelpay"="新回复";
//    "doctor_daichuli"="带处理";
//    "doctor_yidafu"="已答复";
//    "doctor_daipingjia"="待评价";
//    "doctor_yipingja"="已评价";
//    "doctor_jibao"="系统举报";
    
    cell.timeLatel.text=dateStr;
  //  _pointImageView
    
    cell.pointImageView.hidden=YES;
    
    if([problem.status isEqualToString:@"i"])
    {
        cell.stateLatel.text=@"空白问题";
    }
    if([problem.status isEqualToString:@"n"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_new", @"");
        
    }
    if([problem.status isEqualToString:@"a"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_renling", @"");
    }
    if([problem.status isEqualToString:@"s"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_newrelpay", @"");
        cell.pointImageView.hidden=NO;
    }
    if([problem.status isEqualToString:@"c"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_daipingjia", @"");
         cell.pointImageView.hidden=NO;
    }
    if([problem.status isEqualToString:@"v"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_yidafu", @"");
    }
    if([problem.status isEqualToString:@"p"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_jibao", @"");
        
    }
    if([problem.status isEqualToString:@"d"])
    {
        cell.stateLatel.text=NSLocalizedString(@"doctor_yipingja", @"");
        
     
    }
    return cell;

    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CYProblem *po=[dateArr objectAtIndex:indexPath.row];
    GKHealthDetaiViewController *healthDetailVC=[[GKHealthDetaiViewController alloc]init];
    healthDetailVC.problem=po;
    AppDelegate *appDel=SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:healthDetailVC animated:YES];
    [healthDetailVC release];
    
}

-(void)rightButtonClick:(UIButton *)btn
{
    GKWriteHealthViewController * writeHealthVC=[[GKWriteHealthViewController alloc]init];
    
    writeHealthVC.delegate=self;
    AppDelegate *appDel= SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:writeHealthVC animated:YES];
    [writeHealthVC release];
    
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    //    [self showHUD:YES];
    currentnumber=0;
    [self loadData:0];
    isUpfresh=YES;
  //  [self loadNotice:param];
    //theRefreshPos = EGORefreshHeader;
    //[self requestNoticeData:nil];
}
- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    
    //GKNotice *sc = [self.noticeList lastObject];
   // NSString *lastTime = sc.addtime;
    
   // NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",nil];
  //  [self loadNotice:param];
    
    [self loadData:currentnumber];
    isLoading=YES;
     isUpfresh=NO;
    
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

- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self._tableView=nil;
    self.dateArr=nil;
    self._slimeView=nil;
    self._refreshFooterView=nil;
    [super dealloc];
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
