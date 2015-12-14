//
//  AlbumViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "AlbumViewCell.h"
#import "Masonry.h"
@implementation AlbumViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _photoImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_photoImageView];
        
        _albumNameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_albumNameLabel];
        
        
        UIImageView * lineImageView = [[UIImageView alloc]init];
        lineImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineImageView];
        
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
            make.width.mas_equalTo(@(50));
        }];
        
        [_albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_photoImageView.mas_centerY);
            make.left.equalTo(_photoImageView.mas_right).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
        
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@(1));
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
