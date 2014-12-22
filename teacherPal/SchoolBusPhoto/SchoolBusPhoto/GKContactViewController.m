//
//  GKContactViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-19.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKContactViewController.h"
#import "GKUserLogin.h"
#import "Student.h"
#import "GKContactObj.h"
#import "KKNavigationController.h"

@interface GKContactViewController ()

@end

@implementation GKContactViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_tableView reloadData];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
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
    _dataArr=[[NSMutableArray alloc]init];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    titlelabel.text=@"联系人";
}
-(void)leftClick:(UIButton *)bt
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    return [user.studentArr count];
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
        
        UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag=100;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
        line.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [cell.contentView addSubview:line];
        [line release];
        
    }
    
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:100];
    GKUserLogin *user=[GKUserLogin currentLogin];
    Student *obj=[user.studentArr objectAtIndex:indexPath.row];
    
    nameLabel.text=obj.cnname;
    

    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKUserLogin *user=[GKUserLogin currentLogin];
    Student *obj=[user.studentArr objectAtIndex:indexPath.row];
    
    GKContactObj *contact=[[GKContactObj alloc]init];
    contact.cnname=obj.cnname;
    contact.from_id=[NSString stringWithFormat:@"%@",obj.studentid];
    
    GKLetterViewController *letterVC=[[GKLetterViewController alloc]init];
    letterVC.contactObj=contact;
   
    [contact release];
    [self.navigationController pushViewController:letterVC animated:YES];
    [letterVC release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.dataArr=nil;
    self.tableView=nil;
    [super dealloc];
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
