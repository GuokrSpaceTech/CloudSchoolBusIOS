//
//  ETMyCollectViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETMyCollectViewController
 *  @brief  我的收藏页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETFreshViewController.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface ETMyCollectViewController : ETFreshViewController<EKProtocol>
{
    BOOL isLoading;
    BOOL isMore;
    
    NSMutableArray *dataList;
    MBProgressHUD *HUD;
    NSIndexPath *indexpath;
    EGORefreshPos theRefreshPos;
}

///  数据列表.
@property(nonatomic,retain) NSMutableArray *dataList;
@property(nonatomic,retain)NSIndexPath *indexpath;
@property(nonatomic,retain)NSMutableArray *timeArr;

@end
