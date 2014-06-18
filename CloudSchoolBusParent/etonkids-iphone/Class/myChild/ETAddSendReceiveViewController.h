//
//  ETAddSendReceiveViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCustomActionSheet.h"
#import "EKRequest.h"
#import "MBProgressHUD.h"

typedef void (^CompleteBlock)(NSDictionary *dic);
@interface ETAddSendReceiveViewController : UIViewController<MTCustomActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EKProtocol,UIActionSheetDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    CompleteBlock completeBlack;
    
    UIImageView *imagePhoto;
}
@property(nonatomic,copy) CompleteBlock completeBlack;
@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)NSString *base64str;

@property(nonatomic,retain)UIImageView *photoImageView;
-(void)successAddReceiver:(CompleteBlock)black;
@end
