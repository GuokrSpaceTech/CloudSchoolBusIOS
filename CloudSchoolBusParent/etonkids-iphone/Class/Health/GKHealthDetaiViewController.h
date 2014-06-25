//
//  GKHealthDetaiViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface GKHealthDetaiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
       UITextField *inputField;
        UIView  *inputView;
    MBProgressHUD *HUD;

}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSData * photoImage;
@end
