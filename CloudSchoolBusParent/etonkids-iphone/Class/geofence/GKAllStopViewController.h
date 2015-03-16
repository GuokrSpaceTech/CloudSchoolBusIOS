//
//  GKAllStopViewController.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 14/10/24.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "GKRoute.h"
#import "MBProgressHUD.h"
@protocol AllStopDelegate;
@interface GKAllStopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
    
}
@property (nonatomic,assign)id<AllStopDelegate>delegate;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *arrList;
@property (nonatomic,retain)NSString * currentId;
@property (nonatomic,retain)GKRoute *route;
@end

@protocol AllStopDelegate <NSObject>
-(void)backRefresh;
@end
