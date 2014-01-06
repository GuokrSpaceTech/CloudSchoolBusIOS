//
//  ETVerifyPasswordViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-29.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "ETCustomAlertView.h"
#import "MBProgressHUD.h"

@interface ETVerifyPasswordViewController : UIViewController<EKProtocol>
{
    
    IBOutlet UITextField *newPwdTF;
    IBOutlet UITextField *confirmPwdTF;
    
    MBProgressHUD *HUD;


    IBOutlet UIButton *sendBtn;
    IBOutlet UILabel *tishiLabel;
}
@property (nonatomic, retain)NSString *navigationTitle;

@property (nonatomic, retain)NSString *verifyCode;
@property (nonatomic, retain)NSString *mobile;

- (IBAction)doSend:(id)sender;
@end
