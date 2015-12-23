//
//  CBTeacherTableViewCell.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBTeacherTableViewCell.h"
#import "CBLoginInfo.h"
#import "Parents.h"
#import "Teacher.h"
#import "ClassObj.h"
#import "Masonry.h"
#import "CB.h"
#import "Calculate.h"
#import "UIImageView+WebCache.h"
@implementation CBTeacherTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_nameLabel];
        
        _classNameLabel = [[UILabel alloc]init];
        _classNameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_classNameLabel];
        
        _contentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_contentLabel];
    
        _timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLabel];
        
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = RGBACOLOR(200, 199, 204, 1);
        [self.contentView addSubview:line];
        
        noReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noReadBtn setBackgroundImage:[UIImage imageNamed:@"Message_red"] forState:UIControlStateNormal];
        [noReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [noReadBtn setTitle:@"10" forState:UIControlStateNormal];
        noReadBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:noReadBtn];
        
        //Adding constrains
        [noReadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(@17);
            make.height.mas_equalTo(@17);
        }];
        
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(50.0f, 50.f));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(10);
            make.top.equalTo(_avatarImageView.mas_top);
        }];
        
        [_classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(10);
            make.bottom.equalTo(_avatarImageView.mas_bottom);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_classNameLabel.mas_right).offset(5);
            make.top.equalTo(_avatarImageView.mas_bottom).offset(5);
        }];
       
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(_contentLabel.mas_top);
            make.left.greaterThanOrEqualTo(_contentLabel.mas_right).offset(10);;
            make.width.mas_greaterThanOrEqualTo(@100);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(_avatarImageView.mas_bottom).offset(9);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@(1));
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
    
    // [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
    return self;
}

-(void)setContact:(id)contact
{
    NSString *classname;
    NSString *contactName;
    NSString *timestampStr;
    NSString *lastIMContent;
    int       unreadCnt;
    NSString *avatarStr;
    
    _contact = contact;
    //家长联系人
    if([_contact isKindOfClass:[Parents class]])
    {
        Parents *parents = _contact;
        contactName = parents.nickname;
        
        //获取班级名称
        for(ClassObj *classinfo in [[CBLoginInfo shareInstance] classArr])
        {
            if([classinfo.classid isEqualToString:_classid])
            {
                classname = classinfo.className;
            }
        }
        
        timestampStr = [Calculate dateFromTimeStamp:[parents.latestTime intValue]];
        lastIMContent = parents.contentlatest;
        unreadCnt = parents.noReadCount;
        avatarStr = parents.avatar;
    }
    //教师联系人
    else
    {
        Teacher *teacher = _contact;
        contactName = teacher.nickname;
        classname = teacher.className;
        timestampStr = [Calculate dateFromTimeStamp:[teacher.latestTime intValue]];
        lastIMContent = teacher.contentlatest;
        unreadCnt = teacher.noReadCount;
        avatarStr = teacher.avatar;
    }
    
    // Set up the UI
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:nil];
    _nameLabel.text = contactName;
    _classNameLabel.text = classname;
    _timeLabel.text = timestampStr;
    _contentLabel.text = lastIMContent;
    if(unreadCnt == 0)
    {
        noReadBtn.hidden = YES;
    }
    else
    {
        noReadBtn.hidden = NO;
        [noReadBtn setTitle:[NSString stringWithFormat:@"%@",@(unreadCnt)] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
