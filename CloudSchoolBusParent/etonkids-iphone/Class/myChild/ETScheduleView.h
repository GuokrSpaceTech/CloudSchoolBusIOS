
/**
 *	@file   ETScheduleView
 *  @brief  课程表页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "keyedArchiver.h"
#import "VRGCalendarView.h"
#import "DutyDayView.h"
#import "ETCustomAlertView.h"
#import "MTCustomActionSheet.h"
#import "ETBoardSideView.h"

@interface ETScheduleView : ETBoardSideView<EKProtocol,VRGCalendarViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,MTCustomActionSheetDelegate>
{
    float distence;
    CGPoint prePoint;
    MBProgressHUD *HUD;
    CGFloat CellHeight;
    NSDate *day;
    
    NSDateFormatter *dateFormat;
    
    UIButton *todayBtn;
}
@property (nonatomic,copy) NSDate *currentday;
@property(nonatomic,retain)NSArray *dataArray;

@property(nonatomic,retain)IBOutlet UIButton *datebutton;

@property(nonatomic,retain)IBOutlet UITableView *tableview;





-(void)selectDate:(int)date;
@end
