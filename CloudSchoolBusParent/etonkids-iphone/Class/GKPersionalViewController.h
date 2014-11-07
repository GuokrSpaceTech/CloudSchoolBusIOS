//
//  GKPersionalViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-11-6.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
@interface GKPersionalViewController : UIViewController<EKProtocol,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain) NSArray *descArr;
@property (nonatomic,retain) NSArray *funArr;
@property (nonatomic,retain)NSString *price;

@end
