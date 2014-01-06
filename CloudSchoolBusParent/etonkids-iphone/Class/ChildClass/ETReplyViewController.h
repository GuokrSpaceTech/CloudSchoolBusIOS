//
//  ETReplyViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-8-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ShareContent.h"
@interface ETReplyViewController : UIViewController<UITextViewDelegate,EKProtocol>
{
UIImageView *navigationBackView;
UIButton *leftButton;
UIImageView *middleView;
UILabel *middleLabel;
UIButton *rightButton;
MBProgressHUD *HUD;
NSString *string;
}
@property (retain, nonatomic) IBOutlet UITextView *textview;
@property(retain,nonatomic)ShareContent *sharecontent;
@property(retain,nonatomic)NSString *string;
@end
