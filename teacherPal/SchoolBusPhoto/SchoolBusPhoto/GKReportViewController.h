//
//  GKReportViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-7-29.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
#import "SRRefreshView.h"
@interface GKReportViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *arrList;


@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end
