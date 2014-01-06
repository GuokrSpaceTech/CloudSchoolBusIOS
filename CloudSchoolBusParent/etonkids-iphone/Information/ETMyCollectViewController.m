//
//  ETMyCollectViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETMyCollectViewController.h"
#import "Infomation.h"
#import "ETInformation.h"
#import "AppDelegate.h"
#import "UserLogin.h"
#import "ETDetailInfoViewController.h"
#import "keyedArchiver.h"
#import "ETKids.h"
#import "ETCommonClass.h"

@interface ETMyCollectViewController ()

@end

@implementation ETMyCollectViewController
@synthesize dataList;
@synthesize indexpath;
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
    isLoading=NO;
    isMore=NO;
    theRefreshPos=EGORefreshFooter;
    [self setNavigationleftImage:[UIImage imageNamed:@"leftNavigation.png"] rightImage:nil];
    [self setGaoliamngleftImage:[UIImage imageNamed:@"clickleftNavigation.png"]  right:nil];
    [self setLeftTitle:LOCAL(@"back", @"返回") RightTitle:nil];
    [self setMiddleText:LOCAL(@"myFavor", @"")];
    
    dataList=[[NSMutableArray alloc]init];
    timeArr=[[NSMutableArray alloc]init];

    UserLogin *user=[UserLogin currentLogin];
    if(user.loginStatus==LOGIN_SERVER)
    {
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"ismy",nil];
//        [self loadData:dic];
    }
    else
    {
        id obj=[keyedArchiver getArchiver:@"MYCOLLECT" forKey:@"MTCOLLECT"];
        if(obj!=NULL)
        {
            [self parser:obj];
        }
    }
    
  

    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTableViewDataSource:EGORefreshHeader];
    
    
}


/**
 *	@brief  加载数据
 *
 *	@param 	dic 	请求参数
 */
-(void)loadData:(NSDictionary *)dic
{
    [self showHUD:YES];
    
    [[EKRequest Instance]EKHTTPRequest:advertoriallist parameters:dic requestMethod:GET forDelegate:self];
}

/**
 *	@brief  封装原始数据为资讯类 并加入到数据列表.
 *
 *	@param 	arr 	初始数据列表.
 */
-(void)parser:(NSArray *)arr
{
    if(theRefreshPos==EGORefreshFooter)
    {
       for (int i=0; i<[arr count]; i++) {
        Infomation *info=[[Infomation alloc]init];
        info.infoId=[[arr objectAtIndex:i] objectForKey:@"id"];
        info.linkage=[[arr objectAtIndex:i] objectForKey:@"linkage"];
        info.publishTime=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"publishtime"]];
        info.thumbnail=[[arr objectAtIndex:i] objectForKey:@"thumbnail"];
        info.title=[[arr objectAtIndex:i] objectForKey:@"title"];
        info.isCollect=YES;
        [dataList addObject:info];
        [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"id"]];
        [info release];
     }
    }
    
    else
    {
        [dataList removeAllObjects];
        [timeArr removeAllObjects];
        
        for (int i=0; i<[arr count]; i++) {
            Infomation *info=[[Infomation alloc]init];
            info.infoId=[[arr objectAtIndex:i] objectForKey:@"id"];
            info.linkage=[[arr objectAtIndex:i] objectForKey:@"linkage"];
            info.publishTime=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"publishtime"]];
            info.thumbnail=[[arr objectAtIndex:i] objectForKey:@"thumbnail"];
            info.title=[[arr objectAtIndex:i] objectForKey:@"title"];
            info.isCollect=YES;
            [dataList addObject:info];
            [timeArr addObject:[[arr objectAtIndex:i] objectForKey:@"id"]];
//            [dataList insertObject:info atIndex:0];
            [info release];
//            [timeArr insertObject:[[arr objectAtIndex:i] objectForKey:@"id"] atIndex:0];

        }

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
-(void)alertShowText:(NSString *) text
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:text delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    
    isLoading=NO;
    [self showHUD:NO];
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(method==advertoriallist)
    {
        NSLog(@"%@",response);
        if(code==1)
        {
           // NSArray *arr= (NSArray *)response;
              NSArray * arr=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
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
            
            
            [keyedArchiver setArchiver:@"MYCOLLECT" withData:arr forKey:@"MYCOLLECT"];
            
            [self parser:arr];
            
        }
        else if (code == -3)
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

        return;
        

    }
    
    if(response==NULL)
    {
        
        if(code==-3)
        {
            
            
            return;
        }
        else
        {
            [dataList removeObjectAtIndex:indexpath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            [self alertShowText:LOCAL(@"success",  @"删除成功")];
            return;
        }
    }   
    
       
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
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    //cell.textLabel.text=@"dd®";
    cell.nameLabel.text=info.title;
    cell.dateLabel.text=[[[NSDate dateWithTimeIntervalSince1970:[info.publishTime integerValue]]description] substringToIndex:10];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/**
 *  @brief  删除指定数据 并请求借口.
 *
 *	@param 	index 要删除数据的编号.
 */
-(void)deleteIndexpathData:(NSIndexPath *)index
{
    self.indexpath=index;
    Infomation *info=[dataList objectAtIndex:index.row];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:info.infoId,@"id",[NSNumber numberWithInt:0], @"haveCollect",  nil];
    [[EKRequest Instance]EKHTTPRequest:advertorial parameters:dic requestMethod:POST forDelegate:self];

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        [self deleteIndexpathData:indexPath];
       
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETDetailInfoViewController *infoVC=[[ETDetailInfoViewController alloc]init];
    infoVC.info=[dataList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:infoVC animated:YES];
    [infoVC release];
}
-(void)dealloc
{
    self.dataList=nil;
    self.indexpath=nil;
    [super dealloc];
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

/// 加载数据.

- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    
    //取信息
    
    if(aRefreshPos == EGORefreshHeader)
    {
        isLoading = YES;
        theRefreshPos=EGORefreshHeader;
        
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"ismy",  @"0",@"startid",@"0",@"endid",nil];
        [self loadData:dic];
        
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            //连接服务器
            isLoading = YES;
            theRefreshPos=EGORefreshFooter;
            
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"ismy",  [self getMinTime],@"startid",@"0",@"endid",nil];
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
