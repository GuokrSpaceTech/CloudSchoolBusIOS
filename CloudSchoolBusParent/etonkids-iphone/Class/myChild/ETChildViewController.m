#import "ETChildViewController.h"
#import "UserLogin.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "GTMBase64.h"
#import "ETCommonClass.h"
#import "ETChildManagerViewController.h"
#import "ETCoreDataManager.h"
#import "UIImageView+WebCache.h"
#import "ETGrowViewController.h"
#import "ETGCalendarViewController.h"
#import "GKHealthListViewController.h"
#import "GKReportViewController.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
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
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHILDINFO" object:nil];


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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
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
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:@"mychild_doctor.png"];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        //"doctor_con"="医生咨询";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = @"学生日报";
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
    
        
       // if(0)
       // {
            // 该用户没有开通春雨  需要购买
            
//            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
            
            
            ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
            [com requestLoginWithComplete:^(NSError *err){
               // NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month", nil];
                [[EKRequest Instance] EKHTTPRequest:order parameters:nil requestMethod:GET forDelegate:self];
            }];

            
      //  }
        
        
//        GKHealthListViewController *VC=[[GKHealthListViewController alloc]init];
//        AppDelegate *appDel=SHARED_APP_DELEGATE;
//        [appDel.bottomNav pushViewController:VC animated:YES];
//        [VC release];
        
        
        return;
        
    }
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(code==1 && method==order)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        NSLog(@"%@",dic);
        
        
        AlixPayOrder *order = [[AlixPayOrder alloc] init];
        order.partner = PartnerID;
        order.seller = SellerID;
        
        order.tradeNO = [dic objectForKey:@"oriderid"];; //订单ID（由商家自行制定）
        order.productName = [dic objectForKey:@"title"]; //商品标题
        order.productDescription = [dic objectForKey:@"description"]; //商品描述
       // order.amount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]]; //商品价格
        	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
        order.notifyURL =   [dic objectForKey:@"notifyURL"]; //回调URL
        
        
        
        NSString *appScheme = @"yunxiaocheparent";
        NSString* orderInfo = order.description;
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSLog(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
       // [AlixLibService exitFullScreen];
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];


        
        
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"订单生成失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            NSString* key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
        }
        else
        {
            //交易失败
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:result.statusMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];

        }
    }
    else
    {
        //失败
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}
-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
-(void)updateChildInfo:(NSNotification *) notification
{
    [mainTV reloadData];
}

- (void)reloadChildMessage
{
    [mainTV reloadData];
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
