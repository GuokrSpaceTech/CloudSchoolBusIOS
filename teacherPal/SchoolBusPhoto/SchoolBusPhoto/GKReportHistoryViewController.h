//
//  GKReportHistoryViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-29.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
@interface GKReportHistoryViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate,EGORefreshTableDelegate>
@property (nonatomic,retain)UITableView *_tableView;

@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,assign)BOOL isMore;
@end
