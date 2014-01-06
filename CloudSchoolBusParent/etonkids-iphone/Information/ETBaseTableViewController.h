//
//  ETBaseTableViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETBaseTableViewController
 *  @brief  带有tabelview的基类
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETViewController.h"

@interface ETBaseTableViewController : ETViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property ( nonatomic ,retain)  UITableView *_tableView;

@end
