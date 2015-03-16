//
//  GKRouteViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 15-3-16.
//  Copyright (c) 2015年 wpf. All rights reserved.
//

#import "GKRouteViewController.h"
#import "ETKids.h"
#import "GKRoute.h"

@interface GKRouteViewController ()

@end

@implementation GKRouteViewController
@synthesize _tableView;
-(void)dealloc
{
    self._tableView=nil;
    [super dealloc];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =@"选择路线";//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0)-40) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280,20)];
        //        label.backgroundColor=[UIColor clearColor];
        //        label.tag=100;
        //        [cell.contentView addSubview:label];
        //        [label release];
        
    }
    
    GKRoute *geofence=[self.list objectAtIndex:indexPath.row];
    
    cell.textLabel.text=geofence.routename;
    
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj=[self.list objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKRoute class]])
    {
 
        GKRoute *geofence=obj;
        GKAllStopViewController *gkAllVC=[[GKAllStopViewController alloc]init];
        gkAllVC.route=geofence;
        
        gkAllVC.delegate=self;
      //  gkAllVC.currentId=@"";
        [self.navigationController pushViewController:gkAllVC animated:YES];
        [gkAllVC release];
        //        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:geofence.geofenceid,@"geofenceid",@"1",@"state", nil];
        //        [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:dic requestMethod:POST forDelegate:self];
        
        // 关注 选择 站点
        
    }
    
}
-(void)backRefresh
{
    [_delegate refreshVC];
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
