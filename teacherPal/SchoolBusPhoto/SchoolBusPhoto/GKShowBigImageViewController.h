//
//  GKShowBigImageViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-30.
//  Copyright (c) 2013年 ;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@class MBProgressHUD;
@protocol GKShowBigImageViewControllerDelegate;
@interface GKShowBigImageViewController : GKBaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIScrollView *scroller;
    UIImageView *imageView;
}
@property (nonatomic,retain)NSString *path;

@property (nonatomic,retain)UIImage *Image;

@property (nonatomic,assign)int type;
@property (nonatomic,assign)id<GKShowBigImageViewControllerDelegate>delegate;

@end


@protocol GKShowBigImageViewControllerDelegate <NSObject>

@optional
-(void)deletePhoto;

@end