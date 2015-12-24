//
//  CBPagedImageViewController.m
//  CloudBusParent
//
//  Created by mactop on 11/22/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "CBPagedImageViewController.h"
#import "UIImageView+WebCache.h"
#import "BigImageView.h"
#import "Masonry.h"

@interface CBPagedImageViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate>
{
    int currentPageIndex;
    UIView *imageViewsContainer;
}
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isZoomed;
@property (nonatomic, assign) BOOL maximumZoomScale;

@end

@implementation CBPagedImageViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the page control
    if([_pageImages count] > 0)
    {
        NSInteger pageCount = self.pageImages.count;
        self.pageControl.currentPage = [self.startIndex intValue];
        self.pageControl.numberOfPages = pageCount;
    }
    
    //Setup the scrollview
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    [_scrollView setCanCancelContentTouches:NO];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;     // default is NO, we want to restrict drawing within our scrollview
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //向scrollView中添加imageView
    NSUInteger i;
    for (i = 1; i <= _pageImages.count; i++)
    {
        //设置frame
        CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        BigImageView *imageView = [[BigImageView alloc] initWithFrame:rect];
        imageView.tag = i;
        [imageView loadPage:_pageImages[i-1]];

        [_scrollView addSubview:imageView];
    }
    
    [self layoutScrollImages];
    
    [[self navigationController] setNavigationBarHidden:YES];
}


-(void)layoutScrollImages
{
    BigImageView *view = nil;
    NSArray *subviews = [_scrollView subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        if ([view isKindOfClass:[BigImageView class]] && view.tag > 0)
        {
            CGRect frame = CGRectMake(curXLoc, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            view.frame = frame;
            
            curXLoc += (frame.size.width);
        }
    }
    
    // set the content size so it can be scrollable
    [_scrollView setContentSize:CGSizeMake((_pageImages.count * [[UIScreen mainScreen] bounds].size.width), [_scrollView bounds].size.height)];
}

-(void)viewDidUnload
{
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
//    self.pageViews = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private functions
- (void)addBigImageViews:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    float left = 0;
    for(int i=0; i<_pageImages.count;i++)
    {
        left = i*self.view.frame.size.width;
        CGRect frame = CGRectMake(left, 0, self.view.frame.size.width, self.view.frame.size.height);
        BigImageView *bigImageView = [[BigImageView alloc]initWithFrame:frame];
        [imageViewsContainer addSubview:bigImageView];
        
        NSString *imageUrl = [_pageImages objectAtIndex:i];
        
        [bigImageView loadPage:imageUrl];
    }
}

- (void)zoomToPoint:(CGPoint)point
{
    CGRect zoomRect;
    if(self.isZoomed )
    {
        [_scrollView setZoomScale:0.5 animated:YES];
    } else {
        zoomRect = [self zoomRectForScale:1 withCenter:point];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect = self.scrollView.frame;
    
    zoomRect.size.height /= scale;
    zoomRect.size.width /= scale;
    
    //the origin of a rect is it's top left corner,
    //so subtract half the width and height of the rect from it's center point to get to that x,y
    zoomRect.origin.x = center.x;
    zoomRect.origin.y = center.y;
    
    return zoomRect;
}

#pragma mark - User Actions
-(void)singleTap:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFade;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
}

-(void)doubleTap:(UIGestureRecognizer *)sender
{
    [self zoomToPoint:[sender locationInView:sender.view]];
    self.isZoomed = !self.isZoomed;
    
//    [self.scrollView zoomToRect:<#(CGRect)#> animated:YES];
}

-(void)longPressEvent:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"图像操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"保存到本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        if (_imageView) {
            UIImage *imageToBeSaved = _imageView.image;
            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)swipeGestureHandle:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        currentPageIndex --;
        if(currentPageIndex < 0)
            currentPageIndex = (int)[_pageImages count] - 1;
    }
    else
    {
        currentPageIndex ++;
        if(currentPageIndex == [_pageImages count])
            currentPageIndex = 0;
    }
    
//    [self loadPage:currentPageIndex];
    
    self.pageControl.currentPage = currentPageIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    if (sView.tag == 1)
    {
        NSInteger index = fabs(sView.contentOffset.x) / sView.frame.size.width;
        //NSLog(@"%d",index);
        [_pageControl setCurrentPage:index];
//        featureLabel.text = [array objectAtIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x / scrollView.bounds.size.width);
    if(page != _pageControl.currentPage)
    {
        _pageControl.currentPage = page;
    }
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
}


#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
