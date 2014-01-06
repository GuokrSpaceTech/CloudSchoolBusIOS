//
//  ETInformationViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETInformationViewController.h"
#import "ETInformation.h"
#import "Infomation.h"
#import "ETDetailInfoViewController.h"
#import "AppDelegate.h"
#import "UserLogin.h"
#import "ETKids.h"
#import "ETMyCollectViewController.h"
#import "keyedArchiver.h"
#import "LeveyTabBarController.h"
@interface ETInformationViewController ()

@end

@implementation ETInformationViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    timeArr=[[NSMutableArray alloc]init];
    theRefreshPos=EGORefreshFooter;
    [self setNavigationleftImage:[UIImage imageNamed:@"leftNavigation.png"] rightImage:[UIImage imageNamed:@"rightNavigation.png"]];
    [self setGaoliamngleftImage:[UIImage imageNamed:@"clickLeftNavigation.png"] right:[UIImage imageNamed:@"clickrightNavigation.png"]];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [self setLeftTitle:LOCAL(@"back","返回") RightTitle:LOCAL(@"Favorites","我的收藏")];
    [self setMiddleText:LOCAL(@"EducationInfo", @"教育资讯") ];
    
    dataList=[[NSMutableArray alloc]init];

    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];

    if(user.loginStatus==LOGIN_SERVER)
    {
      NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ismy",nil];
        [self loadData:dic];
    }
    else
    {
        
        id obj = [keyedArchiver getArchiver:@"INFO" forKey:@"INFO"];
        if (obj != nil)
        {
            [self parser:obj];
        }

    }
  
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
    
    UILabel  *defaultlabel=[[UILabel alloc]initWithFrame:CGRectMake(0,HightLabel,320,80)];
    [DefaultView addSubview:defaultlabel];
    defaultlabel.backgroundColor=[UIColor clearColor];
    defaultlabel.text=LOCAL(@"defaulteducation", @"暂无教育咨询");
    defaultlabel.font=[UIFont systemFontOfSize:28];
    defaultlabel.textColor=[UIColor grayColor];
    defaultlabel.textAlignment=UITextAlignmentCenter;
    [defaultlabel release];
    [DefaultView release];

}


/**
 *	@brief  加载教育资讯数据
 *
 *	@param 	dic 请求参数
 */
-(void)loadData:(NSDictionary *)dic

{
    [self showHUD:YES];
    [[EKRequest Instance]EKHTTPRequest:advertoriallist parameters:dic requestMethod:GET forDelegate:self];
}

/**
 *	@brief  处理封装初始数据 并加入到数据列表.
 *
 *	@param 	arr 请求到的数据.
 */

-(void)parser:(NSArray *)arr
{

    if(theRefreshPos==EGORefreshFooter)
    {
        for (int i=0; i<[arr count]; i++) {
            
            NSNumber *num= [[arr objectAtIndex:i] objectForKey:@"publishtime"];
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:[num integerValue]];
            NSLog(@"%@",[date description]);
            Infomation *info=[[Infomation alloc]init];
            info.infoId=[[arr objectAtIndex:i] objectForKey:@"id"];
            info.linkage=[[arr objectAtIndex:i] objectForKey:@"linkage"];
            info.publishTime=[[arr objectAtIndex:i] objectForKey:@"publishtime"];
            info.thumbnail=[[arr objectAtIndex:i] objectForKey:@"thumbnail"];
            info.title=[[arr objectAtIndex:i] objectForKey:@"title"];
            info.isCollect=NO;
            [dataList addObject:info];
            [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"id"]];
            [info release];
        }

    }
    else
    {
        for (int i=0; i<[arr count]; i++) {
            NSNumber *num= [[arr objectAtIndex:i] objectForKey:@"publishtime"];
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:[num integerValue]];
            NSLog(@"%@",[date description]);
            Infomation *info=[[Infomation alloc]init];
            info.infoId=[[arr objectAtIndex:i] objectForKey:@"id"];
            info.linkage=[[arr objectAtIndex:i] objectForKey:@"linkage"];
            info.publishTime=[[arr objectAtIndex:i] objectForKey:@"publishtime"];
            info.thumbnail=[[arr objectAtIndex:i] objectForKey:@"thumbnail"];
            info.title=[[arr objectAtIndex:i] objectForKey:@"title"];
            info.isCollect=NO;
            [dataList insertObject:info atIndex:0];
            [timeArr insertObject:[[arr objectAtIndex:i] objectForKey:@"id"] atIndex:0];
            [info release];
        }

    }
    
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
    
    [_tableView reloadData  ];


}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    NSLog(@"kk=%@",response);
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
    else if (method == advertoriallist) {
        if(code==1)
        {
            NSArray *arr =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            
            //NSArray *arr= (NSArray *)response;
            //        NSLog(@"%@",dic);
            
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
            
            [keyedArchiver setArchiver:@"INFO" withData:arr forKey:@"INFO"];
            
            [self parser:arr];
            
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
-(void) getErrorInfo:(NSError *) error
{      // DefaultView.hidden=NO;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETDetailInfoViewController *detailVC=[[ETDetailInfoViewController alloc]init];
    detailVC.info=[dataList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
-(void)leftButtonClick:(id)sender
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
    
}


/**
 *	@brief  我的收藏点击事件 push到我的收藏页面
 *	
 */
-(void)rightButtonClick:(id)sender
{
    ETMyCollectViewController *collectVC=[[ETMyCollectViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
    [collectVC release];
    
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
    ETInformation *cell=(ETInformation *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==NULL)
    {
        cell=[[[ETInformation alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if(indexPath.row==[self.dataList count]-1)
    {
        
        if(isMore)
            [self setFooterView];
    }

    Infomation *info=[dataList objectAtIndex:indexPath.row];
    cell.nameLabel.text=info.title;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[info.publishTime integerValue]];
    cell.dateLabel.text=[[date description] substringToIndex:10];;  //info.publishTime;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //取信息

    if(aRefreshPos == EGORefreshHeader)
    {
        isLoading = YES;
        theRefreshPos=EGORefreshHeader;

        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ismy",  @"0",@"startid",[self getMaxTime],@"endid",nil];
        [self loadData:dic];
    
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            //连接服务器
            isLoading = YES;
            theRefreshPos=EGORefreshFooter;
 
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ismy",  [self getMinTime],@"startid",@"0",@"endid",nil];
            [self loadData:dic];
    
        }
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    NSLog(@"%d/r",__LINE__);
	return isLoading; // should return if data source model is reloading
    
}

/// 返回刷新时间的回调方法.
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    NSLog(@"%d/r",__LINE__);
	return [NSDate date]; // should return date data source was last changed
}
-(void)dealloc
{
    self.dataList=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
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
