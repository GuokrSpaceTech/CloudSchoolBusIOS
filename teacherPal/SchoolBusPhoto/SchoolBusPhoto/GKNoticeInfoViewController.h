//
//  GKNoticeInfoViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-10.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@class GKNotice;
@interface GKNoticeInfoViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)GKNotice *notice;
@property (nonatomic,retain)UITableView *_tableView;
@end
