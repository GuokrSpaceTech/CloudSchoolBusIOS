#import "ETChildViewController.h"
#import "UserLogin.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "GTMBase64.h"

#import "ETChildManagerViewController.h"
#import "ETCoreDataManager.h"
#import "UIImageView+WebCache.h"
#import "ETGrowViewController.h"
#import "ETGCalendarViewController.h"
#import "GKHealthListViewController.h"
#import "GKReportViewController.h"

#import "GKBuyViewController.h"
#import "GKGeofenceViewController.h"

#import "GKSocket.h"
#import "ETKids.h"
#import "TBXML.h"
#import "GKDevice.h"
#import "ETCommonClass.h"
#import "GKVideoViewController.h"

#import "UserLogin.h"

#define VIEWHEIGHT 110
#define VIEWHEIGHT5 128


@interface ETChildViewController ()

@end

@implementation ETChildViewController
//@synthesize titleArr,tImageArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChildInfo:) name:@"CHILDINFO" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge:) name:@"RELOADBADGE" object:nil];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHILDINFO" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RELOADBADGE" object:nil];


    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) - 46 - 57) style:UITableViewStyleGrouped];
    mainTV.backgroundView = nil;
    mainTV.backgroundColor = CELLCOLOR;
    mainTV.delegate = self;
    mainTV.dataSource = self;
    [self.view addSubview:mainTV];
    [mainTV release];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }
    return 40;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"normal";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if(cell==nil)
//    {
//        
        UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    UserLogin * user = [UserLogin currentLogin];
    
    if (indexPath.section == 0)
    {
        //            //头像
        UIImageView * headImage=[[UIImageView alloc]initWithFrame:CGRectMake(20,15, 65, 65)];
        headImage.backgroundColor=[UIColor clearColor];
        headImage.tag=100;
//        headImage.layer.borderWidth=2;
//        headImage.layer.borderColor=[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1].CGColor;
        
        
        if(user.avatar != nil)
            [headImage setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] options:SDWebImageRefreshCached|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    headImage.image = image;
            }];
    
        [cell.contentView addSubview:headImage];
        [headImage release];
        
        UILabel *nicknamelabel=[[UILabel alloc]initWithFrame:CGRectMake(100,25,170,20)];
        nicknamelabel.tag = 101;
//        nicknamelabel.textAlignment=UITextAlignmentRight;
        [cell.contentView addSubview:nicknamelabel];
        nicknamelabel.backgroundColor=[UIColor clearColor];
        nicknamelabel.font=[UIFont systemFontOfSize:18];
        nicknamelabel.text=user.nickname;
        [nicknamelabel release];
        
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:user.orderEndTime.integerValue];
        NSDateFormatter *f = [[[NSDateFormatter alloc] init] autorelease];
        [f setDateFormat:@"yyyy-MM-dd"];
        
        UILabel *orderlabel = [[UILabel alloc]initWithFrame:CGRectMake(100,55,170,20)];
//        typelabel.tag = 102;
//        typelabel.textAlignment=UITextAlignmentRight;
        [cell.contentView addSubview:orderlabel];
        orderlabel.backgroundColor = [UIColor clearColor];
        orderlabel.font = [UIFont systemFontOfSize:16];
        orderlabel.text = [NSString stringWithFormat:@"%@%@",[f stringFromDate:d],LOCAL(@"daoqi", @"到期")];;
        [orderlabel release];
        
        
        
    }
    else if (indexPath.section == 1)
    {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"孩子管理.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = LOCAL(@"childmanager", @"");
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        [label release];
 
        
    }
    else if (indexPath.section == 2)
    {
        
        //section 2

        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"-vip.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = LOCAL(@"checkAndCalendar", @"");
        label.font = [UIFont systemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        
//        cell.textLabel.backgroundColor=[UIColor clearColor];
//        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    
    else if (indexPath.section == 3)
    {
        
         imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_badge.png"]];
        imageView.frame=CGRectMake(150, 3, 19, 19);
        imageView.hidden=YES;
        imageView.tag=1000;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        
        numlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
        numlabel.backgroundColor=[UIColor clearColor];
        //            label.text=@"11";
        numlabel.tag = 2000 ;
        numlabel.textColor=[UIColor whiteColor];
        numlabel.font=[UIFont systemFontOfSize:12];
        numlabel.textAlignment=UITextAlignmentCenter;
        [imageView addSubview:numlabel];
        [numlabel release];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"report_icon.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        //"doctor_con"="医生咨询";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = NSLocalizedString(@"classribao", @"");
        
        label.font = [UIFont systemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        
        //        cell.textLabel.backgroundColor=[UIColor clearColor];
        //        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    else if (indexPath.section == 4)
    {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"mychild_doctor.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        //"doctor_con"="医生咨询";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = NSLocalizedString(@"doctor_con", @"医生咨询");
        label.font = [UIFont systemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        
        //        cell.textLabel.backgroundColor=[UIColor clearColor];
        //        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    
    
    else if (indexPath.section == 5)
    {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"mychild_video.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        //"doctor_con"="医生咨询";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = @"视频公开课";
        label.font = [UIFont systemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        
        //        cell.textLabel.backgroundColor=[UIColor clearColor];
        //        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    else if (indexPath.section == 6)
    {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"mychild_geofence.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        //"doctor_con"="医生咨询";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = @"校车到站通知";
        label.font = [UIFont systemFontOfSize:16];
        //label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        
        //        cell.textLabel.backgroundColor=[UIColor clearColor];
        //        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        ETBaseMessageViewController *bmVC = [[ETBaseMessageViewController alloc] init];
        bmVC.delegate = self;
        AppDelegate *appDel = SHARED_APP_DELEGATE;
        [appDel.bottomNav pushViewController:bmVC animated:YES];
        [bmVC release];
    }
    else if (indexPath.section == 1)
    {
        
        ETChildManagerViewController *cmVC = [[ETChildManagerViewController alloc] init];
        AppDelegate *appDel = SHARED_APP_DELEGATE;
        [appDel.bottomNav pushViewController:cmVC animated:YES];
        [cmVC release];
        
    }
    else if (indexPath.section == 2)
    {
        ETGCalendarViewController *VC=[[ETGCalendarViewController alloc]init];
        AppDelegate *appDel=SHARED_APP_DELEGATE;
        [appDel.bottomNav pushViewController:VC animated:YES];
        [VC release];
        
        
//        ETCalendarViewController *cal = [[ETCalendarViewController alloc] initWithNibName:nil bundle:nil];
//        AppDelegate *appDel = SHARED_APP_DELEGATE;
//        [appDel.bottomNav pushViewController:cal animated:YES];
//        [cal release];

        return;
        
    }
    else if (indexPath.section == 3)
    {
        imageView.hidden=YES;
        GKReportViewController *VC=[[GKReportViewController alloc]init];
        AppDelegate *appDel=SHARED_APP_DELEGATE;
        [appDel.bottomNav pushViewController:VC animated:YES];
        [VC release];
        
        
        //        ETCalendarViewController *cal = [[ETCalendarViewController alloc] initWithNibName:nil bundle:nil];
        //        AppDelegate *appDel = SHARED_APP_DELEGATE;
        //        [appDel.bottomNav pushViewController:cal animated:YES];
        //        [cal release];
        
        return;
        
    }
    else if (indexPath.section == 4)
    {
    

        
        UserLogin *user=[UserLogin currentLogin];
        if([user.chunyuisopen intValue]==0)
        {

            GKBuyViewController *VC=[[GKBuyViewController alloc]init];
            AppDelegate *appDel=SHARED_APP_DELEGATE;
            [appDel.bottomNav pushViewController:VC animated:YES];
            [VC release];
        }
        else
        {
            GKHealthListViewController *VC=[[GKHealthListViewController alloc]init];
            AppDelegate *appDel=SHARED_APP_DELEGATE;
            [appDel.bottomNav pushViewController:VC animated:YES];
            [VC release];

        }
        
 
        
        return;
        
    }
    
    else if (indexPath.section == 5)
    {
        
        [self isCameraReady];
        
        
//        GKVideoListViewController *VC=[[GKVideoListViewController alloc]init];
//        AppDelegate *appDel=SHARED_APP_DELEGATE;
//        [appDel.bottomNav pushViewController:VC animated:YES];
//        [VC release];

        return;
        
    }
    
    else if (indexPath.section == 6)
    {
        GKGeofenceViewController *VC=[[GKGeofenceViewController alloc]init];
        AppDelegate *appDel=SHARED_APP_DELEGATE;
        [appDel.bottomNav pushViewController:VC animated:YES];
        [VC release];
        
        return;
        
    }
}
-(void)isCameraReady
{
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode=MBProgressHUDModeText;
        HUD.labelText=@"正在获取设备信息，请稍后...";
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        if(err)
        {
            if(HUD)
            {
                [HUD removeFromSuperview];
                HUD=nil;
            }
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络故障" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return ;
        }
        if(err==nil)
        {
            UserLogin *user=[UserLogin currentLogin];
            if([user.ddns isEqualToString:@""] || [user.camera_name isEqualToString:@""])
            {
                if(HUD)
                {
                    [HUD removeFromSuperview];
                    HUD=nil;
                }
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"学校未装摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return ;
            }
            
            NSString *ddns=user.ddns;
            NSString *prot=user.port;
            
            GKSocket *socket=[GKSocket instanceddns:ddns port:prot];
            
            NSString *response  =@"<TYPE>GetDeviceList</TYPE>";
            
            
            NSData *data = [[[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]] autorelease];
            //[self sendData:[data bytes] length:[data length] type:9];
            [socket sendData:(char *)[data bytes] length:[data length] type:9  block:^(BOOL success, NSString *result) {
               
                if(!success)
                {
                    if(HUD)
                    {
                        [HUD removeFromSuperview];
                        HUD=nil;
                    }
                }
                if(success)
                {
                    // 验证用户
                    if(HUD)
                    {
                        [HUD removeFromSuperview];
                        HUD=nil;
                    }
                    BOOL found=NO;
                    
                    
                    TBXML * tbxml = [TBXML newTBXMLWithXMLString:result error:nil];
                    TBXMLElement *root = tbxml.rootXMLElement;
                    TBXMLElement *device = [TBXML childElementNamed:@"device" parentElement:root];
                    
                    while (device) {
                        TBXMLElement *svrname = [TBXML childElementNamed:@"svrname" parentElement:device];
                        if(svrname)
                        {
                            NSString *svrnameStr=[TBXML textForElement:svrname];

                            NSString *stateStr= [TBXML valueOfAttributeNamed:@"Status" forElement:svrname];
                            
                          //  deviceObj.status=stateStr;
                            
                            if([user.camera_name isEqualToString:svrnameStr])
                            {
                                //if(stateStr)
                                if([stateStr isEqualToString:@"1"])
                                {
                                    found=YES;
                                    break;
                                }
                            }
                            
                            
                            
                            NSLog(@"%@",stateStr);
                        }
                        device = [TBXML nextSiblingNamed:@"device" searchFromElement:device];
                        
                    }
                    
                    
                    
                  if(found==YES)
                  {
                        GKVideoViewController *VC=[[GKVideoViewController alloc]init];
                        AppDelegate *appDel=SHARED_APP_DELEGATE;
                        [appDel.bottomNav pushViewController:VC animated:YES];
                        [VC release];
                  }
                 

                }
            } streamBlock:^(NSData *data, int length,NSError *error) {
                
            }];
            
        }
    }];
    

}
-(void)updateChildInfo:(NSNotification *) notification
{
    [mainTV reloadData];
}

- (void)reloadChildMessage
{
    [mainTV reloadData];
}
- (void)reloadBadge:(NSNotification *)info
{
    [[EKRequest Instance] EKHTTPRequest:status parameters:nil requestMethod:GET forDelegate:self];
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{

    if (method == status && code == 1) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        NSLog(@"new message number : %@",result);
        
        NSString *iconnum=[NSString stringWithFormat:@"%@",[result objectForKey:@"report"]];
        
     
        if([iconnum integerValue]==0)
        {
            imageView.hidden=YES;
        }
        else
        {
            numlabel.text=iconnum;
            imageView.hidden=NO;
        }
        //[_tabBar setBadgeNumber:result];
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
