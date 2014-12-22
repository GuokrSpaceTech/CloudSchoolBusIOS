//
//  GKMessageView.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETBoardSideView.h"
#import "EKRequest.h"
@interface GKMessageView : ETBoardSideView<UITableViewDataSource,UITableViewDelegate,EKProtocol>
{}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataArr;
@end
