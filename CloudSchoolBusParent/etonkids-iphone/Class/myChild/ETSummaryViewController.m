//
//  ETSummaryViewController.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 2/2/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ETSummaryViewController.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "ShareContent.h"
#import "ETApi.h"
@interface ETSummaryViewController ()

@end

@implementation ETSummaryViewController
@synthesize isLoading,arrList;
@synthesize shareContent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"UPDATEDATA" object:nil];

    }
    return self;
}
-(void)dealloc
{
    self.arrList=nil;
    self.shareContent=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UPDATEDATA" object:nil];
    [super dealloc];
}


-(void)loadData
{
    currentIndex=0;
     [self showHUD:YES];
  [self performSelectorInBackground:@selector(getDataInbackGround:) withObject:[NSNumber numberWithInt:0]];
   // [self getData:0];
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
-(void)getData:(int)a
{
        
    isLoading=YES;

    
    
    UserLogin *user=[UserLogin currentLogin];
    
    //NSString *param=[NSString stringWithFormat:@"studentId=%@&classId=%@&type=%@&start=%d&offset=10",user.student.studentId ,user.student.StudentClassNum,@"1",currentIndex];
    
    
    NSDictionary *dic=[ETApi requestData:[ETApi askUrl:@"/Client/info/getInfo"] httpMethod:@"POST" httpBody:nil];
    isLoading=NO;

    if(a==0)
    {
    [arrList removeAllObjects];
    }
    if([dic objectForKey:@"code"])
    {
        
    }
    else
    {
        NSArray *arr=[dic objectForKey:@"data"];
        NSNumber *num=[dic objectForKey:@"hasNextPage"];
        isMore=[num integerValue];
        for (int i=0; i<[arr count]; i++)
        {
            NSDictionary *dic=[arr objectAtIndex:i];
            
            ShareContent *share=[[ShareContent alloc]init];
            share.shareId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            share.sharePic=[dic objectForKey:@"Picture"];
            share.shareContent=[dic objectForKey:@"Content"];
            share.shareTitle=[dic objectForKey:@"Title"];
            share.shareTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"SendDate"]];
            share.isMore=NO;
            [arrList addObject:share];
            [share release];
        }
        currentIndex+=[arr count];
        
       
    }
    
  
     [self performSelectorOnMainThread:@selector(upDateUI) withObject:nil waitUntilDone:YES];


    
    
}
-(void)upDateUI
{
    [self showHUD:NO];
    isLoading=NO;
    [self._tableView reloadData];
    
    if (self._slimeView) {
        [self._slimeView endRefresh];
    }

    if(self._refreshFooterView)
    {
        [self._refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }

}
-(void)getDataInbackGround:(NSNumber *)num
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
   
    [self getData:[num integerValue]];
    [pool release];
}

-(void)headerViewBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isMore=NO;
    arrList=[[NSMutableArray alloc]init];

    isLoading=NO;
     [self showHUD:YES];
    [self performSelectorInBackground:@selector(getDataInbackGround:) withObject:[NSNumber numberWithInt:0]];
   // [self getData:0];
	// Do any additional setup after loading the view.
}

-(void)shareCell:(ClassShareCell *)_notice share:(ShareContent *)info
{
    info.isMore=!info.isMore;
    [self removeFooterView];
    [self._tableView reloadData];
}

-(void)shareWeibo:(ShareContent *)info
{
    self.shareContent=info;
    [self showActionSheet];
}
-(void)shareController:(NSInteger)shareType
{
//    ETShareViewController *shareController=[[[ETShareViewController alloc]initWithNibName:@"ETShareViewController" bundle:nil] autorelease];
//    
//    shareController.shareType=shareType;
//    shareController.content=shareContent.shareContent;
//    shareController.pic=self.shareContent.sharePic;
//    [self pushShareViewController:shareController];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"%d",buttonIndex);
    if(buttonIndex==0)
    {
        //新浪
        WeiboAccount *account=[[WeiboAccounts shared] currentAccount];
        if(!account || account.accessToken==nil)
        {
            [self hidTabBar:@"0"];
            [_weiboSignIn signInOnViewController:self];
        }
        else
        {
            [self shareController:1];
            
        }
        
        
    }
    if(buttonIndex==1)
    {
        //腾讯
        if([[weiboEngine openId] length]>0)
        {
            if(![weiboEngine isAuthorizeExpired])
            {
                [self hidTabBar:@"0"];
                [weiboEngine logInWithDelegate:self
                                     onSuccess:@selector(onSuccessLogin)
                                     onFailure:@selector(onFailureLogin:)];
            }
            else
            {
                [self shareController:2];
            }
            
        }
        else
        {
            [self hidTabBar:@"0"];
            [weiboEngine logInWithDelegate:self
                                 onSuccess:@selector(onSuccessLogin)
                                 onFailure:@selector(onFailureLogin:)];
            
        }
    }
    if(buttonIndex==2)
    {
        //微信
        
        [self shareController:3];
        
        
    }
}


-(void)back:(UIButton *)button
{
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[arrList count]);
  
    // Return the number of rows in the section.
    return [arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ClassShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[[ClassShareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       
    }
    if(indexPath.row==[arrList count]-1)
    {
    
            if(isMore)
            [self setFooterView];
    }
    
    ShareContent *info=[arrList objectAtIndex:indexPath.row];
    cell.theShareCtnt=info;
    
    
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // return 200;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareContent *_shareContent=[arrList objectAtIndex:indexPath.row];
    
    float audioHeight=0;
    if([_shareContent.audio isKindOfClass:[NSNull class]] || [_shareContent.audio isEqualToString:@""])
    {
        
        audioHeight=0;
        
        // audioButton.frame=CGRectMake(60, 50, 30, 20);
    }
    else
    {
        audioHeight=20;
        
    }

    if(!_shareContent.isMore)
    {
        CGSize size=[_shareContent.shareContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(230, 1000) lineBreakMode:UILineBreakModeWordWrap];
        float height;
        if(size.height>15)
        {
            height=30;
            
        }
        else
        {
            height=15;
            
        }
        
        float heigh2=0;
        if(_shareContent.sharePic==nil||[_shareContent.sharePic isEqualToString:@""])
        {
            heigh2=0;
        }
        else
        {
            heigh2=150+10;
        }
        
        return heigh2+height+audioHeight+48+20+20;
        
    }
    else
    {
        CGSize size=[_shareContent.shareContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(230, 1000) lineBreakMode:UILineBreakModeWordWrap];
        float height=size.height;
        
        float heigh2=0;
        if(_shareContent.sharePic==nil||[_shareContent.sharePic isEqualToString:@""])
        {
            heigh2=0;
        }
        else
        {
            heigh2=150+10;
        }
        
        return heigh2+height+48+20+20;
        
    }
    return 0;
}

- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    if(aRefreshPos == EGORefreshHeader)
    {
        isLoading = YES;
        currentIndex=0;
        [self showHUD:YES];
        [self performSelectorInBackground:@selector(getDataInbackGround:) withObject:[NSNumber numberWithInt:0]];
    //    [self getData:0];
        
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            //连接服务器
            isLoading = YES;
             [self showHUD:YES];
            [self performSelectorInBackground:@selector(getDataInbackGround:) withObject:[NSNumber numberWithInt:1]];
           // [self getData:1];
        }
    }
}

//新浪微博 授权成功
- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error {
    [self hidTabBar:@"1"];
    if (error) {
        NSLog(@"failed to auth: %@", error);
    }
    else {
        NSLog(@"Success to auth: %@", auth.userId);
        [self shareController:1];
        [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    }
    
}
//腾讯授权成功
- (void)onSuccessLogin
{
    [self shareController:2];
    [self hidTabBar:@"1"];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    [self hidTabBar:@"1"];
}
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    NSLog(@"%d/r",__LINE__);
	[self reloadTableViewDataSource:aRefreshPos];
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
//返回刷新时间的回调方法

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
