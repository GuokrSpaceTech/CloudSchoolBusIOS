//
//  ETFreshViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETFreshViewController
 *  @brief  带有下拉刷新和加载更多的viewcontroller
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETBaseTableViewController.h"

#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
@interface ETFreshViewController : ETBaseTableViewController<EGORefreshTableDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_refreshFooterView;
}
-(void)removeFooterView;
-(void)setFooterView;
@end
