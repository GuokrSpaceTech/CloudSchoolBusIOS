//
//  GKReportViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-29.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKReportViewController.h"
#import "GKMainViewController.h"
#import "GKReportHistoryViewController.h"
#import "GKReportModel.h"
#import "GKReportQuestion.h"
#import "KKNavigationController.h"
#import "GKWriteReportViewController.h"
@interface GKReportViewController ()

@end

@implementation GKReportViewController
@synthesize _tableView;
@synthesize arrList;
@synthesize _slimeView;
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
    self.arrList=nil;
        self._slimeView= nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(240, 8, 70, 30);
    //[button setTitle:NSLocalizedString(@"today", @"") forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"inclass.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"inclassed.png"] forState:UIControlStateHighlighted];
    //[photobutton setImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
    //[photobutton setImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:button];
    

    titlelabel.text=@"班级报告";
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
     _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    arrList=[[NSMutableArray alloc]init];
    
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

    [self loadData];
   

}

-(void)loadData
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
     [[EKRequest Instance] EKHTTPRequest:report parameters:nil requestMethod:GET forDelegate:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    
    [self loadData];
    
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
//    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    
    
//    NSLog(@"%@",aa);
         [_slimeView endRefresh];
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==report && code==1)
    {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        [arrList removeAllObjects];
        for (int i=0; i<[arr count]; i++) {
            
            GKReportModel *model=[[GKReportModel alloc]init];
            
            NSDictionary *dic=[arr objectAtIndex:i];
            model.name=[dic objectForKey:@"name"];
            model.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            NSArray *questionArr=[dic objectForKey:@"question"];
            for (int j=0; j<[questionArr count]; j++) {
                NSDictionary *qDic=[questionArr objectAtIndex:j];
                GKReportQuestion *quest=[[GKReportQuestion alloc]init];
                quest.type=[NSString stringWithFormat:@"%@",[qDic objectForKey:@"type"]];
                quest.title=[qDic objectForKey:@"title"];
                quest.op1=[qDic objectForKey:@"option1"];
                quest.op2=[qDic objectForKey:@"option2"];
                quest.op3=[qDic objectForKey:@"option3"];
                [model.questionArr addObject:quest];
                [quest release];
            }
            
            [arrList addObject:model];
            [model release];
        }
        
        [_tableView reloadData];
    }
    
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
         [_slimeView endRefresh];
    
    NSLog(@"超时");
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)rightClick:(id)sender
{
    GKReportHistoryViewController * reporthistoryVC=[[GKReportHistoryViewController alloc]init];
    
    [self.navigationController pushViewController:reporthistoryVC animated:YES];
    [reporthistoryVC release];
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
    return [arrList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        lineImageView.backgroundColor=[UIColor clearColor];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
  
        
    }
    
    GKReportModel *model=[arrList objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"发布%@",model.name];
        
    
    
    return cell;
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKReportModel *model=[arrList objectAtIndex:indexPath.row];
    
    
    GKWriteReportViewController *writeVC=[[GKWriteReportViewController alloc]init];
    writeVC.model=model;
    writeVC.titleStr=[NSString stringWithFormat:@"发布%@",model.name];
    [self.navigationController pushViewController:writeVC animated:YES];
    
    [writeVC release];
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
