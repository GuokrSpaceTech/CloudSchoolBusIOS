//
//  CBTeacherTableViewCell.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBTeacherTableViewCell.h"
#import "Masonry.h"
#import "CB.h"

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
        
        _timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLabel];
        
        
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = RGBACOLOR(200, 199, 204, 1);
        [self.contentView addSubview:line];
        
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
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(_avatarImageView.mas_bottom);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageView.mas_bottom).offset(9);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@(1));
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
    

   // [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
    return self;
}

-(void)setTeacher:(Teacher *)teacher
{
    _teacher = teacher;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] placeholderImage:nil];
    _nameLabel.text = teacher.name;
    _classNameLabel.text = teacher.className;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
