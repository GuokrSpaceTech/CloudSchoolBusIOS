//
//  GKHealthListViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRefreshView.h"
#import "LoadMoreTableFooterView.h"
#import "MBProgressHUD.h"
#import "GKWriteHealthViewController.h"
@interface GKHealthListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,EGORefreshTableDelegate,writeHealthVCdelegate>
{
    NSInteger  currentnumber;
    BOOL hasmore;
    
    BOOL isLoading;
    BOOL isUpfresh;
    MBProgressHUD *HUD;
}
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@property (nonatomic, retain) LoadMoreTableFooterView *_refreshFooterView;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *dateArr;





@end
