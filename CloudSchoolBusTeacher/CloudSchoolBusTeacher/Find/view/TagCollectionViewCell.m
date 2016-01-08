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
    _tagLabel.layer.cornerRadius = 12;
}

@end
