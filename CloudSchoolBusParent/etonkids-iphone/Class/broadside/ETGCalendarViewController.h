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
@interface ETGCalendarViewController : UIViewController<VRGCalendarViewDelegate,EKProtocol>
{
    VRGCalendarView *myCalendar;
    UILabel *inLabel;
    UILabel *outlable;
    
    
    UILabel *tempatureLabel;
    UILabel *tempatureStateLabel;
    UILabel *otherStateLabel;
    
    UILabel *fesLabel;
    
    MyImageView *inImageView;
    MyImageView *outImageView;
    UIImageView *circleImageView4;
    UIImageView *circleImageView3;
    UIImageView *line3;
    UIImageView *line2;
    UILabel *countLabel;
    UILabel *dateLabel;
    
    UIImageView *fesImgV;
    
    UIScrollView *scroller;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)UIScrollView *scroller;
@property (nonatomic, retain) NSMutableArray *attArr;
@property (nonatomic, retain) NSMutableArray *fesArr;
@end
