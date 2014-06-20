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
    return 3;
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
