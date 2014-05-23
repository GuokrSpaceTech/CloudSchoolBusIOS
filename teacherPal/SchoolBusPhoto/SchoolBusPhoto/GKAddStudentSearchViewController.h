//
//  GKAddStudentViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-4-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"

@interface GKAddStudentSearchViewController : GKBaseViewController<UITextFieldDelegate,EKProtocol>
{
    UITextField *nameField;
    UITextField *telField;
    
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)UITextField *nameField;
@property(nonatomic,retain)UITextField *telField;
@end
