//
//  GKStudentInfoViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "GKBaseViewController.h"
#import "ETNicknameViewController.h"
#import "EKRequest.h"
#import "MTCustomActionSheet.h"
@interface GKStudentInfoViewController : GKBaseViewController<UITableViewDataSource,UITableViewDelegate,ETNicknameViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EKProtocol,MTCustomActionSheetDelegate>

@property (nonatomic,retain)Student *st;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSArray *arr;

@property (nonatomic,retain)NSString *tempSexOrBirthday;// 要修改为的生日或性别
@end
