//
//  GKClassViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//
/*
 展示 班级积分 上传列表 班级学生 功能
 */
#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface GKClassViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSArray *arr;
@end
