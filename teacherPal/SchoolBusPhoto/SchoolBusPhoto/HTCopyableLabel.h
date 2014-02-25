//
//  HTCopyableLabel.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCopyableLabel;

@protocol HTCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HTCopyableLabel *)copyableLabel;

@end

@interface HTCopyableLabel : UILabel
{
    UIMenuController *copyMenu;
}
@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, assign) id<HTCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
-(void)setCopyMenuVisible:(BOOL)an;
@end
