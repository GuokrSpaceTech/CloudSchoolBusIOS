//
//  ETSettingView.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-26.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "ETKids.h"
#import "ETNicknameViewController.h"
#import "CustomActionSheet.h"
#import "MTCustomActionSheet.h"
#import "ETBoardSideView.h"

@interface ETSettingView : ETBoardSideView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,EKProtocol,ETNicknameViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomActionSheetDelegate,MTCustomActionSheetDelegate,ETCustomAlertViewDelegate>
{
    UILabel *nicknamelabel;
    UILabel *genderlabel;
    UILabel *birthdaylabel;
    UIDatePicker *datepick;
    RequestType reqType;
    
    UISwitch *secure;
    
}

@property (nonatomic, retain)UITableView *mainTV;
@property (nonatomic, retain) UIImageView *imageViewHead;
@property (nonatomic, retain) NSString *mutiOnline;

@property (nonatomic, retain) NSMutableArray *requestArray;

@end
