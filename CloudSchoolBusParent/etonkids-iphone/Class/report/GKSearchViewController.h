//
//  GKSearchViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-8-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "LoadMoreTableFooterView.h"
@interface GKSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,EGORefreshTableDelegate,UISearchBarDelegate>
@property (nonatomic,retain)NSString *searchcontent;
@property (nonatomic,retain)UITableView *_tableView;

@property (nonatomic,assign)BOOL isLoading;

@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,assign)BOOL isMore;
@end
