//
//  GKShowBigImageViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-30.
//  Copyright (c) 2013年 ;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@protocol GKShowBigImageViewControllerDelegate;
@interface GKShowReceiveBigImageViewController:UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIScrollView *scroller;
    UIImageView *imageView;
        UIImageView *navigationBackView;
}
@property (nonatomic,retain)NSString *path;

@property (nonatomic,retain)UIImage *Image;


@property (nonatomic,assign)id<GKShowBigImageViewControllerDelegate>delegate;

@end


@protocol GKShowBigImageViewControllerDelegate <NSObject>

@optional
-(void)deletePhoto;

@end