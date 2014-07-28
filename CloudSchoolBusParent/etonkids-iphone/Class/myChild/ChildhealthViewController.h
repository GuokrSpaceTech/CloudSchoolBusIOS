//
//  ChildhealthViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-28.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"

#import "MBProgressHUD.h"
@interface ChildhealthViewController : UIViewController<UITextFieldDelegate,EKProtocol>
{
    UITextField * healthField;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)  UITextField * healthField;
@property (nonatomic,retain) NSString *healthState;
@end
