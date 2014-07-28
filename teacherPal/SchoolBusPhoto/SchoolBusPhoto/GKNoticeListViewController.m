//
//  GKNoticeListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeListViewController.h"
#import "KKNavigationController.h"
#import "GKShowBigImageViewController.h"
#import "GKNotice.h"
#import "GKMainViewController.h"
#import "GKNoticeInfoViewController.h"
#import "GKNoticeViewController.h"
#import "GKCommonClass.h"

@interface GKNoticeListViewController ()

@end

@implementation GKNoticeListViewController
@synthesize noticeList;
@synthesize _tableView;
@synthesize _slimeView;;
@synthesize _refreshFooterView;
@synthesize isLoading;
@synthesize isMore;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoDragScrollLoading) name:@"POPRELAOD" object:nil];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GKCommonClass createHelpWithTag:1002 image:[UIImage imageNamed:iphone5 ? @"thelp_notice_568.png" : @"thelp_notice.png"]];
   
    noticeList=[[NSMutableArray alloc]init];
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    UIButton *photobutton=[UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame=CGRectMake(280, 5, 35, 35);
    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"writeRizhi")) forState:UIControlStateNormal];
    [photobutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"writeRizhiH")) forState:UIControlStateHighlighted];
    [photobutton addTarget:self action:@selector(writeRizhi:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photobutton];

    
    
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

    titlelabel.text=NSLocalizedString(@"noticeQ", @"");
    

    
    UIView *noView=[[UIView alloc]initWithFrame:CGRectMake(320/2.0-303/4,self.view.frame.size.height/2.0-262/4-30, 303/2, 262/2+30) ];
    noView.tag=232;
    UIImageView *noImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 303/2, 262/2)];
    noImage.image=IMAGENAME(IMAGEWITHPATH(@"NOData"));
    [noView addSubview:noImage];
    [noImage release];
    
     [self.view addSubview:noView];
    [noView release];
  //  titlelabel.text=[group_ valueForProperty:ALAssetsGroupPropertyName];
    [self setNOView:YES];
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];

    [self loadNotice:param];
     //[[EKRequest Instance]EKHTTPRequest:tnotice parameters:param requestMethod:GET forDelegate:self];
  
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
     [[EKRequest Instance]EKHTTPRequest:tnotice parameters:pram requestMethod:GET forDelegate:self];
}
-(void)writeRizhi:(UIButton *)btn
{
    GKNoticeViewController *noticeVC=[[GKNoticeViewController alloc]init];
    
    [self.navigationController pushViewController:noticeVC animated:YES];
    [noticeVC release];
//    AVCamViewController *avVC=[[AVCamViewController alloc]initWithNibName:@"AVCamViewController" bundle:nil];
//    [self.navigationController pushViewController:avVC animated:YES];
//    [avVC release];
    
    
    //[self setAllPhotoSelect:YES];
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
-(void)clickImageViewLookImage:(NSString *)path
{
    GKShowBigImageViewController *show=[[GKShowBigImageViewController alloc]init];
    show.path=path;
    [self.navigationController presentViewController:show animated:YES completion:^{
        
    }];
    [show release];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noticeList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    GKNoticeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[GKNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate=self;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    GKNotice *notice=[noticeList objectAtIndex:indexPath.row];
    cell.notice=notice;
   
    if(indexPath.row==[self.noticeList count]-1)
    {
        if(isMore)
            [self setFooterView];
        else
            [self removeFooterView];
    }
    

    return cell;
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
    
    //NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",str);
    if(code==1&&method==tnotice)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",arr);
        if([[parm objectForKey:@"starttime"] isEqualToString:@"0"] && [[parm objectForKey:@"endtime"] isEqualToString:@"0"])
        {
            // 下拉刷新
            [noticeList removeAllObjects];
            if([arr count]<15)
            {
                isMore=NO;
            }
            else
                isMore=YES;
            for (int i=0; i<[arr count]; i++) {
                NSDictionary *dic=[arr objectAtIndex:i];
                GKNotice *notice=[[GKNotice alloc]init];
                
                notice.addtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                notice.adduserid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adduserid"]];
                notice.isconfirm=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isconfirm"]];
                notice.noticecontent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticecontent"]];
                notice.noticeid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticeid"]];
                notice.sisconfirm=[dic objectForKey:@"sisconfirm"];
                notice.noticetitle=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticetitle"]];
                notice.plist=[dic objectForKey:@"plist"];
                notice.slistname=[dic objectForKey:@"slistname"];
               // id temp=[dic objectForKey:@"teachername"];
                notice.teachername=[dic objectForKey:@"teachername"];
                [noticeList addObject:notice];
                [notice release];
                
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
                GKNotice *notice=[[GKNotice alloc]init];
                
                notice.addtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
                notice.adduserid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adduserid"]];
                notice.isconfirm=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isconfirm"]];
                notice.noticecontent=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticecontent"]];
                notice.noticeid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticeid"]];
                notice.sisconfirm=[dic objectForKey:@"sisconfirm"];
                notice.noticetitle=[NSString stringWithFormat:@"%@",[dic objectForKey:@"noticetitle"]];
                notice.plist=[dic objectForKey:@"plist"];
                notice.slistname=[dic objectForKey:@"slistname"];
                [noticeList addObject:notice];
                [notice release];
            }

     
        }
 
        //dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];

    }
    if([noticeList count]==0)
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    GKNotice *_notice=[noticeList objectAtIndex:indexPath.row];
    int height=0;
    CGSize size=[_notice.noticetitle sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    height+=size.height;
    
    
    //titleLable.backgroundColor=[UIColor redColor];
    
    height+=5;
    CGSize contentSize=[_notice.noticecontent sizeWithFont:FONTSIZE constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
    //height+=contentSize.height;
//
//    if(_notice.open==YES)
//    {
//        //如果是展开状态  显示全部内容
//      
//        
//       // NSLog(@"~~~~~~~~~~%@",_notice.noticecontent);
//        height+=contentSize.height;
//        
//    }
//    else
//    {
        //如果是闭合状态
        if(contentSize.height > [FONTSIZE lineHeight] *3)
        {
            //当内容大于3行时 显示三行
            height+=[FONTSIZE lineHeight] *3;
        }
        else
        {
            //当内容小于3行时 显示全部
            height+=contentSize.height;
        }
        
        
   // }
    height+=5;
   
 
    //回执
    
//    NSMutableString *selectobectStr =[NSMutableString stringWithString:@""];
//    NSLog(@"~~~~~~~~%@",_notice.slistname);
//    for (int i=0; i<[_notice.slistname count]; i++) {
//        [selectobectStr appendFormat:@"%@    " ,[_notice.slistname objectAtIndex:i]];
//    }
//    if(![selectobectStr isEqualToString:@""])
//    {
//        NSString *huizhiText=[NSString stringWithFormat:@"%@:%@",@"回执",selectobectStr];
//        
//        CGSize huizSize=[huizhiText sizeWithFont:FONTSIZE constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
//        height+=huizSize.height;
//        height+=5;
//        
//    }
//    else
//    {
//        height+=0;
//    }
    
    
//pic
    
    if([_notice.plist count]==1)
    {
        height+=(100+5);
    }
    else if([_notice.plist count]>1)
    {
        int row=(ceil(MIN([_notice.plist count],3)/3.0));
        height+=(row*65) +(row-1)*10 +5;
    }
    
    height+=20;
    return height+10 + 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GKNoticeCell *cell=(GKNoticeCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.contentlabel setCopyMenuVisible:NO];
    
     GKNotice *_notice=[noticeList objectAtIndex:indexPath.row];
    
    GKNoticeInfoViewController *infoVC=[[GKNoticeInfoViewController alloc]init];
    infoVC.notice=_notice;
    [self.navigationController pushViewController:infoVC animated:YES];
    [infoVC release];
//    _notice.open=!_notice.open;
//    [_tableView reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    if (self._slimeView) {
//        [self._slimeView scrollViewDidScroll];
//    }
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (self._slimeView) {
//        [self._slimeView scrollViewDidEndDraging];
//    }
//    
//    
//}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    //    [self showHUD:YES];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];
    
    [self loadNotice:param];
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

    GKNotice *sc = [self.noticeList lastObject];
    NSString *lastTime = sc.addtime;

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


-(void)dealloc
{
    self.noticeList=nil;
    self._tableView=nil;
    self._slimeView=nil;
    self._refreshFooterView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
