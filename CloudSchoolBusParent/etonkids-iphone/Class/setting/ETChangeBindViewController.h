//
//  ETChangeBindViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETCustomAlertView.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"

@interface ETChangeBindViewController : UIViewController<ETCustomAlertViewDelegate,EKProtocol,UITextFieldDelegate>
{
    
    IBOutlet UILabel *tishiLabel1;
    IBOutlet UILabel *tishiLabel2;
    IBOutlet UILabel *tishiLabel3;
    IBOutlet UITextField *oldMobileTF;
    IBOutlet UITextField *newMobileTF;
    IBOutlet UIButton *nextBtn;
    
    MBProgressHUD *HUD;
    IBOutlet UIButton *getVerifyBtn;
    IBOutlet UITextField *verifyTF;
    
    IBOutlet UILabel *tishiVerify;
    int countTime;
}
@property (nonatomic, retain)NSString *key;
@property (nonatomic, retain)NSString *mobile;
@property (nonatomic, retain)NSTimer *timer;

//@property (nonatomic, retain)UIViewController *popToVC;
- (IBAction)getVerify:(id)sender;

- (IBAction)doNext:(id)sender;
@end
