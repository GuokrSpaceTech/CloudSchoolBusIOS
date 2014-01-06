

/**
 *	@file   ControllerTopView
 *  @brief  我的宝宝、班级分享、通知消息页面顶部学生信息栏
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETCustomAlertView.h"

@interface ControllerTopView : UIView<UIGestureRecognizerDelegate,UIActionSheetDelegate,ETCustomAlertViewDelegate>
{
    UIImageView *photoImageView;
    UILabel *nameLabel;
    UILabel *englishNameLabel;
    UILabel *classLabel;
    UILabel *ageLabel;
    UILabel  *schoolLabel;
    
}

/// 头像.
@property(nonatomic,retain)UIImageView *photoImageView;

/// 姓名.
@property(nonatomic,retain)UILabel *nameLabel;

/// 英文名.
@property(nonatomic,retain)  UILabel *englishNameLabel;

/// 班级.
@property(nonatomic,retain)UILabel *classLabel;

/// 年龄.
@property(nonatomic,retain)UILabel *ageLabel;

/// 学校.
@property(nonatomic,retain)UILabel *schoolLabel;


/// 背景.
@property(nonatomic,retain) UIImageView *topImageView;
@end
