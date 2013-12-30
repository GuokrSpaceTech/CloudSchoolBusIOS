//
//  GKShowBigImageViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-30.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
@interface GKShowBigImageViewController : GKBaseViewController<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIScrollView *scroller;
    UIImageView *imageView;
}
@property (nonatomic,retain)NSString *path;
@end
