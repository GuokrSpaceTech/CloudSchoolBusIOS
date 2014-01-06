
/**
 *	@file   DutyDayView
 *  @brief  出勤信息view
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>

@interface DutyDayView : UIView
{
    UILabel *dayLabel;
    UILabel *dutyStatus;
    
}
@property(nonatomic,retain) UILabel *dayLabel;
@property(nonatomic,retain) UILabel *dutyStatus;
@property (nonatomic, retain) UILabel *festivalLabel;

@end
