//
//  GKSettingViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKRePasswordViewController.h"
@protocol settingViewDelegate;
@interface GKSettingViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,GKRePasswordViewControllerDelegate>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,assign)id<settingViewDelegate>delegate;
@end

@protocol settingViewDelegate <NSObject>
-(void)settingLoginOut;

@end