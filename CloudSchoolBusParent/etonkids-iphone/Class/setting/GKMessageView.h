//
//  GKMessageView.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETBoardSideView.h"
#import "EKRequest.h"
#import "SRRefreshView.h"
@interface GKMessageView : ETBoardSideView<UITableViewDataSource,UITableViewDelegate,EKProtocol,SRRefreshDelegate>
{}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataArr;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end
