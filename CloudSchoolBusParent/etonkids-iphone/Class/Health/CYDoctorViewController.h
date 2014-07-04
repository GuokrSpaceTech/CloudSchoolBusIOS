//
//  CYDoctorViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-2.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYDoctor.h"
#import "MBProgressHUD.h"

@interface CYDoctorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    
    UIView *tableViewHeaderView;
}
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain) CYDoctor *doctor;
@property (nonatomic,retain) NSArray *tuijianArr;
@property (nonatomic,retain) NSArray *renzhenArr;
@end
