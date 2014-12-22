//
//  GKContactViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-19.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKLetterViewController.h"

@interface GKContactViewController : GKBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataArr;
@end
