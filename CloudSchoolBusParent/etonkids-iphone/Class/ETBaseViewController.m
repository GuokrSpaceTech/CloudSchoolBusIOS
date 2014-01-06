
#import "ETBaseViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
@implementation ETBaseViewController

@synthesize _topView;
@synthesize _tableView;
@synthesize weiboEngine,_slimeView,topBackImgView,_refreshFooterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackGround:) name:@"CHANGEBACKGROUND" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    self.view.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.90 alpha:1.0];
    _weiboSignIn = [[WeiboSignIn alloc] init];
    _weiboSignIn.delegate = self;
    
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.yunxiaoche.com"];
    [engine setRootViewController:self];
    //[engine setRedirectURI:@"http://www.ying7wang7.com"];
    self.weiboEngine = engine;
    [engine release];
    
    
    self.view.backgroundColor = CELLCOLOR;
    
    UIView *topBack = [[UIView alloc] initWithFrame:CGRectMake(0, -10, 320, 220)];
    topBack.layer.masksToBounds = YES;
    [self.view addSubview:topBack];
    [topBack release];
    
    topBackImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    topBackImgView.image = [UIImage imageNamed:@"003.png"];
    topBackImgView.contentMode = UIViewContentModeScaleToFill;
    [topBack addSubview:topBackImgView];
    [topBackImgView release];
    
    [self updateBackGround:nil];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, (iphone5 ? 548 : 460) -57 - 46) style:UITableViewStylePlain];
    self._tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    
    _topView=[[[ETTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)] autorelease];
    _topView.backgroundColor=[UIColor clearColor];
    _topView.delegate=self;
    self._tableView.tableHeaderView=_topView;
    [_topView release];

//    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
//    if(user.loginStatus==LOGIN_SERVER)
//    {
//        if(_refreshHeaderView && [_refreshHeaderView superview])
//        {
//            [_refreshHeaderView removeFromSuperview];
//        }
//        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
//        _refreshHeaderView.delegate = self;
//        _refreshHeaderView.backgroundColor = [UIColor clearColor];
//        [_tableView addSubview:_refreshHeaderView];
//        [_refreshHeaderView refreshLastUpdatedDate];
//    }
//    else{
//        
//       // _tableView.b
//        _tableView.contentInset=UIEdgeInsetsZero;
//      //  scrollView.contentInset = ;
//    }
    
    
    self._slimeView = [[SRRefreshView alloc] init];
    self._slimeView.delegate = self;
    self._slimeView.upInset = 0;
    self._slimeView.slimeMissWhenGoingBack = YES;
    self._slimeView.slime.bodyColor = [UIColor blackColor];
    self._slimeView.slime.skinColor = [UIColor blackColor];
    self._slimeView.slime.lineWith = 1;
    self._slimeView.slime.shadowBlur = 4;
    self._slimeView.slime.shadowColor = [UIColor blackColor];
    
    [_tableView addSubview:self._slimeView];
    
    [self._slimeView release];
    
    
    toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [toTopBtn setBackgroundImage:[UIImage imageNamed:@"topA.png"] forState:UIControlStateNormal];
    [toTopBtn setBackgroundImage:[UIImage imageNamed:@"top.png"] forState:UIControlStateHighlighted];
    toTopBtn.frame=CGRectMake(320-56, self.view.frame.size.height-100 - 44 - 17 - (ios7 ? 20 : 0), 46, 46);
    [toTopBtn addTarget:self action:@selector(topTop:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:toTopBtn];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%f,%f",tableView.contentSize.height,tableView.frame.size.height);
    if (tableView.contentSize.height <= tableView.frame.size.height + 30 && !toTopBtn.hidden)
    {
        toTopBtn.hidden = YES;
    }
    else if (tableView.contentSize.height > tableView.frame.size.height + 30 && toTopBtn.hidden)
    {
        toTopBtn.hidden = NO;
    }
}

- (void)setTopView
{
    _topView.frame = CGRectMake(_topView.frame.origin.x, _topView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height - HEADERHEIGHT);
    _tableView.tableHeaderView = _topView;
    
}

-(void)pushShareViewController:(UIViewController *)control
{
    [self.navigationController pushViewController:control animated:YES];
}
-(void)topTop:(id) sender
{
    [_tableView  setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)setFooterView
{
    
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if(_refreshFooterView && [_refreshFooterView superview])
    {
        _refreshFooterView.hidden = NO;
        _refreshFooterView.frame = CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height);
    }
    else
    {
        LoadMoreTableFooterView *refreshFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _tableView.frame.size.width, _tableView.bounds.size.height)];
        refreshFooterView.delegate = self;
        [_tableView addSubview:refreshFooterView];
        [refreshFooterView release];
        
        self._refreshFooterView = refreshFooterView;
        self._refreshFooterView.backgroundColor=[UIColor clearColor];
    }
    
}
-(void)removeFooterView
{
    _refreshFooterView.hidden = YES;
    
//    if(_refreshFooterView && [_refreshFooterView superview])
//    {
//        [_refreshFooterView removeFromSuperview];
//    }
//    _refreshFooterView = nil;
}
-(void)showActionSheet
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:LOCAL(@"share", @"分享") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消")  destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"sina", @"新浪微博"),LOCAL(@"tencent",@"腾讯微博"),LOCAL(@"wechat",@"微信"), nil];
    [sheet showInView:self.view];
    
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int y = scrollView.contentOffset.y;
    if (y <= 0) {
        
        if (ABS(y) >= 30) {
            topBackImgView.transform = CGAffineTransformMakeScale(1 + (ABS(y)-30) * 0.2f/30.0f, 1 + (ABS(y)-30) * 0.2f/30.0f);
        }
        else{
            
//            topBackImgView.transform = CGAffineTransformMakeTranslation(0, ABS(y)*0.2);
            topBackImgView.frame = CGRectMake(topBackImgView.frame.origin.x, -10 + ABS(y)*0.3f, topBackImgView.frame.size.width, topBackImgView.frame.size.height);
        }
        
       // NSLog(@"%d", y);
    }
    else
    {
        topBackImgView.frame = CGRectMake(topBackImgView.frame.origin.x, -10 - y, topBackImgView.frame.size.width, topBackImgView.frame.size.height);
    }
    
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


- (void)updateBackGround:(NSNotification *) notification
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"006.png",@"002.png",@"003.png",@"004.png",@"005.png",@"001.png",@"007.png",@"008.png",@"009.png",@"010.png",@"011.png",@"012.png", nil];
    
    NSString *obj = [userdefault objectForKey:@"HEADERBACKGROUND"];
    
    if ([obj isEqualToString:@"-1"])
    {
        id o = [userdefault objectForKey:@"HEADERBACKGROUND_DATA"];
        if (o && [o isKindOfClass:[NSData class]])
        {
            NSData *d = (NSData *)o;
            topBackImgView.image = [UIImage imageWithData:d];
        }
        else
        {
            topBackImgView.image = [UIImage imageNamed:[imgArr objectAtIndex:0]];
        }
    }
    else
    {
        if (obj.intValue < imgArr.count)
        {
            topBackImgView.image = [UIImage imageNamed:[imgArr objectAtIndex:obj.intValue]];
        }
        else
        {
            topBackImgView.image = [UIImage imageNamed:[imgArr objectAtIndex:0]];
        }
    }
    
//    if ([obj isKindOfClass:[NSData class]]) {
//        NSData *d = (NSData *)obj;
//        topBackImgView.image = [UIImage imageWithData:d];
//    }
//    else if ([obj isKindOfClass:[NSString class]])
//    {
//        NSString *num = (NSString *)obj;
//        
//        if ([num isEqualToString:@"-1"]) {
//            <#statements#>
//        }
//        
//        topBackImgView.image = [UIImage imageNamed:[imgArr objectAtIndex:num.intValue]];
//    }
}
- (void)autoDragScrollLoading
{
    [self._tableView setContentOffset:CGPointMake(0, -50) animated:NO];
    self._slimeView.loading = YES;
    self._slimeView.alpha = 0.0f;
    self._slimeView.broken = YES;
    
    [self._slimeView scrollViewDidScrollToPoint:CGPointMake(0, -50)];
    [self._slimeView scrollViewDidEndDraging];
    [self._slimeView pullApart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self._topView=nil;
    self._tableView = nil;
    self._slimeView = nil;
    self.topBackImgView = nil;
    self.weiboEngine = nil;
    self._refreshFooterView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

@end
