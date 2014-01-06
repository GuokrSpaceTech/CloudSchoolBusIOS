//
//  ETBackgroundViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETBackgroundViewController
 *  @brief  更换背景界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETCustomAlertView.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"

@interface ETBackgroundViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ETCustomAlertViewDelegate,UIGestureRecognizerDelegate,EKProtocol>

{
    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIImageView *middleView;
    UILabel *middleLabel;
    
    UITableView  *tableview;
    
    MBProgressHUD *HUD;
    
    
    
}
@property(nonatomic,retain)IBOutlet  UITableView *tableview;
@property (nonatomic, retain) UIImage *originImage;

@end
