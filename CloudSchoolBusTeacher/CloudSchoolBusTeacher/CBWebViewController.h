//
//  CBWebViewController.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/23.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface CBWebViewController : UIViewController
@property (nonatomic,strong)UIWebView * webview;
@property (nonatomic,strong)WKWebView * wkWebview;
@property (nonatomic,copy) NSString * urlStr;
@property (nonatomic,copy)NSString * titleStr;
@end
