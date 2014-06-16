//
//  ActivityViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ActivityViewController.h"
#import "UserLogin.h"
#import "UIImageView+WebCache.h"
#import "ETActivityCell.h"
#import "ETEvents.h"
#import "ETCoreDataManager.h"
#import "ETCommonClass.h"
#import "GTMBase64.h"
#import "NSDate+convenience.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize activityList,myActivityList,photoParam,requestArray,dataList,noStartActivityList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _topView.frame = CGRectMake(_topView.frame.origin.x, _topView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height - HEADERHEIGHT);
//    self._tableView.tableHeaderView.frame = CGRectMake(_topView.frame.origin.x, _topView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height - HEADERHEIGHT);
    
    _topView.ageBack.hidden = YES;
    
    [self setTopView];
    
//    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change:)];
//    recognizer.delegate=self;
//    [_topView.photoImageView addGestureRecognizer:recognizer];
//    [recognizer release];
    
    self.activityList = [NSMutableArray array];
    
    self.noStartActivityList = [NSMutableArray array];
    
    self.myActivityList = [NSMutableArray array];
    
    self.requestArray = [NSMutableArray array];
    
    
    currentType = AllActivity;
    
    
    isMoreMyAct = YES;
    isMoreNoStart = YES;
    isMoreAllAct = YES;
    
    isFirLoadMyAct = YES;
    isFirLoadNoStartAct = YES;
    
    
    [self loadData];
    
    
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height - _tableView.contentOffset.y, 320, HEADERHEIGHT)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADERHEIGHT)];
    backImgV.image = [UIImage imageNamed:@"activity_header.png"];
    [tableHeaderView addSubview:backImgV];
    [backImgV release];
    
    selImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 106, HEADERHEIGHT)];
    selImgV.image = [UIImage imageNamed:@"activity_selected.png"];
    [tableHeaderView addSubview:selImgV];
    [selImgV release];
    
    NSArray *arr = [NSArray arrayWithObjects:LOCAL(@"wodebaoming",@"我的报名"),LOCAL(@"quanbu",@"全部"),LOCAL(@"kebaoming",@"可报名"), nil];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTag:333 + i];
        [btn addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setFrame:CGRectMake(106*i, 1, 105, HEADERHEIGHT - 2)];
        [tableHeaderView addSubview:btn];
    }
    
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(106/2 + currentType*107, HEADERHEIGHT/2 + 1);
        }];
        
    }
    
    [self.view addSubview:tableHeaderView];
    [tableHeaderView release];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadTableData:(ETEvents *)event
{
//    if (currentType == MyActivityType) {
//        self.myActivityList = [NSMutableArray arrayWithArray:[ETCoreDataManager searchAllMyActivity]];
//    }
    
//    [self._tableView reloadData];
    if (self.myActivityList.count == 0)
    {
        [self.myActivityList addObject:event];
    }
    else
    {
        for (int i = 0;i < self.myActivityList.count;i++) {
            ETEvents *e = [self.myActivityList objectAtIndex:i];
            if ([e.events_id isEqualToString:event.events_id]) {
                
                if ([event.isSignup isEqualToString:@"0"]) {
                    [self.myActivityList removeObjectAtIndex:i];
                }
                break;
            }
            if (i == self.myActivityList.count - 1) {
                [self.myActivityList addObject:event];
                //排序
                
                [self.myActivityList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    ETEvents *ev1 = obj1;
                    ETEvents *ev2 = obj2;
                    
                    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
                    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    
                    NSDate *d1 = [format dateFromString:ev1.addtime];
                    NSDate *d2 = [format dateFromString:ev2.addtime];
                    
                    int t = [d1 timeIntervalSinceDate:d2];
                    if (t > 0) // d2 小  d1 大
                    {
                        return NSOrderedAscending;
                    }
                    else if (t < 0)
                    {
                        return NSOrderedDescending;
                    }
                    else
                    {
                        return NSOrderedSame;
                    }
                    
                }];
                
                
            }
        }
    }
    
    
    
    
    for (int i = 0;i<self.noStartActivityList.count;i++) {
        ETEvents *e = [self.noStartActivityList objectAtIndex:i];
        if ([e.events_id isEqualToString:event.events_id]) {
            [self.noStartActivityList replaceObjectAtIndex:i withObject:event];
            break;
        }
    }
    
    for (int i = 0;i<self.activityList.count;i++) {
        ETEvents *e = [self.activityList objectAtIndex:i];
        if ([e.events_id isEqualToString:event.events_id]) {
            [self.activityList replaceObjectAtIndex:i withObject:event];
            break;
        }
    }
    
    [self updateDataList];
    [_tableView reloadData];
    
}

- (void)loadData
{
    
    self.activityList = [NSMutableArray arrayWithArray:[ETCoreDataManager searchAllActivity]];
    self.noStartActivityList = [NSMutableArray arrayWithArray:[ETCoreDataManager searchAllNoStartActivity]];
    self.myActivityList = [NSMutableArray arrayWithArray:[ETCoreDataManager searchAllMyActivity]];
    
    
    [self updateDataList];
    
    [_tableView reloadData];
    
    
    
    UserLogin *user = [UserLogin currentLogin];
    
    if(user.loginStatus == LOGIN_SERVER)
    {
        
        _topView.nameLabel.text = user.nickname;
        _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
        _topView.classLabel.text = user.className;
        [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            _topView.photoImageView.image = image;
            
        }];
        
        
        [self autoDragScrollLoading];
        
    }
    else
    {
        // 如果没有登录并没出现登录页面  说明含有自动登录，当出现登录页面时，但是此页面依然存在，所以没有自动登录的值.
        
        
        NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
        
        if ([defaultUser objectForKey:AUTOLOGIN])
        {
            // 如果是自动登录  首先加载本地缓存（学生信息，数据等等）.
            _topView.nameLabel.text = user.nickname;
            _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
            _topView.classLabel.text = user.className;
            [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                _topView.photoImageView.image = image;
            }];
            
            
            [self autoDragScrollLoading];
            //NSLog(@"111");
            
        }
        else
        {
            // 应不做处理 当登录成功是再做处理.
        }
        
    }
}


- (void)updateDataList
{
    if (currentType == MyActivityType)
    {
        self.dataList = self.myActivityList;
        if (self.dataList.count < 15) {
            isMoreMyAct = NO;
        }
        
        isMore = isMoreMyAct;
        
        
    }
    else if (currentType == NoStartActivity)
    {
        self.dataList = self.noStartActivityList;
        if (self.dataList.count < 15) {
            isMoreNoStart = NO;
        }
        
        isMore = isMoreNoStart;
        
        
    }
    else
    {
        self.dataList = self.activityList;
        if (self.dataList.count < 15) {
            isMoreAllAct = NO;
        }else
        {
            isMoreAllAct = YES;
        }
        
        isMore = isMoreAllAct;
        
        
    }
    
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
}

-(void)change:(UIGestureRecognizer*)sender
{
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
    action.tag=2;
    [action showInView:self.view.window];
    [action release];
    
}

- (void)saveImage:(UIImage *)image
{
    
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    self.photoParam = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [base64 release];
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        [[EKRequest Instance] EKHTTPRequest:comment parameters:self.photoParam requestMethod:POST forDelegate:self];
    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (currentType == MyActivityType) {
        if (self.myActivityList.count == 0) {
            return 1;
        }
        return self.myActivityList.count;
    
    }
    else if (currentType == AllActivity) {
        if (self.activityList.count == 0) {
            return 1;
        }
        return self.activityList.count;
    
    }
    else{
        if (self.noStartActivityList.count == 0) {
            return 1;
        }
        return self.noStartActivityList.count;
    }

    if (self.dataList.count == 0) {
        return 1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"classCell";
    
    if (self.dataList.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = CELLCOLOR;
//        cell.textLabel.text = LOCAL(@"defaultdata", @"");
//        cell.textLabel.font=[UIFont systemFontOfSize:28];
//        cell.textLabel.textColor=[UIColor grayColor];
//        cell.textLabel.textAlignment=UITextAlignmentCenter;
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 131)];
        imgV.image = [UIImage imageNamed:@"nodata.png"];
        imgV.center = CGPointMake(160, ((iphone5 ? 548 : 460) - 46 - 57 - 135)/2);
        [cell addSubview:imgV];
        [imgV release];
        
        return cell;
    }
    static NSString *CellIdentifier1 = @"classCell1";
    ETActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[ETActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
    }
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:220/255.0f green:218/255.0f blue:207/255.0f alpha:1.0f];
    
    ETEvents *event = [self.dataList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = event.title;
    
//    cell.timeLabel.text = event.addtime;
    
    //---- calculate time -------
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *addDate = [format dateFromString:event.addtime];
    
    
    NSString *time = [NSString stringWithFormat:@"%d",(int)[addDate timeIntervalSince1970]];
    
    int cDate = [[NSDate date] timeIntervalSince1970];
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    int sub = cDate - time.intValue;
    
    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,LOCAL(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60)
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),LOCAL(@"hoursago", @"")];
    }
    else if (pDate.year == [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else if (pDate.year < [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"error time"];
    }
    
    
    if (time !=nil) {
        cell.timeLabel.text = dateStr;
    }
    
    
    
    
    
    
    NSString *status ;
    
    if ([event.SignupStatus isEqualToString:@"1"]) {
        status = [NSString stringWithFormat:@"%@",LOCAL(@"activeStatus4", @"进行中")];
    }
    else if ([event.SignupStatus isEqualToString:@"-1"]){
        status = [NSString stringWithFormat:@"%@",LOCAL(@"activeStatus1", @"未开始")];
    }
    else if ([event.SignupStatus isEqualToString:@"-2"]){
        status = [NSString stringWithFormat:@"%@",LOCAL(@"activeStatus2", @"已结束")];
    }
    else if ([event.SignupStatus isEqualToString:@"-3"]){
        status = [NSString stringWithFormat:@"%@",LOCAL(@"activeStatus3", @"满员")];
    }
    else{
        status = @"";
    }
    
    cell.statusLabel.text = status;
    
    if(indexPath.row==[self.dataList count]-1)
    {
        if(isMore)
            [self setFooterView];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.dataList.count == 0) return (iphone5 ? 568 : 460) - 46 - 57 - 135 - 40; // 还要减去header高度.
    
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataList.count == 0)
        return;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ETActiveDetailViewController *detailViewController=[[ETActiveDetailViewController alloc]init];
    detailViewController.etevent = [self.dataList objectAtIndex:indexPath.row];
    detailViewController.delegate = self;
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:detailViewController animated:YES];
    [detailViewController release];

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADERHEIGHT)];
    header.backgroundColor = [UIColor clearColor];
    /*
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADERHEIGHT)];
    backImgV.image = [UIImage imageNamed:@"activity_header.png"];
    [header addSubview:backImgV];
    [backImgV release];
    
    selImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 106, HEADERHEIGHT)];
    selImgV.image = [UIImage imageNamed:@"activity_selected.png"];
    [header addSubview:selImgV];
    [selImgV release];
    
    NSArray *arr = [NSArray arrayWithObjects:LOCAL(@"wodebaoming",@"我的报名"),LOCAL(@"quanbu",@"全部"),LOCAL(@"kebaoming",@"可报名"), nil];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTag:333 + i];
        [btn addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setFrame:CGRectMake(106*i, 1, 105, HEADERHEIGHT - 2)];
        [header addSubview:btn];
    }
    
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(106/2 + currentType*107, HEADERHEIGHT/2 + 1);
        }];
        
    }
    */
    
    return header;
    
}

- (void)doChoose:(UIButton *)sender
{
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(106/2 + sender.tag%333*107, HEADERHEIGHT/2 + 1);
        }];
        
    }
    currentType = sender.tag % 333;
    
    
    [self updateDataList];
    [_tableView reloadData];
    
//    [self requestNewData];
    
    if (currentType == MyActivityType && isFirLoadMyAct) {
        isFirLoadMyAct = NO;
        [self autoDragScrollLoading];
    }
    else if (currentType == NoStartActivity && isFirLoadNoStartAct) {
        isFirLoadNoStartAct = NO;
        [self autoDragScrollLoading];
    }

    
}


- (void)requestNewData
{
    if (currentType == MyActivityType)
    {
        self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"myevents",  @"0",@"startid",@"0",@"endid",nil];
    }
    else if (currentType == NoStartActivity)
    {
        self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"myevents", @"0", @"startid", @"0", @"endid",@"1",@"signup",nil];
    }
    else
    {
        self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"myevents", @"0", @"startid", @"0", @"endid",nil];
    }
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        theRefreshPos = EGORefreshHeader;
        [[EKRequest Instance] EKHTTPRequest:eventslist parameters:self.eventParam requestMethod:GET forDelegate:self];
    }];
    
}

#pragma mark - Table view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    tableHeaderView.frame = CGRectMake(tableHeaderView.frame.origin.x,
                                       MAX(0,_topView.frame.size.height - _tableView.contentOffset.y),
                                       tableHeaderView.frame.size.width,
                                       tableHeaderView.frame.size.height);
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    //    [self showHUD:YES];
    
    [self requestNewData];
    
}

- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    if(aRefreshPos == EGORefreshHeader)
    {
        
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            
            
            // 获取最后一条数据时间
            
            ETEvents *event = self.dataList.lastObject;
            
//            NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
//            format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            
//            NSDate *d = [format dateFromString:event.addtime];
//            int t = [d timeIntervalSince1970];
            
            NSString *lastTime = [NSString stringWithFormat:@"%@",event.events_id];
            
            isLoading = YES;
            
            theRefreshPos = EGORefreshFooter;
            
            if (currentType == MyActivityType)
            {
                self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"myevents",  lastTime,@"startid",@"0",@"endid",nil];
            }
            else if (currentType == NoStartActivity)
            {
                self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"myevents", lastTime, @"startid", @"0", @"endid",@"1",@"signup",nil];
            }
            else
            {
                self.eventParam = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"myevents", lastTime, @"startid", @"0", @"endid",nil];
            }
            
            
            NSLog(@" request events parameter :   %@",self.eventParam);
            
            ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
            [com requestLoginWithComplete:^(NSError *err){
                [[EKRequest Instance] EKHTTPRequest:eventslist parameters:self.eventParam requestMethod:GET forDelegate:self];
            }];
            
        }
    }
}


- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self reloadTableViewDataSource:aRefreshPos];
}


//- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
//{
//	return isLoading; // should return if data source model is reloading
//    
//}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    isLoading = NO;
    [_slimeView endRefresh];
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//        [self removeFooterView];
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    isLoading = NO;
//    UserLogin *user=[UserLogin currentLogin];
    
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else if (method == eventslist)
    {
        
        [_slimeView endRefresh];
        
        NSLog(@"%d",code);
        
        if(code==1)
        {
            id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            
            if (![result isKindOfClass:[NSArray class]]) {
                
                NSLog(@"活动列表返回格式错误");
                return;
            }
            
            NSArray *arr = result;
            
            NSLog(@"%@",arr);
            NSString *p = [NSString stringWithFormat:@"%@",[param objectForKey:@"myevents"]];
            
            if(theRefreshPos==EGORefreshFooter)
            {
                if ([p isEqualToString:@"1"])
                {
                    [self parserData:arr inList:self.myActivityList];
                }
                else if ([p isEqualToString:@"0"])
                {
                    
                    if ([param objectForKey:@"signup"] != nil) // 可报名
                    {

                        [self parserData:arr inList:self.noStartActivityList];
                    }
                    else //全部活动
                    {
                        [self parserData:arr inList:self.activityList];
                    }
                }
                
            }
            else
            {  
                //操作数据库
                if ([p isEqualToString:@"1"]) // 我的报名
                {
                    //清空 并加入新数据.
                    [self.myActivityList removeAllObjects];
                    [self parserData:arr inList:self.myActivityList];
                    
                    [ETCoreDataManager removeAllMyActivity];
                    [ETCoreDataManager addMyActivityData:self.myActivityList];
                }
                else if ([p isEqualToString:@"0"])
                {
                    
                    if ([param objectForKey:@"signup"] != nil) // 可报名
                    {
                        //清空 并加入新数据.
                        [self.noStartActivityList removeAllObjects];
                        [self parserData:arr inList:self.noStartActivityList];
                        
                        [ETCoreDataManager removeAllNoStartActivity];
                        [ETCoreDataManager addNoStartActivityData:self.noStartActivityList];
                    }
                    else //全部活动
                    {
                        //清空 并加入新数据.
                        [self.activityList removeAllObjects];
                        [self parserData:arr inList:self.activityList];
                        
                        [ETCoreDataManager removeAllActivity];
                        [ETCoreDataManager addActivityData:self.activityList];
                    }
                    
                    
                }
                
                
            }
        
            [self updateDataList];
            [_tableView reloadData];
            
//            SignupStatus
//                case 1:
//                      @"进行中"
//                    
//                case -1:
//                      @"未开始"
//                    
//                case -2:
//                      @"已结束"
//                    
//                case -3:
//                      @"满员"
//                    
            
        }
        else if (code == -2)
        {
            NSString *p = [NSString stringWithFormat:@"%@",[param objectForKey:@"myevents"]];
            
            if (theRefreshPos == EGORefreshFooter)
            {
                
                if ([p isEqualToString:@"1"]) // 我的报名
                {
                    isMoreMyAct = NO;
                }
                else if ([p isEqualToString:@"0"])
                {
                    
                    if ([param objectForKey:@"signup"] != nil) // 可报名
                    {
                        isMoreNoStart = NO;
                    }
                    else //全部活动
                    {
                        isMoreAllAct = NO;
                    }
                }
            }
            else
            {
                
                if ([p isEqualToString:@"1"]) // 我的报名
                {
                    [ETCoreDataManager removeAllMyActivity];
                    [self.myActivityList removeAllObjects];
                }
                else if ([p isEqualToString:@"0"])
                {
                    
                    if ([param objectForKey:@"signup"] != nil) // 可报名
                    {
                        [ETCoreDataManager removeAllNoStartActivity];
                        [self.noStartActivityList removeAllObjects];
                    }
                    else //全部活动
                    {
                        //清空 并加入新数据.
                        
                        [ETCoreDataManager removeAllActivity];
                        [self.activityList removeAllObjects];
                    }
                    
                }
            }
            
            [self updateDataList];
            [_tableView reloadData];
        }
        else
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
    }

    
}

- (void)parserData:(NSArray *)arr inList:(NSMutableArray *)array
{
    for (int i=0; i<[arr count]; i++) {
        
        NSDictionary *dic = [arr objectAtIndex:i];
        
        ETEvents *events=[[ETEvents alloc]init];
        events.SignupStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SignupStatus"]];
        events.addtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
        events.events_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"events_id"]];
        events.shool_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"schoolid"]];
        events.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        events.end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"end_time"]];
        events.htmlurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"htmlurl"]];
        events.isSignup = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isSignup"]];
        events.isonline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isonline"]];
        events.picUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pic_url"]];
        events.sign_up = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up"]];
        events.sign_up_end_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_end_time"]];
        events.sign_up_start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign_up_start_time"]];
        events.start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_time"]];
        events.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        
        [array addObject:events];
        [events release];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"disappear");
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"appear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    self.activityList = nil;
    self.myActivityList = nil;
    self.noStartActivityList = nil;
    self.photoParam = nil;
    self.requestArray = nil;
    self.eventParam = nil;
    self.dataList = nil;
    [super dealloc];
}


@end
