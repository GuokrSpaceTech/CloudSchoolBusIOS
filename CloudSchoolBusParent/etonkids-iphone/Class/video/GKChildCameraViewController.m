//
//  GKChildCameraViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKChildCameraViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "GKDvrObj.h"
#import "UserLogin.h"

#import "GKVideoViewController.h"
#import "TBXML.h"
#import "AppDelegate.h"
@interface GKChildCameraViewController ()

@end

@implementation GKChildCameraViewController

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
    //    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    //    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:popGes];
    //    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =@"摄像头列表";//  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    
    _arrList=[[NSMutableArray alloc]init];
   
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT-(ios7 ? 20 : 0)) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UILabel *noLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2.0-15,self.view.frame.size.width, 30)];
    noLabel.font=[UIFont systemFontOfSize:25];
    noLabel.textAlignment=NSTextAlignmentCenter;
    noLabel.textColor=[UIColor blackColor];
    noLabel.text =@"暂无摄像头";//  NSLocalizedString(@"doctor_con", @"医生咨询");
    noLabel.backgroundColor=[UIColor clearColor];
    noLabel.tag=1000;
    noLabel.hidden=YES;
    [self.view addSubview:noLabel];
    [noLabel release];
    
    
    [self loadData];
}
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    [[EKRequest Instance]EKHTTPRequest:camera parameters:nil requestMethod:GET forDelegate:self];
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(code==1 && method==camera)
    {
        UserLogin *user=[UserLogin currentLogin];
        user.ddns=@"";
        user.port=@"";
        [_arrList removeAllObjects];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        NSLog(@"%@",dic);
        
        NSString * ddns=[dic objectForKey:@"ddns"];
        NSString *port=[dic objectForKey:@"port"];
        user.ddns=ddns;
        user.port=port;
        NSArray *arr=[dic objectForKey:@"dvr"];
        
        if([arr count]==0)
        {
            UILabel *nolabel=(UILabel *)[self.view viewWithTag:1000];
            nolabel.hidden=NO;
            
        }
        else
        {
            UILabel *nolabel=(UILabel *)[self.view viewWithTag:1000];
            nolabel.hidden=YES;
            
            for(NSInteger i=0;i<[arr count];i++)
            {
                NSDictionary *drvDic=[arr objectAtIndex:i];
                
                GKDvrObj *obj=[[GKDvrObj alloc]init];
                obj.channeldesc=[drvDic objectForKey:@"channeldesc"];
                obj.channelid=[drvDic objectForKey:@"channelid"];
                obj.dvr_name=[drvDic objectForKey:@"dvr_name"];
                obj.dvrid=[drvDic objectForKey:@"dvrid"];
                [_arrList addObject:obj];
                [obj release];
                
            }
            [_tableView reloadData];
        }
        
        
    }
}

-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrList count];
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
        
        
        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
        iamgeView.image=[UIImage imageNamed:@"cellline.png"];
        [cell.contentView addSubview:iamgeView];
        [iamgeView release];
        
    }
    
    GKDvrObj * obj=[_arrList objectAtIndex:indexPath.row];
    cell.textLabel.text=obj.channeldesc;

    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    UserLogin *user=[UserLogin currentLogin];
    GKDvrObj * obj=[_arrList objectAtIndex:indexPath.row];
//    
    GKSocket *socket=[[GKSocket alloc]init];
     //222.128.71.186
    [socket connectwithddns:user.ddns port:user.port isConnect:YES  block:^(BOOL success, NSString *result) {
        if(success)
        {
            NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
            
            
            NSData *data = [[[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]] autorelease];

            
            [socket sendData:(char *)[data bytes] length:(int)[data length] type:9 isConnect:NO block:^(BOOL success, NSString *result) {
                if(success)
                {
                    // 验证用户
              
                    BOOL found=NO;
                    
                    NSInteger code=0;
                    NSInteger channel=0;
                    
                    TBXML * tbxml = [TBXML newTBXMLWithXMLString:result error:nil];
                    TBXMLElement *root = tbxml.rootXMLElement;
                    TBXMLElement *device = [TBXML childElementNamed:@"device" parentElement:root];
                    
                    while (device) {
                        TBXMLElement *svrname = [TBXML childElementNamed:@"svrname" parentElement:device];
                        TBXMLElement *chnsname=[TBXML childElementNamed:@"svrchns" parentElement:device];
                        if(chnsname)
                        {
                             channel=[[TBXML textForElement:chnsname] integerValue];
                        }
                        if(svrname)
                        {
                            NSString *svrnameStr=[TBXML textForElement:svrname];
                            
                            NSString *stateStr= [TBXML valueOfAttributeNamed:@"Status" forElement:svrname];
                            
                            //  deviceObj.status=stateStr;
                            
                            if([obj.dvr_name isEqualToString:svrnameStr])
                            {
                                //if(stateStr)
                                if([stateStr isEqualToString:@"1"])
                                {
                                    found=YES;
                                    break;
                                }
                                else
                                {
                                    code=-1;//不在线
                                }
                            }
                            else
                            {
                                code=2;// 无设备
                            }
                            
                            
                            
                            NSLog(@"%@",stateStr);
                        }
                        device = [TBXML nextSiblingNamed:@"device" searchFromElement:device];
                        
                    }
                    
                    
                    if(channel==0 || [obj.channelid integerValue]>=channel)
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"学校摄像头没配置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        return ;
                    }
                    if(found==YES)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            GKVideoViewController *VC=[[GKVideoViewController alloc]init];
                            AppDelegate *appDel=SHARED_APP_DELEGATE;
                            VC.socket=socket;
                            VC.dvrObj=obj;
                            [appDel.bottomNav pushViewController:VC animated:YES];
                            [VC release];
                        });
               
                    }
                    else
                    {

                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"学校摄像头没配置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            [alert release];
                        });
                    }
                    
                    
                }
            } streamBlock:^(NSData *data, int length, NSError *error) {
                
            }];
        }
        else
        {
            NSLog(@"sbb");
        }
    }];

    
    
}

-(void)dealloc
{
    self.arrList=nil;
    self.tableView=nil;
  
    [super dealloc];
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
