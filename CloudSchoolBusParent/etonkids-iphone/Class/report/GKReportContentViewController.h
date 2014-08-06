//
//  GKReportContentViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-4.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKReport.h"
@interface GKReportContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)GKReport *report;
@end
