//
//  ETCalendarViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-23.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "EKRequest.h"
#import "ETCommonClass.h"

@interface ETCalendarViewController : UIViewController<VRGCalendarViewDelegate,EKProtocol>
{
    VRGCalendarView *myCalendar;
    UILabel *attLabel;
    UILabel *fesLabel;
    
    UILabel *countLabel;
    UILabel *dateLabel;
    
    UIImageView *fesImgV;
}


@property (nonatomic, retain) NSMutableArray *attArr;
@property (nonatomic, retain) NSMutableArray *fesArr;


@end
