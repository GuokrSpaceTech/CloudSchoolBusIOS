//
//  GKHealthViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "MTCustomActionSheet.h"
#import "EKRequest.h"
@interface GKHealthViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,MTCustomActionSheetDelegate,EKProtocol>
{
      UILabel *numLabel;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *tempatureArr;
@end
