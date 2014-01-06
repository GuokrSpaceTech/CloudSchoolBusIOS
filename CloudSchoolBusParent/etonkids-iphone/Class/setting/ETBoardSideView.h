//
//  ETBoardSideView.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-17.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETBoardSideView : UIView<UIGestureRecognizerDelegate>
{
    UILabel *middleLabel;
    UIImageView *navigationBackView;
    CGPoint beginPoint;
    UIButton *leftButton;
}

@end
