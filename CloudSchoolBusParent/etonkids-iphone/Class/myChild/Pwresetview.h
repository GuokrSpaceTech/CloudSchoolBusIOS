//
//  Pwresetview.h
//  etonkids-iphone
//
//  Created by Simon on 13-8-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface Pwresetview : UIView<UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,EKProtocol>
{
    UITextView *textview;
    CGFloat height;
    MBProgressHUD *HUD;
    
}
@property(nonatomic,retain)IBOutlet UITextView *textview;
@property(nonatomic,retain)IBOutlet UITextField *logTextfield;
@property(nonatomic,retain)IBOutlet UITextField *StudentTextfield;
@property(nonatomic,retain)IBOutlet UIImageView *imageview;
@property(nonatomic,retain)IBOutlet UILabel *logLabel;
@property(nonatomic,retain)IBOutlet UILabel *StudentLabel;
@property(nonatomic,retain)IBOutlet UIButton  *canclebutton;
@property(nonatomic,retain)IBOutlet  UIButton  *okbutton;
@end
