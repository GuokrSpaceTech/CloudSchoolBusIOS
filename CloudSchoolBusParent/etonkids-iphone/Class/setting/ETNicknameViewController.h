//
//  ETNicknameViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//


/**
 *	@file   ETNicknameViewController
 *  @brief  修改昵称界面.
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ETCustomAlertView.h"

@protocol ETNicknameViewControllerDelegate <NSObject>
@optional
- (void)changeNicknameSuccess;

@end


@interface ETNicknameViewController : UIViewController<UITextFieldDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIImageView *middleView;
    UILabel *middleLabel;
    UIButton *rightButton;
    MBProgressHUD *HUD;
    
    IBOutlet UIButton *clearBtn;
    IBOutlet UILabel *calculateLabel;
    IBOutlet UIImageView *textfieldImgBack;
    

    
}
@property (nonatomic, retain) IBOutlet UITextField *nicknametextfield;
@property (nonatomic, assign) id<ETNicknameViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *originName;

- (IBAction)clearText:(id)sender;

@end
