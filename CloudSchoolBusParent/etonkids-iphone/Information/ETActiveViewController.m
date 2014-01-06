//
//  ETActiveViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETActiveViewController.h"
#import "ETActiveCell.h"
#import "ETActiveDetailViewController.h"
#import "ETApi.h"
#import "UserLogin.h"
#import "ETEvents.h"
#import "keyedArchiver.h"
#import "ETMyActiveViewController.h"
#import "AppDelegate.h"
@interface ETActiveViewController ()

@end

@implementation ETActiveViewController
@synthesize dataList,DefaultView;
@synthesize timeArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    rightButton.frame = CGRectMake(225, rightButton.frame.origin.y, 90, rightButton.frame.size.height);
}

- (void)viewDidLoad
{
//    timeArr=[[NSMutableArray alloc]init];
//    theRefreshPos=EGORefreshFooter;
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [super viewDidLoad];
    [self setNavigationleftImage:[UIImage imageNamed:@"leftNavigation.png"] rightImage:[UIImage imageNamed:@"rightNavigation.png"]];
    [self setGaoliamngleftImage:[UIImage imageNamed:@"clickLeftNavigation.png"] right:[UIImage imageNamed:@"clickrightNavigation.png"]];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [self setLeftTitle:LOCAL(@"back",@"返回") RightTitle:LOCAL(@"Registation",@"我的报名")];
    [self setMiddleText:LOCAL(@"baomingAct", @"活动报名")];
     dataList=[[NSMutableArray alloc]init];
   	// Do any additional setup after loading the view.
    //默认区域
     CGFloat HightLabel;
    DefaultView=[[UIView alloc]init];
    if (!iphone5)
    {
        HightLabel=160;
        DefaultView=[[UIView alloc]initWithFrame:CGRectMake(0,44,320,460-44)];
    }
    else
    {
        HightLabel=230;
        DefaultView=[[UIView alloc]initWithFrame:CGRectMake(0,44,320,560-44)];
    }
    [self.view addSubview:DefaultView];
    DefaultView.backgroundColor=[UIColor whiteColor];
    DefaultView.hidden=YES;
    [DefaultView release];
    //默认字体
    UILabel  *defaultlabel=[[UILabel alloc]initWithFrame:CGRectMake(0,HightLabel,320,80)];
    [DefaultView addSubview:defaultlabel];
    defaultlabel.backgroundColor=[UIColor clearColor];
    defaultlabel.text=LOCAL(@"defaultactivity",@"暂无活动报名");
    defaultlabel.font=[UIFont systemFontOfSize:28];
    defaultlabel.textColor=[UIColor grayColor];
    defaultlabel.textAlignment=UITextAlignmentCenter;
    
     UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus==LOGIN_SERVER)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"myevents",nil];
        [self LoadActiveData:dic];
        
    }
    else
    {
        id obj = [keyedArchiver getArchiver:@"ACTIVE" forKey:@"ACTIVE"];
        if (obj != nil)
        {
            [self parserData:obj];
        }
        
    }

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
            // NSArray *arr= (NSArray *)response;
            
            NSArray *arr =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
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
 *	@brief  处理封装初始数据 并加入到数据列表.
 *
 *	@param 	arr 请求到的数据.
 */

-(void)parserData:(NSArray *)arr
{
    if(theRefreshPos==EGORefreshFooter)
    {
        
      for (int i=0; i<[arr count]; i++) {
        ETEvents *events=[[ETEvents alloc]init];
        events.SignupStatus=[[arr objectAtIndex:i] objectForKey:@"SignupStatus"];
        events.addtime=[[arr objectAtIndex:i] objectForKey:@"addtime"];
        events.events_id=[[arr objectAtIndex:i] objectForKey:@"events_id"];
        events.shool_id=[[arr objectAtIndex:i] objectForKey:@"schoolid"];
        events.title=[[arr objectAtIndex:i] objectForKey:@"title"];
        events.isMyActive=NO;
          [dataList addObject:events];
          [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"events_id"]];
                  [events release];
      }
    }
        else
        {
            for (int i=0; i<[arr count]; i++) {
                ETEvents *events=[[ETEvents alloc]init];
                events.SignupStatus=[[arr objectAtIndex:i] objectForKey:@"SignupStatus"];
                events.addtime=[[arr objectAtIndex:i] objectForKey:@"addtime"];
                events.events_id=[[arr objectAtIndex:i] objectForKey:@"events_id"];
                events.shool_id=[[arr objectAtIndex:i] objectForKey:@"schoolid"];
                events.title=[[arr objectAtIndex:i] objectForKey:@"title"];
                events.isMyActive=NO;
                [dataList insertObject:events atIndex:0];
                [timeArr insertObject:[[arr objectAtIndex:i] objectForKey:@"events_id"] atIndex:0];
                [events release];

        }
    }
    
    
     isLoading=NO;
     if([dataList count]==0)
            {
                DefaultView.hidden=NO;
            }

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

/**
 *	@brief  加载活动报名数据.
 *
 *	@param 	dic 请求参数.
 */

-(void)LoadActiveData:(NSDictionary*)dic
{
    [self showHUD:YES];
    [[EKRequest Instance]EKHTTPRequest:eventslist parameters:dic requestMethod:GET forDelegate:self];
 
}

-(void)leftButtonClick:(id)sender
{
    //显示tabbar
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];

}

/**
 *	@brief  我的活动点击事件
 *
 */
-(void)rightButtonClick:(id)sender
{
    ETMyActiveViewController *activeVC=[[ETMyActiveViewController alloc]init];
    [self.navigationController pushViewController:activeVC animated:YES];
    [activeVC release];
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
                cell.stateLabel.text=LOCAL(@"activeStatus1", @"未报名");
                break;
            case -2:
                cell.stateLabel.text=LOCAL(@"activeStatus2", @"已报名");
                break;
            case -3:
                cell.stateLabel.text=LOCAL(@"activeStatus3", @"满员");
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
    NSLog(@"%d/r",__LINE__);
	[self reloadTableViewDataSource:aRefreshPos];
}


/// 下拉刷新、加载更多 获取数据.
- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //取信息
    
    if(aRefreshPos == EGORefreshHeader)
    {
        isLoading = YES;
        theRefreshPos=EGORefreshHeader;
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"myevents",  @"0",@"startid",[self getMaxTime],@"endid",nil];
            [self LoadActiveData:dic];
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
        //连接服务器
        isLoading = YES;
        theRefreshPos=EGORefreshFooter;
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"myevents",[self getMinTime],@"startid",@"0",@"endid",nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.dataList=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
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
