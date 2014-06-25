//
//  GKWriteHealthViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-23.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ETCustomAlertView.h"
@interface GKWriteHealthViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ETCustomAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UITextView * _textView;
      UITextField * _textField;
    UIButton * deleteImageView;
    UIImageView *photoImageView;
    UIButton *downBtn;
    
    int keshinumber;
    
    MBProgressHUD *HUD;
}

@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain)NSArray * labelArr;
@property (nonatomic,retain)NSData * photoImage;

@property (nonatomic,retain)NSString *sex;
@property (nonatomic,assign)NSString *keshi;
@property (nonatomic,retain)NSString *age;

@end
