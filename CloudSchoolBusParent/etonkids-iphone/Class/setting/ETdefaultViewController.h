//
//  ETdefaultViewController.h
//  etonkids-iphone
//
//  Created by Simon on 13-8-2.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETdefaultViewController
 *  @brief  更换指定系统背景界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETCustomAlertView.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"

@interface ETdefaultViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,EKProtocol>
{
    UIImage *image;
    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIImageView *middleView;
    UILabel *middleLabel;
    UIButton  *button1;
    CGFloat width;
    UIScrollView  *scrollview;
    
    UIImageView *mark;
    
    MBProgressHUD *HUD;
    
}
@property(nonatomic,retain)UIImage *image;
@end
