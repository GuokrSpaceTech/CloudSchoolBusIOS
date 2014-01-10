//
//  GKNoticeListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeListViewController.h"
#import "KKNavigationController.h"
#import "GKNoticeCell.h"
#import "GKNotice.h"
#import "GKMainViewController.h"
#import "GKNoticeInfoViewController.h"
@interface GKNoticeListViewController ()

@end

@implementation GKNoticeListViewController
@synthesize noticeList;
@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    noticeList=[[NSMutableArray alloc]init];
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    titlelabel.text=@"通知";
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"0",@"checkuserid",nil];

    
     [[EKRequest Instance]EKHTTPRequest:tnotice parameters:param requestMethod:GET forDelegate:self];
  
	// Do any additional setup after loading the view.
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
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    GKNotice *notice=[noticeList objectAtIndex:indexPath.row];
    cell.notice=notice;
    
    return cell;
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"sendfailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(code==1&&method==tnotice)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSLog(@"%@",arr);
        
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
        
        [_tableView reloadData];
    }
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
        int row=(ceil([_notice.plist count]/3.0));
        height+=(row*65) +(row-1)*10 +5;
    }
    
    height+=20;
    return height+10 + 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     GKNotice *_notice=[noticeList objectAtIndex:indexPath.row];
    
    GKNoticeInfoViewController *infoVC=[[GKNoticeInfoViewController alloc]init];
    infoVC.notice=_notice;
    [self.navigationController pushViewController:infoVC animated:YES];
    [infoVC release];
//    _notice.open=!_notice.open;
//    [_tableView reloadData];
}
-(void)dealloc
{
    self.noticeList=nil;
    self._tableView=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
