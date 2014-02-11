//
//  GKNoticeViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-15.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"

#import "GKUserLogin.h"
#import "GKStudentView.h"
#import "EKRequest.h"
#import "GTMBase64.h"
@interface GKNoticeViewController : GKBaseViewController<UITextViewDelegate,studentViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EKProtocol,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextView *_textView;
    
    UIView *inputView;
    GKStudentView *studentView;
    UIImageView *selectImageView;
    
    UILabel *numberWord;
    
}
@property (nonatomic,assign)BOOL isConform;
@property(nonatomic,retain)UITextView *_textView;
@property (nonatomic,retain)UITextField *_titleField;
@property(nonatomic,retain)NSMutableArray *stuArr;
@property (nonatomic,retain)NSData *upData;
@end
