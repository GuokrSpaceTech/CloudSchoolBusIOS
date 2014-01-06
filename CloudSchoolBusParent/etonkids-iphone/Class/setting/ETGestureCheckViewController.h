//
//  ETGestureCheckViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETLockView.h"
#import "ETCustomAlertView.h"
#import "EKRequest.h"

@interface ETGestureCheckViewController : UIViewController<LockDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    UILabel *tLabel;
    int num;
}

@end
