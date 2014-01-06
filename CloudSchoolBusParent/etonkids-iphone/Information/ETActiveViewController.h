//
//  ETActiveViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETActiveViewController
 *  @brief  活动报名界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETBaseTableViewController.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
#import "LeveyTabBar.h"
#import "ETFreshViewController.h"
@interface ETActiveViewController : ETFreshViewController<EKProtocol>
{
     MBProgressHUD *HUD;
    NSMutableArray *dataList;
    BOOL isLoading;
     BOOL isMore;
    EGORefreshPos theRefreshPos;
}

/// 数据列表.
@property(nonatomic,retain)  NSMutableArray *dataList;

/// 无数据显示.
@property(nonatomic,retain)IBOutlet UIView  *DefaultView;

/// 时间数组 根据列表中数据的时间 来判断加载数据时的时间段.
@property(nonatomic,retain)NSMutableArray *timeArr;


@end
