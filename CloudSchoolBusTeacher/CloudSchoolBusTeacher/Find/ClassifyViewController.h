//
//  ClassifyViewController.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/17.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFindTableViewController.h"
@interface ClassifyViewController : UITableViewController
@property (nonatomic,weak)CBFindTableViewController * delegate;
@end
