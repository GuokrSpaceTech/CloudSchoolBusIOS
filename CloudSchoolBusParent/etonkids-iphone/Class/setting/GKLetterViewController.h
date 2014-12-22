//
//  GKLetterViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-12-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EKRequest.h"
#import "GKLetterCell.h"
//#import "UIImage+GKImage.h"
#import "Letter.h"
#import "GKContactObj.h"
#import "SRRefreshView.h"
#import "MBProgressHUD.h"
#import "GKContactObj.h"
@interface GKLetterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SRRefreshDelegate,EKProtocol,letterCellDelegate>
{
    UITextField *inputField;
    UIView  *inputView;
    MBProgressHUD *HUD;
    
}

@property (nonatomic,retain)UITableView *_tableView;
//@property (nonatomic,retain)NSData * photoImage;
@property (nonatomic,retain)NSMutableArray *dataArr;;
@property (nonatomic,retain)GKContactObj *contactObj;
@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end
