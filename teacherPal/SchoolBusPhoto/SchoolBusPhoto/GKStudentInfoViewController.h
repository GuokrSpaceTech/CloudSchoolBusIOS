//
//  GKStudentInfoViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "GKBaseViewController.h"
@interface GKStudentInfoViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)Student *st;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSArray *arr;
@end
