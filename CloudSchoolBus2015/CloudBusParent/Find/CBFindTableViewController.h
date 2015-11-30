//
//  CBFindTableViewController.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFindTableViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray * dataList;

@property (nonatomic,strong)NSMutableArray * dataList_all;
@property (nonatomic,strong)NSMutableArray * dataList_notice;
@property (nonatomic,strong)NSMutableArray * dataList_article;
@property (nonatomic,strong)NSMutableArray * dataList_report;
@property (nonatomic,strong)NSMutableArray * dataList_streaming;
@property (nonatomic,strong)NSMutableArray * dataList_attendance;

-(void)selectedTableRow:(NSUInteger)rowNum;
-(void)selectAllMessages;
@end
