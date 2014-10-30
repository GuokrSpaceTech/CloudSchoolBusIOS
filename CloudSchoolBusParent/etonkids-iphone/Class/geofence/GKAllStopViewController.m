//
//  GKAllStopViewController.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 14/10/24.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKAllStopViewController.h"
#import "ETKids.h"
#import "GKGeofence.h"
@interface GKAllStopViewController ()

@end

@implementation GKAllStopViewController
@synthesize _tableView,arrList;
@synthesize currentId;
@synthesize delegate;
-(void)dealloc
{
    self._tableView=nil;
    self.currentId=nil;
    self.arrList=nil;
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
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =@"选择围栏";//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
   // arrList=[[NSMutableArray alloc]init];
 
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除当前围栏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, 40);
    [btn addTarget:self action:@selector(changeGeofence:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0)+40, self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0)-40) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    topView=[[UIView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
//    topView.backgroundColor=[UIColor grayColor];
//    [self.view addSubview:topView];
//    [topView release];

}
-(void)showHUB
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
}
-(void)hiddenHUB
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
}
-(void)changeGeofence:(UIButton *)btn
{
    [self showHUB];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.currentId,@"geofenceid",@"2",@"state", nil];
    [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:dic requestMethod:POST forDelegate:self];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{

    [self hiddenHUB];
    if(method==geofenceparents)
    {
        if(code==1)
        {
            [delegate backRefresh];
            //当前站点
            if([[param allKeys] containsObject:@"geofenceid"])
            {
                if([[param objectForKey:@"state"] isEqualToString:@"1"])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"设置围栏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    
                    
                }
                else if([[param objectForKey:@"state"] isEqualToString:@"2"])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除围栏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    [self hiddenHUB];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
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
    return [arrList count];
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
    
    GKGeofence *geofence=[arrList objectAtIndex:indexPath.row];
    
    cell.textLabel.text=geofence.name;
    

    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showHUB];
    GKGeofence *geofence=[arrList objectAtIndex:indexPath.row];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:geofence.geofenceid,@"geofenceid",@"1",@"state", nil];
    [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:dic requestMethod:POST forDelegate:self];

    
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
