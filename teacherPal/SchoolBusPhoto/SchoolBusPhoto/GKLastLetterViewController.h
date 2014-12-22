//
//  GKLastLetterViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-18.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "GKLetterViewController.h"

@interface GKLastLetterViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate>

@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *dataArr;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end


