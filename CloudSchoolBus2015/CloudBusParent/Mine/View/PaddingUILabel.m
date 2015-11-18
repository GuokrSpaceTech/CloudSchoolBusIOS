//
//  PaddingUILabel.m
//  CloudBusParent
//
//  Created by mactop on 11/18/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "PaddingUILabel.h"

@implementation PaddingUILabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {10, 10, 10, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
