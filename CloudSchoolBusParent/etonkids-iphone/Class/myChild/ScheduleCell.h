//
//  ScheduleCell.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-3.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ScheduleCell
 *  @brief  自定义课程表cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell<UITextViewDelegate>
{
    UILabel  *LeftTime;
    UIImageView  *LineImageView;
    UILabel   *LeftTextView;
    UITextView  *RightTextView;
    
}

@property(nonatomic,retain)IBOutlet  UILabel   *timeLabel;
@property(nonatomic,retain)IBOutlet  UILabel   *courseLabel;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIView *leftView;

@end
