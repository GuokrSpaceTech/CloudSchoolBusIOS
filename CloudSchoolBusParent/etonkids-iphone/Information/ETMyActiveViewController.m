//
//  ETMyActiveViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETMyActiveViewController.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "ETEvents.h"
#import "ETActiveDetailViewController.h"
#import "ETActiveCell.h"
#import "UserLogin.h"
#import "ETKids.h"
#import "AppDelegate.h"
@interface ETMyActiveViewController ()

@end

@implementation ETMyActiveViewController
@synthesize dataList;
@synthesize timeArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTableViewDataSource:EGORefreshHeader];
}


- (void)viewDidLoad
{
    theRefreshPos=EGORefreshFooter;
    timeArr=[[NSMutableArray  alloc]init];
     dataList=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delete:) name:@"delete" object:nil];

    [self setNavigationleftImage:[UIImage imageNamed:@"leftNavigation.png"] rightImage:nil];
    [self setGaoliamngleftImage:[UIImage imageNamed:@"clickleftNavigation.png"]  right:nil];
    [self setLeftTitle:LOCAL(@"back", @"返回") RightTitle:nil];
    [self setMiddleText:LOCAL(@"register", @"")];
  
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    
    if(user.loginStatus==LOGIN_SERVER)
    {
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"myevents",nil];
//        [self LoadActiveData:dic];
        
    }
    else
    {
        id obj = [keyedArchiver getArchiver:@"MYACTIVE" forKey:@"MYACTIVE"];
        if (obj != nil)
        {
            [self parserData:obj];
        }
        
    }
    


	// Do any additional setup after loading the view.
}
-(void)delete:(id)sender
{
    
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{

    isLoading=NO;
    [self showHUD:NO];
    if (response==nil) {
        //  DefaultView.hidden=NO;
    }
    if (code == -1113)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"mutilDevice", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.loginStatus==LOGIN_OFF)
        {
            
            [[EKRequest Instance] clearSid];
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
            return;
        }
        
        
        [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == eventslist) {
        if(code==1)
        {
            //  NSArray *arr= (NSArray *)response;
            NSArray * arr=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            if(theRefreshPos==EGORefreshFooter)
            {
                if([arr count]<10)
                {
                    isMore=NO;
                }
                else
                {
                    isMore=YES;
                }
            }
            else
            {
                isMore=YES;
            }
            
            [keyedArchiver setArchiver:@"ACTIVE" withData:arr forKey:@"ACTIVE"];
            
            [self parserData:arr];
            
        }
        else if (code == -2)
        {
            if (theRefreshPos == EGORefreshHeader) {
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
                [dataList removeAllObjects];
                [timeArr removeAllObjects];
                [self._tableView reloadData];
            }
        }
        else
        {
            isMore=YES;
            if(_refreshHeaderView)
            {
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
            }
            if(_refreshFooterView)
            {
                [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
                [self removeFooterView];
            }
        }
    }
    else if (method == signin && code == 1)
    {
        [[EKRequest Instance] clearSid];
        UserLogin *user=[UserLogin currentLogin];
        user.loginStatus=LOGIN_OFF;
        
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
    }
    
    
    

}

/**
 *	@brief  封装原始数据为资讯类 并加入到数据列表.
 *
 *	@param 	arr 	初始数据列表.
 */

-(void)parserData:(NSArray *)arr
{
    if(theRefreshPos==EGORefreshFooter)
    {
        
        for (int i=0; i<[arr count]; i++) {
        
            ETEvents *events=[[ETEvents alloc]init];
            events.isMyActive=YES;
            events.SignupStatus=[[arr objectAtIndex:i] objectForKey:@"SignupStatus"];
            events.isSignup=[[arr objectAtIndex:i] objectForKey:@"isSignup"];
            events.addtime=[[arr objectAtIndex:i] objectForKey:@"addtime"];
            events.events_id=[[arr objectAtIndex:i] objectForKey:@"events_id"];
            events.shool_id=[[arr objectAtIndex:i] objectForKey:@"schoolid"];
            events.sign_up=[[arr objectAtIndex:i] objectForKey:@"sign_up"];
            events.title=[[arr objectAtIndex:i] objectForKey:@"title"];
            isLoading=NO;
            [dataList addObject:events];
            [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"events_id"]];
            [events release];
        
        }
    }
    else
    {
        [dataList removeAllObjects];
        [timeArr removeAllObjects];
        for (int i=0; i<[arr count]; i++) {
            
            ETEvents *events=[[ETEvents alloc]init];
            events.isMyActive=YES;
            events.SignupStatus=[[arr objectAtIndex:i] objectForKey:@"SignupStatus"];
            events.isSignup=[[arr objectAtIndex:i] objectForKey:@"isSignup"];
            events.addtime=[[arr objectAtIndex:i] objectForKey:@"addtime"];
            events.events_id=[[arr objectAtIndex:i] objectForKey:@"events_id"];
            events.shool_id=[[arr objectAtIndex:i] objectForKey:@"schoolid"];
            events.sign_up=[[arr objectAtIndex:i] objectForKey:@"sign_up"];
            events.title=[[arr objectAtIndex:i] objectForKey:@"title"];
            isLoading=NO;
            [dataList addObject:events];
            [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"events_id"]];
//            [dataList insertObject:events atIndex:0];
//            [timeArr insertObject:[[arr objectAtIndex:i] objectForKey:@"events_id"] atIndex:0];
            [events release];

        }
    }
    
    isLoading=NO;
    if(_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
    [self._tableView reloadData];

    
}
-(void) getErrorInfo:(NSError *) error
{
    [self showHUD:NO];
    if(_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
    isLoading=NO;
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    
}
-(void)showHUD:(BOOL) animation
{
    if(animation)
    {
        if(HUD==nil)
        {
            
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
            [delegate.window addSubview:HUD];
            [HUD show:YES];
            [HUD release];
        }
        
    }
    else
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    ETActiveCell *cell=(ETActiveCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==NULL)
    {
        cell=[[[ETActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row==[self.dataList count]-1)
    {
        if(isMore)
        [self setFooterView];
    }

    if([dataList count]>0)
    {
        ETEvents *events=[dataList objectAtIndex:indexPath.row];
        cell.nameLabel.text=events.title;
        cell.dateLabel.text=events.addtime;
    
        switch ([events.SignupStatus integerValue]) {
            case 1:
                cell.stateLabel.text=LOCAL(@"activeStatus4", @"进行中");// @"进行中";
                break;
            case -1:
                cell.stateLabel.text=LOCAL(@"activeStatus1", @"未开始");//未开始
                break;
            case -2:
                cell.stateLabel.text=LOCAL(@"activeStatus2", @"已结束");//已结束
                break;
            case -3:
                cell.stateLabel.text=LOCAL(@"activeStatus3", @"满员");//满员
                break;
                
            default:
                break;
        }

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETActiveDetailViewController *detailViewController=[[ETActiveDetailViewController alloc]init];
    detailViewController.etevent=[dataList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)LoadActiveData:(NSDictionary*)dic
{
    [self showHUD:YES];
    [[EKRequest Instance]EKHTTPRequest:eventslist parameters:dic requestMethod:GET forDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *) getMaxTime
{
    [self.timeArr sortUsingComparator:^NSComparisonResult(id x,id y)
     {
         return [x compare:y options:NSNumericSearch];
     }];
    
    return [self.timeArr lastObject];
    
}
-(NSString *) getMinTime
{
    [self.timeArr sortUsingComparator:^NSComparisonResult(id x,id y)
     {
         return [x compare:y options:NSNumericSearch];
     }];
    
    return [self.timeArr objectAtIndex:0];
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    //NSLog(@"%d/r",__LINE__);
	[self reloadTableViewDataSource:aRefreshPos];
}



- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //取信息
    
    if(aRefreshPos == EGORefreshHeader)
    {
        isLoading = YES;
        theRefreshPos=EGORefreshHeader;
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"myevents",  @"0",@"startid",@"0",@"endid",nil];
        [self LoadActiveData:dic];
        
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            //连接服务器
            isLoading = YES;
            theRefreshPos=EGORefreshFooter;
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"myevents",[self getMinTime],@"startid",@"0",@"endid",nil];
            [self LoadActiveData:dic];
        }
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    NSLog(@"%d/r",__LINE__);
	return isLoading; // should return if data source model is reloading
    
}

//返回刷新时间的回调方法
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    NSLog(@"%d/r",__LINE__);
	return [NSDate date]; // should return date data source was last changed
}


- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}


@end
