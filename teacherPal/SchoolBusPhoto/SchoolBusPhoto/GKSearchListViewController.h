//
//  GKSearchListViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKSearchCell.h"
#import "EKRequest.h"
@class MBProgressHUD;
@interface GKSearchListViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,searchCelldelegate,EKProtocol>
{
    UITableView *_tableView;
    MBProgressHUD *HUD;
    UIButton *addStudentToClass;
}
@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSDictionary *listdic;

@property(nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *tel;

@property (nonatomic,retain)GKStudentAdd *currentSt;
@end
