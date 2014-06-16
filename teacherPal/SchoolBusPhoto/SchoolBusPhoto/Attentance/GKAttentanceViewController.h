//
//  GKAttentanceViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "MTCustomActionSheet.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface GKAttentanceViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource,MTCustomActionSheetDelegate,EKProtocol>
{
    UILabel *numLabel;
    MBProgressHUD *HUD;
    UIButton* todayBtn;
}
@property (nonatomic,retain)NSMutableArray *attenceArr;
@property (nonatomic,retain)UITableView *_tableView;
@end
