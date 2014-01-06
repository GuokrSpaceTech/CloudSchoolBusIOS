//
//  CustomActionSheet.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-1.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   CustomActionSheet
 *  @brief  自定义actionsheet 用于设置页面 修改生日等.
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>

@class CustomActionSheet;

@protocol CustomActionSheetDelegate <NSObject>

- (void)customActionSheetDidClickOKButton:(CustomActionSheet *)sheet;
- (void)customActionSheetDidClickCancelButton:(CustomActionSheet *)sheet;

@end


@interface CustomActionSheet : UIActionSheet {
    
    UIToolbar* toolBar;
    UIView* view;
}
@property(nonatomic,retain)UIView* view;
@property(nonatomic,retain)UIToolbar* toolBar;

@property (nonatomic, assign) id <CustomActionSheetDelegate> cDelegate;


-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title;



@end


