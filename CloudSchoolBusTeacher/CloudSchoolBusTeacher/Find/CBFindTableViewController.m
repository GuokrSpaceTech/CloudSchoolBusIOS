//
//  CBFindTableViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBFindTableViewController.h"
#import "EKRequest.h"
#import "CBLoginInfo.h"
#import "Message.h"
#import "FindNoticeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AlbumViewController.h"
#import "CBPagedImageViewController.h"
#import "FPPopoverController.h"
#import "UIColor+RCColor.h"
#import "CBWebViewController.h"
#import "CBDateBase.h"
#import "ClassifyViewController.h"
#import "AriticleView.h"
#import "URLLinkView.h"
#import "CMPopTipView.h"
#import "Reachability.h"

static NSString * cellidenty = @"listcell";
@interface CBFindTableViewController ()<EKProtocol, ArticleViewDelegate, URLLinkViewDelegate, NoticeViewDelegate>
{
    FPPopoverController *popover;
    NSString *apptype;
    NSString *studentid;
    int lastestMessageIdInLocalDB;
    BOOL isNetworkAvailable;
}


-(void)studentSwitchHandle:(NSDictionary *)userInfo;
@end

@implementation CBFindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init Data
    _dataList = [NSMutableArray array];
    apptype = @"All";

    /*
     * Init UI
     */
    //Background
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发现";
    
    //Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    //Tableview
    [self.tableView registerClass:[FindNoticeTableViewCell class] forCellReuseIdentifier:cellidenty];
    self.tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    
    //Filter Button
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_list_white"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    //Cameral Button
    UIButton * camButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [camButton setBackgroundImage:[UIImage imageNamed:@"ic_list_white"] forState:UIControlStateNormal];
    camButton.frame = CGRectMake(0, 0, 30, 30);
    [camButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [camButton addTarget:self action:@selector(camButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * camItem = [[UIBarButtonItem alloc]initWithCustomView:camButton];
    self.navigationItem.rightBarButtonItem = camItem;
    
    //Check if we have logged in
    [[CBLoginInfo shareInstance] baseInfoIsExist:^(BOOL isExist) {
        if(isExist)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                apptype = @"All";
                studentid = [[CBLoginInfo shareInstance] currentClassId];
                lastestMessageIdInLocalDB = 0;
                
                //先从数据库里读出消息
                [self initQueues];
                
                //如果数据库为空，从头开始获取网络数据。
                NSDictionary * paramDict;
                if([_dataList_all count]==0)
                {
//                    paramDict = @{@"newid":@"0"};
                    paramDict = @{@"oldid":@LONG_MAX};
                    [[EKRequest Instance] EKHTTPRequest:getmessage parameters:paramDict requestMethod:GET forDelegate:self];
                } else {
                    _dataList = _dataList_all;
                    [self.tableView
                     performSelectorOnMainThread:@selector(reloadData)
                     withObject:nil
                     waitUntilDone:NO
                     ];
                }
            });
            
        } else { //Session Expired
            NSString *token = [[CBLoginInfo shareInstance] token];
            NSString *mobile = [[CBLoginInfo shareInstance] phone];
            NSDictionary *paramDict = @{@"token":token, @"mobile":mobile};
            [[EKRequest Instance] EKHTTPRequest:login parameters:paramDict requestMethod:POST forDelegate:[CBLoginInfo shareInstance]];
        }
    }];
    
    NSString *notificationName = @"studentswitch";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(studentSwitchHandle:)
     name:notificationName
     object:nil];
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"api36.yunxiaoche.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
}

-(void)viewDidAppear:(BOOL)animated
{
    //    [self.tableView
    //     performSelectorOnMainThread:@selector(reloadData)
    //     withObject:nil
    //     waitUntilDone:NO
    //     ];
    //
    //
}

-(void) initQueues
{
    NSString *currentAppType = apptype;
    
    apptype = @"All";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_all = messageArray;
    }];
    
    apptype = @"Notice";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_notice = messageArray;
    }];
    
    apptype = @"Report";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_report = messageArray;
    }];
    
    apptype = @"Punch";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_attendance = messageArray;
    }];
    
    apptype = @"Article";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_article = messageArray;
    }];
    
    apptype = @"Streaming";
    [[CBDateBase sharedDatabase] initMessageQueueWithType:apptype postHandle:^(NSMutableArray *messageArray) {
        _dataList_streaming = messageArray;
    }];
    
    [[CBDateBase sharedDatabase] selectLastestMessageId:^(int lastestMessageId) {
        lastestMessageIdInLocalDB = lastestMessageId;
    }];
    
    apptype = currentAppType;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Private
-(void)studentSwitchHandle:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    studentid = [userInfo objectForKey:@"current"];
    [self initQueues];
    [self.tableView reloadData];
}

#pragma mark HTTP Deledates
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    [self.tableView reloadData];
}

-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    if(method == getmessage && code == 1)
    {
        NSArray * arr = response;
        
        //收到错误内容返回，直接更新
        if(![arr isKindOfClass:[NSArray class]])
        {
            [self.tableView reloadData];
            return;
        }
        
        //保存新数据到数据库
        NSMutableArray *newMessagesArray =[[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            Message *message = [[Message alloc]initWithDic:arr[i]];
            [newMessagesArray addObject:message];
            [_dataList_all insertObject:message atIndex:0];
        }
        [[CBDateBase sharedDatabase] insertMessagesData:newMessagesArray];
        
        //更新消息类型队列s
        [self initQueues];
        
        //更新当前显示数据列表
        _dataList = [self messageQueuewithType:apptype];
        
        //更新界面
        [self.tableView reloadData];
    }
    else if(method == confirm && code == 1)
    {
        NSString *messageid = [param objectForKey:@"messageid"];
        
        //Update Memory
        for(int i=0; i<[_dataList_notice count]; i++)
        {
            Message *message = _dataList_notice[i];
            if([message.messageid isEqualToString:messageid])
            {
                [_dataList_notice[i] setIsconfirm:@"2"]; //已经回执
            }
            _dataList = _dataList_notice;
            
            //Update DB
            [[CBDateBase sharedDatabase] updateMessageConfirmStatus:@"2" withMessageId:[messageid intValue]];
        
            //Update UI
            [self.tableView reloadData];
        }
    }
    else if(method == login && code == 1)
    {
        NSDictionary *retDict = (NSDictionary *)response;
        NSString *rongToken = [retDict objectForKey:@"rongtoken"];
        NSString *sid = [retDict objectForKey:@"sid"];
        
        [[CBLoginInfo shareInstance] setSid:sid];
        [[CBLoginInfo shareInstance] setRongToken:rongToken];
        
        [[CBDateBase sharedDatabase] updateLoginInfoSid:sid rong:rongToken];
    }
    else if(code == -1 )
    {
        NSDictionary *responseDict = (NSDictionary *)response;
        NSString *errorMessage = [responseDict objectForKey:@"err_message"];
        if(errorMessage!=nil && [errorMessage containsString:@"SESSION"])
        {
            NSString *mobile = [[CBLoginInfo shareInstance] phone];
            NSString *token = [[CBLoginInfo shareInstance] token];
            NSDictionary *paramDict = @{@"mobile":mobile, @"token":token};
            [[EKRequest Instance] EKHTTPRequest:login parameters:paramDict requestMethod:GET forDelegate:self];
        }
    }
}

#pragma mark UI Interfactions
- (void)refreshAction{
    
    NSMutableArray *queue = [self  messageQueuewithType:apptype];
    
    //请求本地数据
    int lastestMessageId;
    if([queue count]>0)
    {
        lastestMessageId = [[[queue firstObject] messageid] intValue];
    }else {
        lastestMessageId = 0;
    }
    
    [[CBDateBase sharedDatabase] fetchMessagesFromDBwithType:apptype fromMessageId:lastestMessageId postHandle:^(NSMutableArray *messageArray) {
        if([messageArray count]>0)
        {
            [self upateQueueWithQueueType:apptype withArray:messageArray];
            
            _dataList = messageArray;
            
            [self.tableView
             performSelectorOnMainThread:@selector(reloadData)
             withObject:nil
             waitUntilDone:NO
             ];
        } else {
            if(isNetworkAvailable){
                NSString *lastestMessageId = [NSString stringWithFormat:@"%d",lastestMessageIdInLocalDB];
                NSDictionary *paramDict = @{@"newid":lastestMessageId};
                [[EKRequest Instance] EKHTTPRequest:getmessage parameters:paramDict requestMethod:GET forDelegate:self];
            } else {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"网络不可用，请检查网络设置" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertview show];
            }
        }
    }];
    
    // 结束刷新
    
    [self.refreshControl endRefreshing];
}

-(void)loadMoreAction
{
    NSMutableArray *queue = [self  messageQueuewithType:apptype];
    int firstMessageId;
    if([queue count]>0)
    {
        firstMessageId = [[[queue lastObject] messageid] intValue];

        [[CBDateBase sharedDatabase] fetchMessagesFromDBwithType:apptype belowMessageId:firstMessageId postHandle:^(NSMutableArray *messageArray) {
            if([messageArray count]>0)
            {
                [self upateQueueWithQueueType:apptype withArray:messageArray];
                
                _dataList = messageArray;
                
                [self.tableView
                 performSelectorOnMainThread:@selector(reloadData)
                 withObject:nil
                 waitUntilDone:NO
                 ];
                
                [self.tableView setContentOffset:CGPointZero];
            }
        }];
    }
}

-(void)upateQueueWithQueueType:(NSString *)type withArray:(NSMutableArray *)messages
{
    if([type isEqualToString:@"All"])
    {
        _dataList_all = messages;
    }
    else if([type isEqualToString:@"Notice"])
    {
        _dataList_notice = messages;
    }
    else if([type isEqualToString:@"Article"])
    {
        _dataList_article = messages;
    }
    else if([type isEqualToString:@"Punch"])
    {
        _dataList_attendance = messages;
    }
    else if([type isEqualToString:@"Report"])
    {
        _dataList_report = messages;
    }
    else if([type isEqualToString:@"Streaming"])
    {
        _dataList_streaming = messages;
    }
}

-(NSMutableArray *)messageQueuewithType:(NSString *)type
{
    if([type isEqualToString:@"All"])
    {
        return _dataList_all;
    }
    else if([type isEqualToString:@"Notice"])
    {
        return _dataList_notice;
    }
    else if([type isEqualToString:@"Article"])
    {
        return _dataList_article;
    }
    else if([type isEqualToString:@"Punch"])
    {
        return _dataList_attendance;
    }
    else if([type isEqualToString:@"Report"])
    {
        return _dataList_report;
    }
    else
    {
        return _dataList_streaming;
    }
}

-(void)filterButtonClick:(id)sender
{
    ClassifyViewController * vc = [[ClassifyViewController alloc]init];
    vc.title = nil;
    vc.delegate = self;
    popover = [[FPPopoverController alloc] initWithViewController:vc];
    popover.border = NO;
    popover.tint = FPPopoverWhiteTint;
    popover.contentSize = CGSizeMake(150, 270);
    [popover presentPopoverFromPoint:CGPointMake(20, 20)];
}

-(void)camButtonClick:(id)sender
{
    AlbumViewController *albumVC = [[AlbumViewController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
}

-(void)selectedTableRow:(NSUInteger)rowNum
{
    NSLog(@"SELECTED ROW %lu",(unsigned long)rowNum);
    if(rowNum == 0) {
        apptype = @"Notice";
        _dataList = _dataList_notice;
    } else if (rowNum == 1) {
        apptype = @"Punch";
        _dataList = _dataList_attendance;
    } else if (rowNum == 2) {
        apptype = @"Streaming";
        _dataList = _dataList_streaming;
    } else if (rowNum == 3) {
        apptype = @"Report";
        _dataList = _dataList_report;
    } else if (rowNum == 4) {
        apptype = @"Article";
        _dataList = _dataList_article;
    }
    
    [self.tableView
     performSelectorOnMainThread:@selector(reloadData)
     withObject:nil
     waitUntilDone:NO
     ];
    
    
    [popover dismissPopoverAnimated:YES];
}

-(void)selectAllMessages
{
    apptype = @"All";
    _dataList = _dataList_all;

    [self.tableView
     performSelectorOnMainThread:@selector(reloadData)
     withObject:nil
     waitUntilDone:NO
     ];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [_dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenty forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fd_enforceFrameLayout = NO;
    Message *message = [_dataList objectAtIndex:indexPath.row];
    cell.messsage = message;
    [cell.articleView setDelegate:self];
    [cell.linkView setDelegate:self];
    [cell.noticeView setDelegate:self];
    
    if (indexPath.row == [_dataList count] - 1)
    {
        [self loadMoreAction];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= [_dataList count])
    {
        Message *message = [_dataList objectAtIndex:indexPath.row];
        
        return [tableView fd_heightForCellWithIdentifier:cellidenty cacheByKey:message.messageid configuration:^(FindNoticeTableViewCell * cell)
                {
                    cell.fd_enforceFrameLayout = NO;
                    cell.messsage = message;
                }];
    } else {
        return 0;
    }
}

#pragma mark - ArticelView Delegate
-(void) userSelectedPicture:(NSString *)picture pictureArray:(NSMutableArray *)picArray indexAt:(int)index desc:(NSString *)description
{
    CBPagedImageViewController *imageGallery = [[CBPagedImageViewController alloc] initWithNibName:@"CBPagedImageViewController" bundle:nil];
    imageGallery.hidesBottomBarWhenPushed = YES;
    [imageGallery setStartIndex:@(index)];
    [imageGallery setPageImages:picArray];
    [imageGallery setDesc:description];

    [self presentViewController:imageGallery animated:YES completion:^{}];
}

-(void) userSelectedTag:(NSString *)tagDesc onButton:(UIButton *)button
{
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:tagDesc];
    popTipView.animation = arc4random() % 2;
    popTipView.has3DStyle = (BOOL)(arc4random() % 2);
    
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    
    [popTipView presentPointingAtView:button inView:self.view animated:YES];;

}

#pragma mark - URLLinkView Delegate
- (void)userTapHandles:(NSString *)title withURL:(NSString *)urlString
{
    CBWebViewController *webVC = [[CBWebViewController alloc] init];
    webVC.titleStr = title;
    webVC.urlStr = urlString;
    
    [[self navigationController] pushViewController:webVC animated:NO];
}

#pragma mark - NoticeView Delegate
- (void)userConfirm:(NSString *)messageid
{
    NSDictionary *paramDict = @{@"messageid":messageid};
    [[EKRequest Instance] EKHTTPRequest:confirm parameters:paramDict requestMethod:POST forDelegate:self];
}
- (void)pictureClick:(NSArray *)pictureUrlArray
{
    CBPagedImageViewController *imageGallery = [[CBPagedImageViewController alloc] initWithNibName:@"CBPagedImageViewController" bundle:nil];
    imageGallery.hidesBottomBarWhenPushed = YES;
    [imageGallery setStartIndex:@(0)];
    [imageGallery setPageImages:pictureUrlArray];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionReveal;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController] pushViewController:imageGallery animated:YES];
}
#pragma mark Reachability
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    //    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"网络不可用", @"Network access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            isNetworkAvailable = false;

            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            isNetworkAvailable = true;
            break;
        }
        case ReachableViaWiFi:        {
            isNetworkAvailable = true;
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    //    if (connectionRequired)
    //    {
    //        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
    //        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    //    }
}
@end
