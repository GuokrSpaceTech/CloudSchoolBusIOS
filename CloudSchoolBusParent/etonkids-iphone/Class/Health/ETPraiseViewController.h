//
//  ETPraiseViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CYProblem.h"

@protocol praiseVCdelegate;
@interface ETPraiseViewController : UIViewController<UITextViewDelegate>
{
    UIView * topView;
    UIView *bottomView;
    NSInteger star;
    
    MBProgressHUD *HUD;
    UILabel *startlabl;
    
}
@property (nonatomic,assign)id<praiseVCdelegate>delegate;
@property (nonatomic,retain)UITextView *contentView;
@property (nonatomic,retain)CYProblem  *problem;

@property (nonatomic,retain)NSString  *placeholder;
@end


@protocol praiseVCdelegate <NSObject>

-(void)reloadDetailVC;

@end