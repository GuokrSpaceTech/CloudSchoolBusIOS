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
@protocol writeHealthVCdelegate;
@interface GKWriteHealthViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,ETCustomAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{

    UIButton * deleteImageView;
    UIImageView *photoImageView;
    UIScrollView *_scroller;
    
    int keshinumber;
    
    MBProgressHUD *HUD;
}

@property (nonatomic,retain)UITableView * tableView;
//@property (nonatomic,retain)NSArray * labelArr;
@property (nonatomic,assign)id<writeHealthVCdelegate>delegate;
@property (nonatomic,retain)NSData * photoImage;
@property (nonatomic,retain) UITextView * _textView;
@property (nonatomic,retain)NSString *sex;
@property (nonatomic,assign)NSString *keshi;
@property (nonatomic,retain)NSString *age;
@property (nonatomic,retain) UITextField * _textField;
@property (nonatomic,retain) UILabel * keshilabel;
@property (nonatomic,retain)UILabel *sexLabel;
@end


@protocol writeHealthVCdelegate <NSObject>

-(void)refreshDetailVC;

@end
