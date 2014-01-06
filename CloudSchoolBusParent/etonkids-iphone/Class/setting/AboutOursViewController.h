//
//  AboutOursViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   AboutOursViewController
 *  @brief  关于我们界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface AboutOursViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *aboutLogo;
    IBOutlet UIButton *teleButton;
    IBOutlet UIButton *privateBtn;
    IBOutlet UIImageView *aboutBack;
    IBOutlet UILabel *copyrightLab;
    IBOutlet UILabel *engLab;
    IBOutlet UIButton *webBtn;
    IBOutlet UIButton *emailBtn;
    
}

- (IBAction)doCall:(UIButton *)sender;
- (IBAction)doClickGuoKr:(id)sender;
- (IBAction)doClickURL:(id)sender;
- (IBAction)doClickPrivate:(id)sender;


@end
