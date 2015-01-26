
/**
 *	@file   ETCalendarView
 *  @brief  考勤页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "DutyDayView.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "keyedArchiver.h"
#import "ETCustomAlertView.h"

@interface ETCalendarView : UIView <VRGCalendarViewDelegate,EKProtocol>
{
    float distence;
    CGPoint prePoint;
    MBProgressHUD *HUD;
    DutyDayView *dutyView;
    VRGCalendarView * calendar;
    UILabel *sumLabel;
    
    NSInteger reqMonth;
}

@property(nonatomic,retain)NSMutableArray *listArr;

/// 第三方日历类.
@property(nonatomic,retain)VRGCalendarView * calendar;
@property(nonatomic, retain) NSMutableArray *schoolArr;
@property(nonatomic, retain)NSDictionary *calendarDic;

@end
