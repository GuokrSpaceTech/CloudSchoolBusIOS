//
//  FindCellTopView.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "FindCellTopView.h"
#import "Masonry.h"
@implementation FindCellTopView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initUI];
    }
    return self;
}
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
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.layer.cornerRadius = 20;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:_avatarImageView];
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    _classNamelabel = [[UILabel alloc]init];
    _classNamelabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_classNamelabel];
    _classNamelabel.backgroundColor = [UIColor clearColor];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLabel];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.font = [UIFont systemFontOfSize:14];
    _typeLabel.backgroundColor = [UIColor clearColor];
   
    [self addSubview:_typeLabel];
    

}
-(void)updateConstraints
{
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(@(40));
        make.height.mas_equalTo(@(40));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        //make.top.equalTo(_avatarImageView.mas_top).offset(5);;
        make.centerY.equalTo(_avatarImageView.mas_centerY);
        
    }];
    
    [_classNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.greaterThanOrEqualTo(_classNamelabel.mas_right).offset(20);;
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.right.equalTo(_typeLabel.mas_left).offset(-20);;
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_classNamelabel.mas_top);
    }];
    [super updateConstraints];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
