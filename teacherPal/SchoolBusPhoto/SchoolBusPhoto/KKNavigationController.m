//
//  KKNavigationController.m
//  TS
//
//  Created by Coneboy_K on 13-12-2.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.  MIT
//  WELCOME TO MY BLOG  http://www.coneboy.com
//


#import "KKNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "GKSaySomethingView.h"
#import "GKWriteReportViewController.h"
#import "GKShowViewController.h"
#import <CoreGraphics/CoreGraphics.h>
@interface KKNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;

}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation KKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
    
    //[UIBezierPath bezierPathWithRect:self.view.bounds];
 
    self.view.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 1;
//
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    CGSize size =img.size;
    NSLog(@"%f---%f",size.width,size.height);
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);

    blackMask.alpha = alpha;

    CGFloat aa = abs(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;

    //CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
/**
 *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add

    if (!iOS7) {
        lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
    }
 *
 */
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotView.frame.size.height)];

}

-(void)setNavigationTouch:(BOOL)an
{
    if(an)
    {
        if(!recognizer)
        {
            recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
            recognizer.delegate=self;
            [recognizer delaysTouchesBegan];
            [self.view addGestureRecognizer:recognizer];
        }


    }
    else
    {
        if(recognizer)
        {
            [self.view removeGestureRecognizer:recognizer];
            recognizer=nil;
        }
    
    }
}

-(BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* touchedView = [touch view];
    
    for (UIView* next = [touchedView superview]; next; next = next.superview)
    {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[GKShowViewController class]] || [nextResponder isKindOfClass:[GKWriteReportViewController class]]) {
                    return NO;
                    
            }
        
    }
    if([touchedView isKindOfClass:[UIButton class]] ||[touchedView isKindOfClass:[GKSaySomethingView class]] || [touchedView isKindOfClass:[UITextView class]]) {
        
        return NO;
    }
    
    
    
    
    return YES;
}
#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack)
    {
       
    }
    else
    {
        
        CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
        
        if (recoginzer.state == UIGestureRecognizerStateBegan) {
            
            _isMoving = YES;
            startTouch = touchPoint;
            
            if (!self.backgroundView)
            {
                CGRect frame = self.view.frame;
                
                _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
 
                [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
                
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                blackMask.backgroundColor = [UIColor clearColor];
  
                [self.backgroundView addSubview:blackMask];
            }
            
            self.backgroundView.hidden = NO;
            
            if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
            
            
            UIImage *lastScreenShot = [self.screenShotsList lastObject];
            //NSLog(@"%f---%f",lastScreenShot.size.width,lastScreenShot.size.height);
            lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            //lastScreenShotView.contentMode=UIViewContentModeScaleAspectFill;
            startBackViewX = startX;
            [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                    lastScreenShotView.frame.origin.y,
                                                    lastScreenShotView.frame.size.width,
                                                    lastScreenShotView.frame.size.height)];
//            NSLog(@"%f",lastScreenShotView.frame.size.height);
        
            
            [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
            
        }else if (recoginzer.state == UIGestureRecognizerStateEnded){
            
            if (touchPoint.x - startTouch.x > 50)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:320];
                } completion:^(BOOL finished) {
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    [self popViewControllerAnimated:NO];
                   
                    
                    _isMoving = NO;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:0];
                } completion:^(BOOL finished) {
                    _isMoving = NO;
                    self.backgroundView.hidden = YES;
                }];
                
            }
            return;
            
        }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
            
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
            return;
        }
        
        if (_isMoving) {
            [self moveViewWithX:touchPoint.x - startTouch.x];
        }

    }
        
    
}



@end



