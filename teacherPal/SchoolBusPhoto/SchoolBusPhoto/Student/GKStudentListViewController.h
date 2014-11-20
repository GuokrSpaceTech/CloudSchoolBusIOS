//
//  GKStudentListViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
@interface GKStudentListViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
{
    UILabel *numLabel;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *studentArr;
@property (nonatomic,retain)NSMutableArray *tempatureArr;
@end
