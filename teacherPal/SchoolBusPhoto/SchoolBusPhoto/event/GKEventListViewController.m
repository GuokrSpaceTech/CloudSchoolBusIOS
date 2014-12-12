//
//  GKEventListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-11.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKEventListViewController.h"
#import "KKNavigationController.h"
#import "GKMainViewController.h"
#import "ETEvents.h"
#import "ETActivityCell.h"
#import "GKEventWebViewController.h"
@interface GKEventListViewController ()

@end

@implementation GKEventListViewController
@synthesize _tableView,list;
@synthesize isLoading,isMore;
@synthesize _refreshFooterView,_slimeView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    list=[[NSMutableArray alloc]init];
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
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
    
    titlelabel.text=@"活动报名";

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"startid",@"0",@"endid", nil];
    [self loadEventList:dic];
}


-(void)loadEventList:(NSDictionary *)dic
{

    isLoading=YES;
    [[EKRequest Instance] EKHTTPRequest:teachereventslist parameters:dic requestMethod:GET forDelegate:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}

#pragma mark =========== 网络请求 代理================
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    isLoading=NO;
    
     NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
     NSLog(@"%@",aa);
    if(code==1&&method==teachereventslist)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",arr);
        if([[parm objectForKey:@"startid"] isEqualToString:@"0"] && [[parm objectForKey:@"endid"] isEqualToString:@"0"])
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
                
                ETEvents *events=[[ETEvents alloc]init];
                events.SignupStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
                events.addtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                events.events_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"events_id"]];
                events.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                events.end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"end_time"]];
                events.htmlurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"htmlurl"]];
                events.sign_up_end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_end_time"]];
                events.sign_up_start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_start_time"]];
                events.start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_time"]];
                events.num=[NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
                events.peopleArr=[dic objectForKey:@"list"];
                [list addObject:events];
                [events release];
                
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
                ETEvents *events=[[ETEvents alloc]init];
                events.SignupStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
                events.addtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                events.events_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"events_id"]];
                events.end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"end_time"]];
                events.htmlurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"htmlurl"]];
                events.num=[NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
                events.peopleArr=[dic objectForKey:@"list"];
                events.sign_up_end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_end_time"]];
                events.sign_up_start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_start_time"]];
                events.start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_time"]];
                events.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                [list addObject:events];
                [events release];
            }
            
            
        }
        
        //dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];
        
    }
//    if([noticeList count]==0)
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
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    isLoading=NO;
}

#pragma mark =============== uitableView 代理 ===============

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"classCell1";
    ETActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[ETActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:220/255.0f green:218/255.0f blue:207/255.0f alpha:1.0f];
            cell.backgroundColor=[UIColor clearColor];
    }
    
  
    
    ETEvents *event = [self.list objectAtIndex:indexPath.row];
    
    cell.events=event;

    if(indexPath.row==[self.list count]-1)
    {
        if(isMore)
        [self setFooterView];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETEvents *event=[self.list objectAtIndex:indexPath.row];
    
    GKEventWebViewController *VC=[[GKEventWebViewController alloc]init];
    VC.urlstr=event.htmlurl;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}


#pragma mark =======刷新==========



- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"startid",@"0",@"endid",nil];
    [self loadEventList:param];
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
    
    ETEvents *sc = [self.list lastObject];
    NSString *lastTime = sc.events_id;
//    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"startid",@"0",@"endid",nil];
    [self loadEventList:param];
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



-(void)dealloc
{
    self.list=nil;
    self._tableView=nil;
    self._slimeView=nil;
    self._refreshFooterView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
