//
//  GKNoticeViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-15.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKMainViewController.h"
#import "GKUserLogin.h"
#import "GKStudentView.h"
#import "EKRequest.h"
#import "GTMBase64.h"
@interface GKNoticeViewController : GKBaseViewController<UITextViewDelegate,studentViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EKProtocol>
{
    UITextView *_textView;
    
    UIView *inputView;
    GKStudentView *studentView;
    UIImageView *selectImageView;
    
    UILabel *numberWord;
    
}
@property(nonatomic,retain)UITextView *_textView;

@property(nonatomic,retain)NSMutableArray *stuArr;
@property (nonatomic,retain)NSData *upData;
@end
