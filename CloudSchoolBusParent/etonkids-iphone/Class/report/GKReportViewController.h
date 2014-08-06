//
//  GKReportViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-6.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"
@interface GKReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,EGORefreshTableDelegate,EKProtocol,UISearchBarDelegate>
{
    BOOL isLoading;
    BOOL isMore;
    UISearchBar *_searchBar;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;
@property (nonatomic,retain)NSMutableArray *list;
@end
