//
//  PaddingUILabel.m
//  CloudBusParent
//
//  Created by mactop on 11/18/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "PaddingUILabel.h"
#import "UIColor+RCColor.h"

@implementation PaddingUILabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {10, 10, 10, 10};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}

- (void)adjustSize {
    
    if (self.text == nil) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 0);
        return;
    }
    
    CGRect newRect = [self.text
                        boundingRectWithSize:CGSizeMake(200, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]}
                        context:nil];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newRect.size.width + 10, newRect.size.height + 10);
}

@end
