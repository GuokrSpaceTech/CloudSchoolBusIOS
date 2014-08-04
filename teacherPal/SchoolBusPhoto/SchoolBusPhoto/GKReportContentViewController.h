//
//  GKReportContentViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKReport.h"
@interface GKReportContentViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)GKReport *report;
@end
