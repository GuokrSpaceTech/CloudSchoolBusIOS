//
//  ETMyActiveViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETMyActiveViewController
 *  @brief  我的活动页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETBaseTableViewController.h"
#import "ETFreshViewController.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"
@interface ETMyActiveViewController : ETFreshViewController<EKProtocol>
{
    MBProgressHUD *HUD;
    BOOL isLoading;
    BOOL isMore;
    
    NSMutableArray *dataList;
    EGORefreshPos theRefreshPos;
}
@property(nonatomic,retain)  NSMutableArray *dataList;
@property(nonatomic,retain)NSMutableArray *timeArr;

@end
