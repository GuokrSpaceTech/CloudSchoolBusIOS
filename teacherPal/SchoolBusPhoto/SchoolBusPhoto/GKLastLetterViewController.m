//
//  GKLastLetterViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-18.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKLastLetterViewController.h"
#import "GKMainViewController.h"
#import "KKNavigationController.h"
#import "GKContactObj.h"

//#import "GKUserLogin.m"
#import "GKContactViewController.h"
@interface GKLastLetterViewController ()

@end

@implementation GKLastLetterViewController
@synthesize dataArr,_tableView;
@synthesize _slimeView;

-(void)dealloc
{
    self._slimeView=nil;
    self.dataArr=nil;
    self._tableView=nil;
    [super dealloc];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
    
    [self refreshController];
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    
    UIButton *buttonRight=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame=CGRectMake(240, 8, 70, 30);
    NSString * addstr=@"联系人";
    [buttonRight setTitle:addstr forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"inclass.png"] forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"inclassed.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonRight];
    buttonRight.titleLabel.font=[UIFont systemFontOfSize:15];
    [buttonRight addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];

    
    dataArr=[[NSMutableArray alloc]init];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.origin.y+navigationView.frame.size.height, 320, self.view.frame.size.height)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
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
    
    titlelabel.text=@"最近联系人";
    
    //[[EKRequest Instance]EKHTTPRequest:lastestletter parameters:nil requestMethod:GET forDelegate:self];

    

}
-(void)refreshController
{
     [[EKRequest Instance]EKHTTPRequest:lastestletter parameters:nil requestMethod:GET forDelegate:self];
}
-(void)contact:(UIButton *)btn
{
//    GKUserLogin *user=[GKUserLogin currentLogin];
    GKContactViewController *contactVC=[[GKContactViewController alloc]init];
//    contactVC.dataArr=user.studentArr;
    [self.navigationController pushViewController:contactVC animated:YES];
    [contactVC release];
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
        [_slimeView endRefresh];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    [_slimeView endRefresh];
    if(code==1&& method==lastestletter)
    {
        
       
        [dataArr removeAllObjects];
        
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:NULL];
        
        for (int i=0; i<[arr count]; i++) {
            
            GKContactObj *obj=[[GKContactObj alloc]init];
            NSDictionary *dic=[arr objectAtIndex:i];
            obj.cnname=[dic objectForKey:@"cnname"];
            
            NSDictionary *contecntdic=[dic objectForKey:@"content"];
            if(contecntdic)
            {
                obj.type=[[dic objectForKey:@"content"] objectForKey:@"type"];
                
                obj.content=[[dic objectForKey:@"content"] objectForKey:@"content"];
            }
            else
            {
                obj.type=@"txt";
                
                obj.content=@"1";
            }
         
            obj.from_id=[dic objectForKey:@"from_id"];
            obj.state=[dic objectForKey:@"state"];
            [dataArr addObject:obj];
            [obj release];
        
        }
        
        [_tableView reloadData];
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor=[UIColor clearColor];
        
        UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag=100;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 270, 20)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.tag=101;
        contentLabel.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:contentLabel];
        [contentLabel release];
        
        
        UIImageView *pointImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-10-10, 20, 8, 8)];
        //pointImageView.image=IMAGENAME(IMAGEWITHPATH(@"yellowPoint"));;
        pointImageView.tag=102;
        [cell.contentView addSubview:pointImageView];
        [pointImageView release];
    
        

        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
        line.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [cell.contentView addSubview:line];
        [line release];
        
    }
    

    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLabel=(UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *pointImageView=(UIImageView *)[cell.contentView viewWithTag:102];
    GKContactObj *obj=[dataArr objectAtIndex:indexPath.row];
    
    nameLabel.text=obj.cnname;
    
    
    if([obj.type isEqualToString:@"txt"])
    {
        contentLabel.text=obj.content;
    }
    else
    {
        contentLabel.text=@"图片";
    }
    
    if([obj.state isEqualToString:@"1"])
    {
        pointImageView.image=[UIImage imageNamed:@"yellowPoint.png"];
    }
    else
    {
        pointImageView.image=nil;
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GKContactObj *obj=[dataArr objectAtIndex:indexPath.row];
    GKLetterViewController *letterViewController=[[GKLetterViewController alloc]init];
    letterViewController.contactObj=obj;

    [self.navigationController pushViewController:letterViewController animated:YES];
    [letterViewController release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView
{
      [[EKRequest Instance]EKHTTPRequest:lastestletter parameters:nil requestMethod:GET forDelegate:self];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
