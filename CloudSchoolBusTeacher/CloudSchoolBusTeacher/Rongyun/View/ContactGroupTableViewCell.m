//
//  ContactGroupTableViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/23.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "ContactGroupTableViewCell.h"
#import "Masonry.h"

@implementation ContactGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *groupIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contact_unselected"]];
        groupIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:groupIcon];
        
        _groupNameLabel = [[UILabel alloc]init];
        _groupNameLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.contentView addSubview:_groupNameLabel];
        
        [groupIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.height.mas_equalTo(@40);
            make.width.mas_equalTo(@40);
        }];
        
        [_groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(groupIcon.mas_right).offset(8);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
