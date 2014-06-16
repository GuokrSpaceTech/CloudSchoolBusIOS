//
//  ETSendRecevieViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETCustomAlertView.h"
#import "ETSendReceiveView.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"
@interface ETSendRecevieViewController : UIViewController<ETSendReceiveViewDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)UIScrollView *scrollerView_;
@property (nonatomic,retain)NSMutableArray *receiverArr;

@property (nonatomic,retain)GKChildReceiver * wantDelete;
@end
