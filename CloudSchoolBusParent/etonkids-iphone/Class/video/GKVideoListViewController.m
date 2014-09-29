//
//  GKVideoListViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKVideoListViewController.h"
#import "GKSocket.h"
#import "ETKids.h"
#import "TBXML.h"
#import "GKDevice.h"

#import "GKVideoViewController.h"
@interface GKVideoListViewController ()

@end

@implementation GKVideoListViewController
@synthesize arrList;
@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)dealloc
{
    self.arrList=nil;
    self._tableView=nil;
    [super dealloc];
}
- (void)viewDidLoad
{
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
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text =  NSLocalizedString(@"doctor_con", @"医生咨询");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 70, 28)];
    [rightButton setCenter:CGPointMake(320 - 10 - 70/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:NSLocalizedString(@"doctor_tiwen", @"提问") forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"health_button.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"health_buttoned.png"] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:rightButton];
    
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = CELLCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    arrList=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}
-(void)rightButtonClick:(id)sender
{

    //GKDevice *obj=[arrList objectAtIndex:indexPath.row];
    
    
//    GKVideoViewController *videoVC=[[GKVideoViewController alloc]init];
//    //videoVC.device=obj;
//    [self.navigationController pushViewController:videoVC animated:YES];
//    [videoVC release];
//
//    
    GKSocket *socket=[GKSocket instance];
    //<TYPE>CheckUser</TYPE><User>%s</User><Pwd>%s</Pwd>","super","super
    NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
    //NSString *response =@"<TYPE>CheckUser</TYPE><User>super</User><Pwd>super</Pwd>";
   // NSString *response =@"<?xml version=\"1.0\" encoding=\"GB2312\" standalone=\"yes\"?> <TYPE>StartStream</TYPE>\
//    <DVRName>hb</DVRName>\
//    <ChnNo>0</ChnNo> <StreamType>1</StreamType>";
  
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    //[self sendData:[data bytes] length:[data length] type:9];
    [socket sendData:(char *)[data bytes] length:[data length] type:9  block:^(BOOL success, NSString *result) {
        if(success)
        {
            // 验证用户
            NSLog(@"%@",result);
            
            TBXML * tbxml = [TBXML newTBXMLWithXMLString:result error:nil];
            if (!tbxml.rootXMLElement)
            {
                return ;
                // [self traverseElement:tbxml.rootXMLElement];
            }
            
           if(1)
            {
                NSString *login=[TBXML textForElement:tbxml.rootXMLElement];
                if(1)
                {
                    
                    //验证成功
                    NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
                    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
                    [socket sendData:(char *)[data bytes] length:[data length] type:9 block:^(BOOL success, NSString *result) {
                        
                        NSLog(@"%@",result);
                        
                        TBXML * tbxml = [TBXML newTBXMLWithXMLString:result error:nil];
                        TBXMLElement *root = tbxml.rootXMLElement;
                        TBXMLElement *device = [TBXML childElementNamed:@"device" parentElement:root];
                        
                        while (device) {
                            GKDevice *deviceObj=[[GKDevice alloc]init];
                            TBXMLElement *svrid = [TBXML childElementNamed:@"svrid" parentElement:device];
                            if(svrid)
                            {
                                NSString *svridstr=[TBXML textForElement:svrid];
                                deviceObj.svrid=svridstr;
                                
                            }
                            TBXMLElement *svrname = [TBXML childElementNamed:@"svrname" parentElement:device];
                            if(svrname)
                            {
                                NSString *svrnameStr=[TBXML textForElement:svrname];
                                deviceObj.svrname=svrnameStr;
                                NSString *stateStr= [TBXML valueOfAttributeNamed:@"Status" forElement:svrname];
                                
                                deviceObj.status=stateStr;
                                NSLog(@"%@",stateStr);
                            }
                            TBXMLElement *svrchns = [TBXML childElementNamed:@"svrchns" parentElement:device];
                            if(svrchns)
                            {
                                NSString *svrchnsstr=[TBXML textForElement:svrchns];
                                NSLog(@"%@",svrchnsstr);
                                deviceObj.svrchns=svrchnsstr;
                            }
                            [arrList addObject:deviceObj];
                            [deviceObj release];
                            device = [TBXML nextSiblingNamed:@"device" searchFromElement:device];
                            
                        }
                        
                        [_tableView reloadData];
                        
                        //TBXMLElement *rootElement= tbxml.rootXMLElement;
                        
                        
                    } streamBlock:^(BOOL header, NSData *data, int length) {
                        
                    }];

                }
            }
            

            
        }
    } streamBlock:^(BOOL header, NSData *data, int length) {
        
    }];

}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrList count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        
    }
    GKDevice *obj=[arrList objectAtIndex:indexPath.row];
    cell.textLabel.text=obj.svrname;
       return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKDevice *obj=[arrList objectAtIndex:indexPath.row];
    
    
    GKVideoViewController *videoVC=[[GKVideoViewController alloc]init];
    videoVC.device=obj;
    [self.navigationController pushViewController:videoVC animated:YES];
    [videoVC release];
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
