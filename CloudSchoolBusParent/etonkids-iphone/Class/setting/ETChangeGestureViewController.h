//
//  ETChangeGestureViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETLockView.h"
#import "ETCustomAlertView.h"

@interface ETChangeGestureViewController : UIViewController<LockDelegate,ETCustomAlertViewDelegate>
{
    
    UILabel *tLabel;
}

@property (nonatomic, retain)NSString *firstPwd;

@end
