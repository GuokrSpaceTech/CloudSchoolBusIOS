//
//  GKNoticeListViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-7.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
#import "GKNoticeCell.h"
@interface GKNoticeListViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate,EGORefreshTableDelegate,noticeCelldelegate>
@property (nonatomic,retain)NSMutableArray *noticeList;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;

@property (nonatomic,assign)BOOL isMore;
@end
