//
//  ETCustomAlertView.h
//  ssssss
//
//  Created by CaiJingPeng on 13-9-18.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETKids.h"

@class ETCustomAlertView;

@protocol ETCustomAlertViewDelegate <NSObject>

@optional
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index;

@end

@interface ETCustomAlertView : UIView<UIAlertViewDelegate>
{
    UIView *whiteView;
    UIView *mainView;
}

@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) id<ETCustomAlertViewDelegate> delegate;
@property (nonatomic, retain) NSString *myTitle;
@property (nonatomic, retain) NSString *myMessage;
@property (nonatomic, retain) NSString *cancelBtnTitle;
@property (nonatomic, retain) NSString *otherBtnTitles;


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitlesArray:(NSArray *)titles;

- (void)show;

@end
