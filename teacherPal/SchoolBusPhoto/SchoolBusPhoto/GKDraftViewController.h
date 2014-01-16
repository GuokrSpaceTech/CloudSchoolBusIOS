//
//  GKDraftViewController.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-10.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"

@interface GKDraftViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *editButton;
}

@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic, retain)NSMutableArray *dataArray;

@end
