//
//  GKContactViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKContactViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "GKTeacher.h"
#import "GKContactObj.h"
#import "GKLetterViewController.h"
@interface GKContactViewController ()

@end

@implementation GKContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    
    
    
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =@"联系人";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];

    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT - (ios7 ? 20 : 0)-40) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)leftButtonClick:(id)sender
{
    

    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UserLogin *user=[UserLogin currentLogin];
    return [user.teacherList count];
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
        line.image=[UIImage imageNamed:@"cellline.png"];
        [cell.contentView addSubview:line];
        [line release];
        
    }
    
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:100];
    UserLogin *user=[UserLogin currentLogin];
    GKTeacher *obj=[user.teacherList objectAtIndex:indexPath.row];
    
    nameLabel.text=obj.teachername;
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      UserLogin *user=[UserLogin currentLogin];
    GKTeacher *obj=[user.teacherList objectAtIndex:indexPath.row];
    
    GKContactObj *contact=[[GKContactObj alloc]init];
    contact.cnname=obj.teachername;
    contact.from_id=[NSString stringWithFormat:@"%@",obj.teacherid];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
