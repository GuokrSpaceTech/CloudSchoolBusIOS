//
//  UIScrollView+UITouchEvent.m
//  SchoolBusParents
//
//  Created by wen peifang on 13-8-12.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}


@end
