//
//  GKHealthDetaiViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CYProblem.h"
#import "CYDoctor.h"
#import "SRRefreshView.h"
#import "CYDetailCell.h"
@interface GKHealthDetaiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SRRefreshDelegate,DetailCellDelegate>
{
       UITextField *inputField;
        UIView  *inputView;
    MBProgressHUD *HUD;

}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSData * photoImage;
@property (nonatomic,retain) CYProblem *problem;
@property (nonatomic,retain)NSMutableArray *answerList;
@property (nonatomic,retain) CYDoctor *doctor;

@property (nonatomic, retain)SRRefreshView   *_slimeView;

@end
