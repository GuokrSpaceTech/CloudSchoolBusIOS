//
//  ETActiveDetailViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETActiveDetailViewController
 *  @brief  活动详细信息页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETEvents.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
#import "MTCustomActionSheet.h"
#import "ETShareViewController.h"

@protocol ETActiveDetailViewControllerDelegate <NSObject>
@optional
- (void)reloadTableData:(ETEvents *)event;

@end

@interface ETActiveDetailViewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIWebViewDelegate,EKProtocol,MTCustomActionSheetDelegate,ETCustomAlertViewDelegate>
{
    MBProgressHUD *HUD;
//    UIScrollView  *ScrollView;
//    UITextView  *contentTextview;
     UIView  *downview;
 
    
    UIWebView  *webview;
    UIView *tabView;
}

/// 当前活动信息.
@property(nonatomic,retain)ETEvents *etevent;
@property (nonatomic, assign) id<ETActiveDetailViewControllerDelegate> delegate;
@property (nonatomic, retain)NSString *fontStr;


/// 加载html.
@property(nonatomic,retain)UIWebView  *webview;

/// 修改字体view.

@end
