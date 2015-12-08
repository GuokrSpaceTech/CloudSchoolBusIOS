//
//  MineHeaderView.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/13.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "MineHeaderView.h"
#import "Masonry.h"
#import "UIColor+RCColor.h"

@implementation MineHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    
    _schoolLabel = [[PaddingUILabel alloc]init];
    [self addSubview:_schoolLabel];
    
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.mas_equalTo(@(100));
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        // make.height.mas_equalTo(@(80));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(_avatarImageView.mas_centerY).offset(-10);
        
        
    }];
    
    [_schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(20);
//        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        
        
    }];

}
@end
