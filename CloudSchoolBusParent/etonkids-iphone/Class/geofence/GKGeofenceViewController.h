//
//  GKGeofenceViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-10-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "MBProgressHUD.h"
#import "GKAllStopViewController.h"
#import "GKRouteViewController.h"
@interface GKGeofenceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,AllStopDelegate,routeDelegate,UIAlertViewDelegate>
{

    UILabel *middleLabel;
    MBProgressHUD *HUD;
    UIButton * rightButton;

}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *arrList;

@property (nonatomic,retain)NSMutableArray *arrTempList; // 存放临时所以站点


@property (nonatomic,retain)NSString *currentStopid;
@end
