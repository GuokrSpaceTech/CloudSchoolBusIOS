//
//  ETCalendarViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-12.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "EKRequest.h"
#import "ETCommonClass.h"
#import "MBProgressHUD.h"
#import "MyImageView.h"
@interface ETGCalendarViewController : UIViewController<VRGCalendarViewDelegate,EKProtocol,UITableViewDataSource,UITableViewDelegate>
{
    VRGCalendarView *myCalendar;
//    UILabel *inLabel;
//    UILabel *outlable;
    
    
   // UILabel *tempatureLabel;
   // UILabel *tempatureStateLabel;
    UILabel *otherStateLabel;
    
    UILabel *fesLabel;

    UILabel *countLabel;
    UILabel *dateLabel;
    UILabel *todaycount;
  
    UIImageView *fesImgV;
    


    MBProgressHUD *HUD;
}
//@property (nonatomic,retain)UIScrollView *scroller;
@property (nonatomic, retain) NSMutableArray *attArr;
@property (nonatomic, retain) NSMutableArray *fesArr;

@property (nonatomic,retain)NSString *festvStr;
@property (nonatomic,retain)NSString *currentDateStr;

@property (nonatomic,retain)UITableView *_tableView;

@property (nonatomic,retain)NSMutableArray *dateList;
@end
