//
//  FindCellTopView.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "FindCellTopView.h"
#import "Masonry.h"
#import "UIColor+RCColor.h"
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
    _avatarImageView.layer.cornerRadius = 34;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:_avatarImageView];
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    _classNamelabel = [[UILabel alloc]init];
    _classNamelabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_classNamelabel];
    _classNamelabel.backgroundColor = [UIColor clearColor];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    _typeLabelContainer = [[UIView alloc] init];
    _typeLabelContainer.backgroundColor = [UIColor colorWithHexString:@"#F3A139" alpha:1.0f];
    [[_typeLabelContainer layer] setCornerRadius:5.0f];
    [self addSubview:_typeLabelContainer];
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.font = [UIFont systemFontOfSize:14];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
   
    [_typeLabelContainer addSubview:_typeLabel];
    

}
-(void)updateConstraints
{
    //Left
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.mas_equalTo(@(68));
        make.height.mas_equalTo(@(68));
    }];
    
    //Top Right
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(20);
        //make.top.equalTo(_avatarImageView.mas_top).offset(5);;
        make.top.equalTo(_avatarImageView.mas_top);
    }];
    
    //Bottom Right Horizontally 3 labels
    [_classNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(20);
        make.top.equalTo(_nameLabel.mas_bottom).offset(20);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.greaterThanOrEqualTo(_classNamelabel.mas_right).offset(20);;
        make.top.equalTo(_classNamelabel.mas_top);
        make.left.equalTo(_classNamelabel.mas_right).offset(20);
    }];

    [_typeLabelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_classNamelabel.mas_top);
        make.left.equalTo(_timeLabel.mas_right).offset(20);
    }];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 5, 0, 5);
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_typeLabelContainer).with.insets(padding);
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
