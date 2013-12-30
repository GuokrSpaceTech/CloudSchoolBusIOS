//
//  GKWebViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-26.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface GKWebViewController : GKBaseViewController<UIWebViewDelegate>
{
    UIWebView *webController;
}
@property (nonatomic,retain)UIWebView *webController;
@property (nonatomic,retain)NSString *urlstr;
@end
