//
//  GKLetterViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "GKLetterCell.h"
//#import "UIImage+GKImage.h"
#import "Letter.h"
#import "GKMainViewController.h"
#import "SRRefreshView.h"
#import "MBProgressHUD.h"
@interface GKLetterViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,EKProtocol,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,SRRefreshDelegate,letterCellDelegate>
{
    UITableView *_tableView;
    
    UITextField *inputField;
    UIView  *inputView;
    MBProgressHUD *HUD;
 
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableArray *dataArr;

@property (nonatomic, retain)SRRefreshView   *_slimeView;
@end
