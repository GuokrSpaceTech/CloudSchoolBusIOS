//
//  GKZClassBlogViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-19.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
@interface GKClassBlogViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate,EGORefreshTableDelegate>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;

@property (nonatomic,assign)BOOL isMore;
@end
