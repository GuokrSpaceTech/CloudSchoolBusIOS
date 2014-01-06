//
//  ETFeedbackView.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-27.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "ETCustomAlertView.h"
#import "ETBoardSideView.h"
#import "MBProgressHUD.h"

@interface ETFeedbackView : ETBoardSideView <EKProtocol,UITextViewDelegate>
{
    UITextView *feedbackTV;
    MBProgressHUD *HUD;
}

@end
