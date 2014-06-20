//
//  GKHealthListViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKHealthListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *dateArr;
@end
