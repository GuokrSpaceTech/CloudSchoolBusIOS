//
//  GKAlumbViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKUserLogin.h"
#import "GKBadgeView.h"
#import "SRRefreshView.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface GKAlumbViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    UITableView *_tableView;

    GKUserLogin *usr;
    GKBadgeView *badgeView;
    
    BOOL isRefresh;
}
@property (nonatomic,retain)ALAssetsLibrary *_labery;
@property (nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)NSMutableArray *arr;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end
