//
//  ETForgetPasswordViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-21.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETForgetPasswordViewController
 *  @brief  忘记密码界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETKids.h"
#import "NetWork.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MTAuthCode.h"
#import "UserLogin.h"
#import "EKRequest.h"

@interface ETForgetPasswordViewController : UIViewController<EKProtocol,UITextFieldDelegate,ETCustomAlertViewDelegate>
{
    
    IBOutlet UITextField *telephoneTF;

    IBOutlet UILabel *tishiLab;

    IBOutlet UIButton *nextBtn;
    
    MBProgressHUD *HUD;
    
    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIImageView *middleView;
    UILabel *middleLabel;
    
    IBOutlet UIButton *serviceBtn;
    IBOutlet UILabel *phonelabel;
    IBOutlet UITextField *verifyTF;
    IBOutlet UIButton *getVerifyBtn;
    int countTime;
    
    IBOutlet UILabel *messageAlert;
    IBOutlet UILabel *tishiVerify;
}

@property (nonatomic, assign) BOOL isBind;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString *key;

- (IBAction)doNext:(id)sender;
- (IBAction)callService:(id)sender;
- (IBAction)getVerify:(id)sender;

@end
