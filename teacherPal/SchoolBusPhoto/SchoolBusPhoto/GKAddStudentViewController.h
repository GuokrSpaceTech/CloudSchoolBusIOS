//
//  GKAddStudentViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "EKRequest.h"
#import "MTCustomActionSheet.h"
#import "MBProgressHUD.h"
@interface GKAddStudentViewController : GKBaseViewController<EKProtocol,UITextFieldDelegate,UIActionSheetDelegate,MTCustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imageView;
    UIImageView *imagePhoto;
    UIView *contentView;
    NSArray *shipArr;
    MBProgressHUD *HUD;
    int sex;
    
    
}
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSData *imagedata;
@property (nonatomic,retain)NSString *tel;

@property(nonatomic,retain)UITextField *nameField;
@property (nonatomic,retain)UITextField *nickNameField;
@property (nonatomic,retain)UITextField *telField;

@property (nonatomic,retain)NSArray *shipArr;
@property(nonatomic,retain)UILabel *sexlabel;
@property (nonatomic,retain)NSString *photoString;
@end
