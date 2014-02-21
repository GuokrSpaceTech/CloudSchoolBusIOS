//
//  GKAboutViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-25.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKMainViewController.h"
#import <MessageUI/MessageUI.h>
@interface GKAboutViewController : GKBaseViewController<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;

@property (retain, nonatomic) IBOutlet UIView *BGView;
    @property (retain, nonatomic) IBOutlet UIButton *privaty;
//@property (retain, nonatomic) IBOutlet UIImageView *aboutLogo;
- (IBAction)photoClick:(id)sender;
- (IBAction)webClick:(id)sender;
- (IBAction)screctClick:(id)sender;

- (IBAction)emailClick:(id)sender;
@end
