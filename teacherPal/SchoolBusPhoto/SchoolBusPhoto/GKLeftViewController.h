//
//  GKLeftViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
#import "GKImagePickerViewController.h"
#import "GKBadgeView.h"
#import "GKUserLogin.h"
#import "GKSettingViewController.h"
@interface GKLeftViewController : UIViewController<UIAlertViewDelegate,settingViewDelegate>
{

        GKBadgeView *badgeView;
    NSArray *arr;
    NSInteger _selectIdnex;
    GKUserLogin * usr;
    UIScrollView *scroller;
    NSInteger totle;
    
}


@property (nonatomic,assign)id<SideBarSelectDelegate>delegate;
//@property (nonatomic,retain)NSArray *arr;
@end
