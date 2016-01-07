//
//  PhotoViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "PhotoViewCell.h"
#import "Masonry.h"
@implementation PhotoViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self  = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor redColor];
      
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.layer.borderWidth=1;
        _photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:_photoImageView];
        
        _selectIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked"]];
        [self.contentView addSubview:_selectIamgeView];
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        }];
        
        
        [_selectIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.width.height.mas_offset(@(20));
        }];
        
        _selectIamgeView.hidden = YES;
    }
    return self;
}
@end
