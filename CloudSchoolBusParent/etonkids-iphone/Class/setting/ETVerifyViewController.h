//
//  ETVerifyViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-29.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "MBProgressHUD.h"

@interface ETVerifyViewController : UIViewController<EKProtocol>
{
    
    IBOutlet UILabel *tishiLabel;
    IBOutlet UITextField *verifyTF;
    IBOutlet UIButton *nextButton;
    IBOutlet UILabel *countdownLab;
    
    IBOutlet UIButton *sendAgain;
    int countTime;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain)NSString *key;
@property (nonatomic, retain)NSString *mobile;
@property (nonatomic, retain)NSTimer *timer;

@property (nonatomic, assign)BOOL isChangeBind;
@property (nonatomic, assign)BOOL isForgetPwd;

- (IBAction)doNext:(id)sender;

- (IBAction)doSendAgain:(id)sender;

@end
