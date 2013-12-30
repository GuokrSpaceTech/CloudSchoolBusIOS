//
//  GKBaseViewController.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKBaseViewController : UIViewController
{
    UILabel *titlelabel;
    UIView *navigationView;
    
    UIView *_imageView11;
}
@property (nonatomic,retain)UILabel *titlelabel;
@property (nonatomic,retain)UIView *navigationView;;
@end
