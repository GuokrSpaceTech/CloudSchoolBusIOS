//
//  GKGeofenceViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-10-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKGeofenceViewController.h"
#import "ETKids.h"
#import "GKGeofence.h"
#import "GKRoute.h"
#import "GKAllStopViewController.h"

@interface GKGeofenceViewController ()

@end

@implementation GKGeofenceViewController
@synthesize _tableView;
@synthesize arrList;
@synthesize currentStopid;
@synthesize arrTempList;
-(void)dealloc
{
    self._tableView=nil;
    self.arrList=nil;
    self.currentStopid=nil;

    self.arrTempList=nil;
    [super dealloc];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    //middleLabel.text =NSLocalizedString(@"classribao", @"");//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    middleLabel.userInteractionEnabled=YES;
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMindle:)];
    tap.numberOfTapsRequired=1;
    [middleLabel addGestureRecognizer:tap];
    [tap release];
    
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 50/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
   // [rightButton setTitle:@"dd" forState:UIControlStateNormal];geofence_changestop_white.png
    [rightButton setBackgroundImage:[UIImage imageNamed:@"geofence_changestop_white.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"geofence_changestop.png"] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:rightButton];
    
    arrList=[[NSMutableArray alloc]init];
    arrTempList=[[NSMutableArray alloc]init];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0)) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];


    [self showHUB];
    [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:nil requestMethod:GET forDelegate:self];
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSLog(@"fdfd");
         NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.currentStopid,@"geofenceid",@"2",@"state", nil];
        [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:dic requestMethod:POST forDelegate:self];
        
    }
}
-(void)clickMindle:(UIGestureRecognizer *)ta
{
    if(self.currentStopid)
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)backRefresh
{
    [self showHUB];
    [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:nil requestMethod:GET forDelegate:self];
}
-(void)change:(UIButton *)btn
{
    GKRouteViewController *VC=[[GKRouteViewController alloc]init];
    VC.list=self.arrTempList;
    VC.delegate=self;
//    VC.arrList=arrTempList;
//    VC.currentId=self.currentStopid;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}

-(void)refreshVC
{
    [self showHUB];
    [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:nil requestMethod:GET forDelegate:self];
}
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    if(method==geofenceparents)
    {
        if(code==1)
        {
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
                    [self hiddenHUB];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除围栏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                 [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:nil requestMethod:GET forDelegate:self];
            }
            else
            {
                [self hiddenHUB];

                rightButton.hidden=NO;
                _tableView.frame=CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0));

                                         
                [arrList removeAllObjects]; //存放通知
                [arrTempList removeAllObjects];
                
                NSArray *allArr=[dic objectForKey:@"allstop"];
                
                for (int i=0; i<[allArr count]; i++) {
                    NSDictionary *routedic=[allArr objectAtIndex:i];
                    GKRoute *route=[[GKRoute alloc]init];
                    route.routename=[routedic objectForKey:@"linename"];
                    
                    NSArray *stationArr=[routedic objectForKey:@"stop"];
                    
                    for (int j=0; j<stationArr.count; j++) {
                        GKGeofence *geofence=[[GKGeofence alloc]init];
                        geofence.geofenceid=[NSString stringWithFormat:@"%@",[[stationArr objectAtIndex:j] objectForKey:@"geofenceid"]];
                        geofence.name=[[stationArr objectAtIndex:j] objectForKey:@"name"];
                        
                        [route.stationList addObject:geofence];
                        [geofence release];
                        
                    }
                    
                    [arrTempList addObject:route];
                    [route release];
                    
                }
                NSArray *noticeArr=[dic objectForKey:@"notice"];
                for (int i=0; i<[noticeArr count]; i++) {
                    NSString * stoptime=[[noticeArr objectAtIndex:i] objectForKey:@"time"];
                    [arrList addObject:stoptime];
                    
                    
                }
                self.currentStopid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"currentstopid"]];

                middleLabel.text=[NSString stringWithFormat:@"%@到站通知",[dic objectForKey:@"currentstop"]];

                [self._tableView reloadData];

    
                
            }
            
            
            
        }
        else if(code==2)
        {
            // 没有设置站点
            [self hiddenHUB];

            middleLabel.text=@"选择线路";
            [arrList removeAllObjects];
            [arrTempList removeAllObjects];
            
//            topView.frame=CGRectZero;
            rightButton.hidden=YES;
            _tableView.frame=CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0));
            self.currentStopid=@"";
//            currentStopLabel.text=@"";

            NSArray *allArr=[dic objectForKey:@"allstop"];
            
            for (int i=0; i<[allArr count]; i++) {
                NSDictionary *routedic=[allArr objectAtIndex:i];
                GKRoute *route=[[GKRoute alloc]init];
                route.routename=[routedic objectForKey:@"linename"];
                
                NSArray *stationArr=[routedic objectForKey:@"stop"];
                
                for (int j=0; j<stationArr.count; j++) {
                    GKGeofence *geofence=[[GKGeofence alloc]init];
                    geofence.geofenceid=[NSString stringWithFormat:@"%@",[[stationArr objectAtIndex:j] objectForKey:@"geofenceid"]];
                    geofence.name=[[stationArr objectAtIndex:j] objectForKey:@"name"];

                    [route.stationList addObject:geofence];
                    [geofence release];
                }
                
                [arrList addObject:route];
                [route release];
                
            }
//            
//            for (int i=0; i<[allArr count]; i++) {
//                GKGeofence *geofence=[[GKGeofence alloc]init];
//                geofence.geofenceid=[NSString stringWithFormat:@"%@",[[allArr objectAtIndex:i] objectForKey:@"geofenceid"]];
//                geofence.name=[[allArr objectAtIndex:i] objectForKey:@"name"];
//                [arrList addObject:geofence];
//                [geofence release];
//                
//            }
            [_tableView reloadData];
            
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
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280,20)];
        label.backgroundColor=[UIColor clearColor];
        label.tag=100;
        [cell.contentView addSubview:label];
        [label release];
        
    }
    
    id obj=[arrList objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKRoute class]])
    {
        GKRoute *geofence=obj;
        cell.textLabel.text=geofence.routename;
    }
    else
    {
        NSString *time=obj;
        cell.textLabel.text=[NSString stringWithFormat:@"班车在%@进入设定范围",time];
    }
    
       return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj=[arrList objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[GKRoute class]])
    {
        [self showHUB];
        GKRoute *geofence=obj;
        GKAllStopViewController *gkAllVC=[[GKAllStopViewController alloc]init];
        gkAllVC.route=geofence;

        gkAllVC.delegate=self;
        gkAllVC.currentId=@"";
        [self.navigationController pushViewController:gkAllVC animated:YES];
        [gkAllVC release];
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:geofence.geofenceid,@"geofenceid",@"1",@"state", nil];
//        [[EKRequest Instance]EKHTTPRequest:geofenceparents parameters:dic requestMethod:POST forDelegate:self];
        
        // 关注 选择 站点
        
    }

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
