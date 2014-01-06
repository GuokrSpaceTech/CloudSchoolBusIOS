//
//  ETBottomViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETKids.h"
#import "ETNoticeViewController.h"
#import "ActivityViewController.h"
#import "ETActiveViewController.h"
#import "ETInformationViewController.h"
#import "ETClassViewController.h"
#import "LeveyTabBarController.h"
#import "ETCoreDataManager.h"
#import "ETCustomAlertView.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"

typedef enum
{
    ZeroMargin,
    RightMargin,
}MainStatus;


@interface ETBottomViewController : UIViewController<UIGestureRecognizerDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    CGPoint beginPoint;
    
    UIPanGestureRecognizer *pan;
    UISwipeGestureRecognizer *swipe;
    UISwipeGestureRecognizer *swipe1;
    
    MBProgressHUD *HUD;
    
}

@property (nonatomic, retain) LeveyTabBarController *leveyTBC;
@property (nonatomic, retain) UIView *topView;

- (void)showDefaultController;

@end
