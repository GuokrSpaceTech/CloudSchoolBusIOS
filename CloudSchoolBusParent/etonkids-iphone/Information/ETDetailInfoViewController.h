//
//  ETDetailInfoViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETDetailInfoViewController
 *  @brief  教育资讯详细信息页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETViewController.h"
#import "Infomation.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "MTCustomActionSheet.h"
#import "ETShareViewController.h"

@interface ETDetailInfoViewController : ETViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIWebViewDelegate,EKProtocol,MTCustomActionSheetDelegate>
{
    Infomation *info;
    UIScrollView *ScrollView;
    UIWebView *webView;
    MBProgressHUD *HUD;
    UIView  *downview;
    UIButton *button;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UILabel *contentLabel;
    float height;

}

/// 当前资讯信息.
@property(nonatomic,retain)    Infomation *info;
@property(nonatomic,retain)IBOutlet  UIScrollView *ScrollView;
@property(nonatomic,retain)IBOutlet  UIWebView  *webView;
@property(nonatomic,retain)IBOutlet  UIView  *downview;
@end
