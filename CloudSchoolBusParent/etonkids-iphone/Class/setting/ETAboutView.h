//
//  ETAboutView.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-27.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBoardSideView.h"
#import "ETCustomAlertView.h"

@interface ETAboutView : ETBoardSideView <ETCustomAlertViewDelegate>
{
    
    IBOutlet UIImageView *aboutLogo;
    IBOutlet UIButton *teleButton;
    IBOutlet UIButton *privateBtn;
}

- (IBAction)doCall:(id)sender;
- (IBAction)doClickURL:(id)sender;
- (IBAction)doClickGuoKr:(id)sender;
- (IBAction)doClickPrivate:(id)sender;


@end
