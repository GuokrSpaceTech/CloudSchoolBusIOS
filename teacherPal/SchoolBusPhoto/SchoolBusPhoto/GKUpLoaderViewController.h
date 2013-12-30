//
//  GKUpLoaderViewController.h
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKAppDelegate.h"
#import "UpLoader.h"
#import "GKUpObject.h"
#import "GKUploaderCell.h"
#import "GKFindWraper.h"
#import "GKUpWraper.h"
#import "GKBaseViewController.h"
#import "GKMainViewController.h"
#import "EKRequest.h"
@interface GKUpLoaderViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol>
{
    UITableView *_tableView;
    UILabel *numLabel;
}
@property (nonatomic ,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *upArr;
@end
