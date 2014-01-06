//
//  ImageScaleView.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 2/20/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ImageScaleView.h"
#import <QuartzCore/QuartzCore.h>
#import "ETKids.h"

@implementation ImageScaleView
@synthesize photoImage;
@synthesize imgArr;

- (id)initWithFrame:(CGRect)frame image:(NSArray *)iamge
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor blackColor];
        self.imgArr = iamge;
        self.photoImage=[iamge objectAtIndex:0];
       
        iv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 320, self.frame.size.height - 75)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.userInteractionEnabled=NO;
        [iv setImage:photoImage];
        [self addSubview:iv];
        [iv release];
            current=1;
        
        navigation=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        navigation.tintColor = [UIColor blackColor];
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithTitle:LOCAL(@"cancel", @"取消" ) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:LOCAL(@"save", @"保存")  style:UIBarButtonItemStyleBordered target:self action:@selector(save)];//、、"picture" = "图片";
        UINavigationItem *item=[[UINavigationItem alloc]initWithTitle:LOCAL(@"picture", "图片")];
        
        item.rightBarButtonItem=right;
        item.leftBarButtonItem=leftItem;
        [navigation pushNavigationItem:item animated:NO];
        [item release];
        
        [right release];
        [leftItem release];
       
       
        [self addSubview:navigation];
        [navigation release];
        
        CGFloat height = 0;
        if(iphone5)
        {
            height = 568;
        }
        else
            height = 480;
        
        if(iamge.count >1)
        {
            UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToRight)];
            swipRight.direction=UISwipeGestureRecognizerDirectionRight;
            [self addGestureRecognizer:swipRight];
            [swipRight release];
            
            UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLeft)];
            swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            [self addGestureRecognizer:swipLeft];
            [swipLeft release];
            
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.bounds.size.width - 16 * 6) / 2, height - 45,
                                                                                         16 * 6, 10)];
            [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
            pageControl.numberOfPages = iamge.count;
            pageControl.tag = 99;
            currentPage = pageControl.currentPage = 0;
            
            [self addSubview:pageControl];
            [pageControl release];
        }
        else
        {
            iv.frame = CGRectMake(0, 40, 320, self.frame.size.height);
        }
        
    }
    return self;
}
-(void)dealloc
{
    self.photoImage=nil;
    [super dealloc];
}
-(void)cancel
{
    
    [UIView animateWithDuration:.1f animations:^{
        
        self.frame=CGRectMake(0, self.frame.size.height, 320, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self release];
    }];
    
 
}
-(void)save
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self];
        
        [self addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
   UIImageWriteToSavedPhotosAlbum(photoImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    NSString *message;
    NSString *title;
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
        
    }
    if (!error) {
        title = LOCAL(@"alert", @"提示");
        message = LOCAL(@"success", @"保存成功");
    } else {
        title =LOCAL(@"fail",  @"失败");
        message = [error description];
    }
    ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
//缩放图片
-(void)scalePiece:(UIPinchGestureRecognizer*)sender
{
    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded)
	{
        lastScale = 1.0;
        return;
    }
	
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = iv.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
    [iv setTransform:newTransform];
    lastScale = [sender scale];
}
//平移图片
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
	{
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
   
    if(current>1)
    {
        [scroller setZoomScale:1.0 animated:YES];
        current=1;
    }
    else
    {
        [scroller setZoomScale:3.0 animated:YES];
        current=2;
    }
   
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    
    return iv;
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    // 目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为 contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点 为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? \
    
    scrollView.contentSize.width/2 : xcenter;
    
    //同上，此处修改y值
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? \
    
    scrollView.contentSize.height/2 : ycenter;
    
    [iv setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (CATransition *)animationWithString:(NSString *)direction
{
	CATransition *animation = [CATransition animation];
	//	[animation setDelegate:self];
	[animation setType:kCATransitionReveal];
	[animation setSubtype:direction];
	[animation setDuration:0.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

- (void)pageTurn:(UIPageControl *)pageControl
{
    iv.frame = CGRectMake(0, 40, 320, self.frame.size.height - 75);
	CATransition *transition;
	int nextPage = pageControl.currentPage;
	
	if (nextPage - currentPage > 0)
	{
		transition = [self animationWithString:kCATransitionFromRight];
	}
    else
	{
		transition = [self animationWithString:kCATransitionFromLeft];
	}
	
    photoImage = [imgArr objectAtIndex:nextPage];
	iv.image = photoImage;
	[[iv layer] addAnimation:transition forKey:nil];
	currentPage = nextPage;
}

- (void)swipeToRight
{
	UIPageControl *pageControl = [self.subviews lastObject];
    
    if (pageControl.currentPage == 0) return;
    [pageControl setCurrentPage:pageControl.currentPage - 1];
    [self pageTurn:pageControl];
    
}
- (void)swipeToLeft
{
	UIPageControl *pageControl = [self.subviews lastObject];
    
    if (pageControl.currentPage == pageControl.numberOfPages - 1)
    {
        return;
    }
    
    [pageControl setCurrentPage:pageControl.currentPage + 1];
    [self pageTurn:pageControl];
}


@end
