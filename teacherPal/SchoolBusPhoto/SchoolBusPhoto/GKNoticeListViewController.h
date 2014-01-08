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
@interface GKNoticeListViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
@property (nonatomic,retain)NSMutableArray *noticeList;
@property (nonatomic,retain)UITableView *_tableView;
@end
