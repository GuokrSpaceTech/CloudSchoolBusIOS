//
//  OperationCollectionViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/22.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "OperationCollectionViewCell.h"

@implementation OperationCollectionViewCell

- (void)awakeFromNib {    
    // Initialization code

}

-(void)setModule:(ClassModule *)module
{
    _module = module;
    if(_module)
    {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_module.icon] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        _itemTitleLabel.text = _module.title;
    }
}
@end
