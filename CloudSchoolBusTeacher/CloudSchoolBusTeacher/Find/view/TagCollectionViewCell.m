//
//  TagCollectionViewCell.m
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/14/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _tagLabel.clipsToBounds = YES;
    _tagLabel.layer.cornerRadius = 4;
    _tagLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    _tagLabel.layer.borderWidth = 1;
    _tagLabel.textColor = [UIColor whiteColor];
}

@end
