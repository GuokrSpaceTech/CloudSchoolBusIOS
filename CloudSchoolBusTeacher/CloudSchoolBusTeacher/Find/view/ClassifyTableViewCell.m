//
//  ClassifyTableViewCell.m
//  CloudBusParent
//
//  Created by mactop on 11/23/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "ClassifyTableViewCell.h"

@implementation ClassifyTableViewCell

@synthesize label = _label;
@synthesize imageIconView = _imageIconView;
- (void)awakeFromNib {
    // Initialization code
    NSLog(@"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
