//
//  ImageScaleView.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 2/20/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ETCustomAlertView.h"


@interface ImageScaleView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImage *photoImage;
    UIScrollView *scroller;
    UIImageView *iv;
    int current;
    CGFloat lastScale; 
    MBProgressHUD *HUD;
    UINavigationBar *navigation;
    
    int currentPage;
    NSArray * imgArr;
    
}
@property(nonatomic,retain)NSArray * imgArr;
@property(nonatomic,retain)UIImage *photoImage;
- (id)initWithFrame:(CGRect)frame image:(NSArray *)iamge;
@end
