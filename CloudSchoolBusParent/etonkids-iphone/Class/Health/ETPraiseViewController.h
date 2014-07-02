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
@interface ETPraiseViewController : UIViewController
{
    UIView * topView;
    
    int star;
    
    MBProgressHUD *HUD;
    
    
}
@property (nonatomic,retain)UITextView *contentView;
@property (nonatomic,retain)CYProblem  *problem;
@end
