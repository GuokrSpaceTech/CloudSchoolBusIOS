//
//  CBTeacherTableViewCell.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"
@interface CBTeacherTableViewCell : UITableViewCell
{
    UIButton * noReadBtn;
}
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong) UILabel *classNameLabel;

@property (nonatomic,strong) Teacher *teacher;


@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end
