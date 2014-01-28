//
//  GKSaySomethingView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-22.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPhotoTagScrollView.h"
@protocol GKSaySomethingViewDelegate;
@interface GKSaySomethingView : UIView<UITextViewDelegate,GKPhotoTagScrollViewDelegate>
{
    UILabel* labelNum;
}

@property (nonatomic,retain)NSString *tagStr;
@property (nonatomic,assign) id<GKSaySomethingViewDelegate>delegate;
@property (nonatomic,retain)UITextView *contextView;
@property (nonatomic,retain)GKPhotoTagScrollView *tagScrollerView;
@end




@protocol GKSaySomethingViewDelegate <NSObject>

//-(void)textView:(NSString *)contextTxt;
-(void)tag:(NSString *)tagTxt;
-(void)applyAll:(NSString *)str;
- (void)cancelApplyAll;

@end