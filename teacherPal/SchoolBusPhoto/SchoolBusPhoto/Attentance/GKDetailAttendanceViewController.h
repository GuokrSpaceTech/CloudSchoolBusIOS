//
//  GKDetailAttendanceViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-18.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface GKDetailAttendanceViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *attendanceTableView;
@property (nonatomic,retain) NSMutableArray *attendanceArr;
@end
