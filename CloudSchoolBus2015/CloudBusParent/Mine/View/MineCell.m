//
//  MineCell.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/17.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "MineCell.h"
#import "Masonry.h"
#import "CB.h"
@implementation MineCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_detailLabel];
        
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = RGBACOLOR(200, 199, 204, 1);
        [self.contentView addSubview:line];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(5);;
            make.centerY.equalTo(_iconImageView.mas_centerY);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-5);;
            make.centerY.equalTo(_iconImageView.mas_centerY);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            make.height.mas_equalTo(@(1));
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
    return self;
}
@end
