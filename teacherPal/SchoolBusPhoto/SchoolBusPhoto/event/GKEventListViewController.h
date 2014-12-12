//
//  GKEventListViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-11.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
@interface GKEventListViewController : GKBaseViewController<EKProtocol,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,EGORefreshTableDelegate>
{
}
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign)BOOL isMore;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *list;
@end
