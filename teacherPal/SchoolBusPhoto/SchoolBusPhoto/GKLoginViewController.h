//
//  GKLoginViewController.h
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
@interface GKLoginViewController : UIViewController<EKProtocol>
@property (retain, nonatomic) IBOutlet UITextField *userName;
@property (retain, nonatomic) IBOutlet UITextField *passWord;

@property (retain, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,retain) IBOutlet UILabel *forgetpass;

//
//@property (retain, nonatomic) IBOutlet UIImageView *remImgV;
//@property (retain, nonatomic) IBOutlet UIImageView *autoImgV;



//
//
//@property (retain, nonatomic) IBOutlet UIButton *remberBt;
//@property (retain, nonatomic) IBOutlet UIButton *forgetBt;
@property (retain, nonatomic) IBOutlet UIImageView *jiaoshiLogin;

- (IBAction)loginBtnClick:(id)sender;



/// 自动登录按钮事件
//-(IBAction)autoLogin:(id)sender;

/// 记住密码按钮事件
//- (IBAction)rember:(UIButton *)sender;


@end
