//
//  GKMainViewController.h
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SideBarSelectedDelegate.h"


extern int badge;
@interface GKMainViewController : UIViewController<SideBarSelectDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    BOOL sideBarShowing;
    CGFloat currentTranslate;
}
@property (nonatomic,retain)UIViewController  *_currentMainController;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,retain) UINavigationController *leftViewController;
@property (nonatomic) int state;
+ (id)share;

@end
