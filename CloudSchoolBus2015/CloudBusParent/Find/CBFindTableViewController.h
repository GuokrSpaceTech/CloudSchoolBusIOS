//
//  CBFindTableViewController.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CBFindTableViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray * dataList;

@property (nonatomic,strong)NSMutableArray * dataList_all;
@property (nonatomic,strong)NSMutableArray * dataList_notice;
@property (nonatomic,strong)NSMutableArray * dataList_article;
@property (nonatomic,strong)NSMutableArray * dataList_report;
@property (nonatomic,strong)NSMutableArray * dataList_streaming;
@property (nonatomic,strong)NSMutableArray * dataList_attendance;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

-(void)selectedTableRow:(NSUInteger)rowNum;
-(void)selectAllMessages;
@end
