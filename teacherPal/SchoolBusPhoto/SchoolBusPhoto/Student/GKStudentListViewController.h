//
//  GKStudentListViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface GKStudentListViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *numLabel;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *studentArr;
@end
