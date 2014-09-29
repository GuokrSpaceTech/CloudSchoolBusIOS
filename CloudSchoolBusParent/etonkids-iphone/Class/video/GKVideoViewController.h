//
//  GKVideoViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenGLView20;
@class GKDevice;
@interface GKVideoViewController : UIViewController
{
    GKDevice *device;
    OpenGLView20 *glView;
    //int viodeoLength;
   
   

}

@property (nonatomic,retain)GKDevice *device;
     - (void)startup;
- (void)shutdown;
@end
