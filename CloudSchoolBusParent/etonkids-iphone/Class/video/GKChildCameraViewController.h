//
//  GKChildCameraViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "GKSocket.h"
#import "MBProgressHUD.h"
@interface GKChildCameraViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)NSMutableArray *arrList;
@property (nonatomic,retain)UITableView *tableView;

@end
