//
//  GKImagePickerViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-22.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ETPhotoCell.h"
#import "GKMainViewController.h"

#import "GKBaseViewController.h"
#import "GKShowViewController.h"
//#import "GKBadgeView.h"
//#import "GKUserLogin.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KKNavigationController.h"
@interface GKImagePickerViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,photoCellDelegate,showViewController>
{
    NSMutableArray *imageArr;
    
   // GKUserLogin *usr;
    UITableView *_tableView;
    
    //GKBadgeView *badgeView;
}
@property(nonatomic,retain)ALAssetsGroup *group_;
@property (nonatomic,retain)NSMutableArray *selectArr;
@property (nonatomic,retain)NSMutableArray *imageArr;
@property (nonatomic,retain) UILabel *countLabel;
//@property (nonatomic, retain)SRRefreshView   *_slimeView;
//@property (nonatomic,retain)ALAssetsLibrary *libery;
@end
