//
//  GKRePasswordViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-18.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"

#import "EKRequest.h"


@protocol GKRePasswordViewControllerDelegate <NSObject>

-(void)loginout;

@end

@interface GKRePasswordViewController : GKBaseViewController<UITextFieldDelegate,EKProtocol,UIAlertViewDelegate>
@property (nonatomic,retain)UITextField *oldPassword;
@property (nonatomic,retain)UITextField *PasswordNew;
@property (nonatomic,retain)UITextField *PasswordNewCon;

@property (nonatomic,assign)id<GKRePasswordViewControllerDelegate>delegate;
@end

