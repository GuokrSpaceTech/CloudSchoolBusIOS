//
//  GKGeofenceViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-10-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
@interface GKGeofenceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *arrList;
@end
