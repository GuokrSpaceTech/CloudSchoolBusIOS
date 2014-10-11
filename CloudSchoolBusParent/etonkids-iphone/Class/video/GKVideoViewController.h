//
//  GKVideoViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class OpenGLView20;
@class GKDevice;

@interface GKVideoViewController : UIViewController
{
    GKDevice *device;
    OpenGLView20 *glView;
    //int viodeoLength;
   
   

    MBProgressHUD *HUD;
}

//@property (nonatomic,retain)NSString *device_name;
     - (void)startup;
- (void)shutdown;
@end
