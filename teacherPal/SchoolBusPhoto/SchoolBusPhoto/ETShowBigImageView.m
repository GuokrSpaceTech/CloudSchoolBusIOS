//
//  ETShowBigImageView.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-7-17.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETShowBigImageView.h"

#import <CoreMotion/CoreMotion.h>

#define NAVIHEIGHT 46
#define IMAGEVIEWHEIGHT [UIScreen mainScreen].applicationFrame.size.height
@implementation ETShowBigImageView
@synthesize imgSV,imgUrlArr,imgVArr;
@synthesize content;
@synthesize rightButton,leftButton,delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        self.backgroundColor = [UIColor blackColor];
        

        self.imgVArr = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        NSString *navpath = [[NSBundle mainBundle] pathForResource:@"navBarImage" ofType:@"png"];
        navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
        navigationBackView.image=[UIImage imageWithContentsOfFile:navpath];
        navigationBackView.userInteractionEnabled = YES;
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];
      
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"backH" ofType:@"png"];
        
        leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 34, 35)];
        [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2)];
        [leftButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBackView addSubview:leftButton];


        
        
//        rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [leftButton setFrame:CGRectMake(0, 0, 34, 35)];
//        [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2)];
//        [leftButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
//        [leftButton setImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateHighlighted];
//        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [navigationBackView addSubview:leftButton];
        
        
        zoomImgV = [[ETZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        zoomImgV.backgroundColor = [UIColor blackColor];
        zoomImgV.imageView.image = image;
        zoomImgV.tDelegate = self;
        [self addSubview:zoomImgV];
        [zoomImgV release];
        
        
        [self addSubview:navigationBackView];
        [navigationBackView release];
        
        
    }
    return self;
}


- (void)reloadFrame:(UIInterfaceOrientation)orientation
{
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        navigationBackView.frame = CGRectMake(0, 0, iphone5 ? 568 : 480, NAVIHEIGHT);
        item.center = CGPointMake((iphone5 ? 568 : 480)/2, NAVIHEIGHT/2);
        rightButton.frame = CGRectMake((iphone5 ? 568 : 480) - 10 - 34, (NAVIHEIGHT - 35)/2.0f, 34, 35);
        
        
        zoomImgV.frame = CGRectMake(0, 0, iphone5 ? 568 : 480, 300);
        zoomImgV.zoomScale = 1;
        zoomImgV.imageView.frame = CGRectMake(0,
                                              0,
                                              iphone5 ? 568 : 480,
                                              300);
        
    }
    else
    {
        navigationBackView.frame = CGRectMake(0, 0, 320, NAVIHEIGHT);
        item.center = CGPointMake(320/2, NAVIHEIGHT/2);
        rightButton.frame=CGRectMake(320 - 10 - 34, (NAVIHEIGHT - 35)/2.0f,34, 35);
        
        zoomImgV.frame = CGRectMake(0, 0, 320, IMAGEVIEWHEIGHT);
        zoomImgV.zoomScale = 1;
        zoomImgV.imageView.frame = CGRectMake(0,
                                              0,
                                              320,
                                              IMAGEVIEWHEIGHT);
        
    }

    
    
    
}


- (void)handleSingleTap
{
    
    CABasicAnimation *opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration =0.5f;
    
    if (navigationBackView.alpha == 0)
    {
        opacity.fromValue = [NSNumber numberWithFloat:0];
        opacity.toValue = [NSNumber numberWithFloat:1];
    }
    else
    {
        opacity.fromValue = [NSNumber numberWithFloat:1];
        opacity.toValue = [NSNumber numberWithFloat:0];
    }
    opacity.removedOnCompletion=NO;
    opacity.fillMode=kCAFillModeForwards;
    
    
    [navigationBackView.layer addAnimation:opacity forKey:@"111"];
    
//    [self performSelector:@selector(hideNav) withObject:nil afterDelay:0.7f];

    
    navigationBackView.alpha = (int)(navigationBackView.alpha + 1) % 2;
    
    
}





-(void)leftButtonClick:(UIButton*)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickBackButton)]) {
        [delegate didClickBackButton];
    }
}






// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}




- (void)dealloc
{
    self.imgSV = nil;
    self.imgUrlArr = nil;
    self.imgVArr = nil;
    self.content=nil;
    [super dealloc];
}



@end
