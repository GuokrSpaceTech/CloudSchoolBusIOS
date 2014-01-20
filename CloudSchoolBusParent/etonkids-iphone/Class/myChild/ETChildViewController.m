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


#define VIEWHEIGHT 110
#define VIEWHEIGHT5 128


@interface ETChildViewController ()

@end

@implementation ETChildViewController
@synthesize mainTV,titleArr,tImageArr;
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
    self.mainTV = nil;
    self.tImageArr = nil;
    self.titleArr = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //section 2
    NSArray *array = [NSArray arrayWithObjects:LOCAL(@"vip", @""),/*LOCAL(@"daijinquan", @""),*/LOCAL(@"chengzhangdangan", @""),LOCAL(@"kewaikeyouhui", @""), nil];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"-vip.png",@"成长档案.png",@"优惠.png", nil];
    
    self.titleArr = array;
    self.tImageArr = imgArr;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) - 46 - 57) style:UITableViewStyleGrouped];
    table.backgroundView = nil;
    table.backgroundColor = CELLCOLOR;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table release];
    
    self.mainTV = table;
    
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
        return 3;
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
        
        UILabel *nicknamelabel=[[UILabel alloc]initWithFrame:CGRectMake(100,35,170,20)];
        nicknamelabel.tag = 101;
//        nicknamelabel.textAlignment=UITextAlignmentRight;
        [cell.contentView addSubview:nicknamelabel];
        nicknamelabel.backgroundColor=[UIColor clearColor];
        nicknamelabel.font=[UIFont systemFontOfSize:18];
        nicknamelabel.text=user.nickname;
        [nicknamelabel release];
        
//        UILabel *typelabel=[[UILabel alloc]initWithFrame:CGRectMake(100,50,170,20)];
//        typelabel.tag = 101;
////        typelabel.textAlignment=UITextAlignmentRight;
//        [cell.contentView addSubview:typelabel];
//        typelabel.backgroundColor=[UIColor clearColor];
//        typelabel.font=[UIFont systemFontOfSize:16];
//        typelabel.text=@"类型：VIP";
//        [typelabel release];
        
        
        
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
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgV.center = CGPointMake(26, 20);
        imgV.image = [UIImage imageNamed:[self.tImageArr objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:imgV];
        [imgV release];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.text = [titleArr objectAtIndex:indexPath.row];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
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
        
        ETCustomAlertView  *alertview=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"comingsoon",@"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alertview show];
        return;
        
//        if (indexPath.row == 0) {
//            
//        }
//        else if (indexPath.row == 1){
//            ETGrowViewController *gVC = [[ETGrowViewController alloc] init];
//            AppDelegate *appDel = SHARED_APP_DELEGATE;
//            [appDel.bottomNav pushViewController:gVC animated:YES];
//            [gVC release];
//        }
    }
}

-(void)updateChildInfo:(NSNotification *) notification
{
    [self.mainTV reloadData];
}

- (void)reloadChildMessage
{
    [self.mainTV reloadData];
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
