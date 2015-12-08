//
//  CBPagedImageViewController.m
//  CloudBusParent
//
//  Created by mactop on 11/22/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "CBPagedImageViewController.h"
#import "UIImageView+WebCache.h"

@interface CBPagedImageViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate>
{
    int currentPageIndex;
}
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isZoomed;
@property (nonatomic, assign) BOOL maximumZoomScale;

- (void)loadPage:(NSInteger)page;
@end

@implementation CBPagedImageViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

#pragma mark -

#define ZOOM_VIEW_TAG 100

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([_pageImages count] > 0)
    {
        NSInteger pageCount = self.pageImages.count;
        
        // Set up the page control
        self.pageControl.currentPage = [self.startIndex intValue];
        self.pageControl.numberOfPages = pageCount;
        
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
    }
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(singleTap:)];
    singletap.numberOfTapsRequired = 1;
    singletap.numberOfTouchesRequired = 1;
    
    [self.scrollView addGestureRecognizer:singletap];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    
    [self.scrollView addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer* longPress = [ [ UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(longPressEvent:)];
    [self.scrollView addGestureRecognizer:longPress];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandle:)];
    [self.scrollView addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandle:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.scrollView addGestureRecognizer:swipeGestureLeft];
    
    [singletap requireGestureRecognizerToFail:doubleTap];
    [singletap requireGestureRecognizerToFail:longPress];
    [longPress requireGestureRecognizerToFail:swipeGestureLeft];
    [longPress requireGestureRecognizerToFail:swipeGestureRight];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Set up the content size of the scroll view
//    CGSize pagesScrollViewSize = self.scrollView.frame.size;
//    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    
    self.maximumZoomScale = 2;
    
    CGRect frame = self.scrollView.bounds;
    [self.scrollView setContentSize:frame.size];
    frame.size.width= frame.size.width * self.maximumZoomScale;
    frame.size.height = frame.size.height * self.maximumZoomScale;
    
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setTag:ZOOM_VIEW_TAG];
    [self.scrollView addSubview:_imageView];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    self.scrollView.delegate = self;
    float minimumScale = [_scrollView  frame].size.width  / [_imageView frame].size.width;
    [_scrollView setMinimumZoomScale:minimumScale];
    [_scrollView setZoomScale:minimumScale];
    
    self.isZoomed = false;
    
    currentPageIndex = [self.startIndex intValue];
    
    [self loadPage:currentPageIndex];
}

-(void)viewDidUnload
{
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private functions
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    NSString *imageUrl = [_pageImages objectAtIndex:page];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, NSURL *imageURL){
                  }];
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
    
    [self loadPage:currentPageIndex];
    
    self.pageControl.currentPage = currentPageIndex;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [_scrollView viewWithTag:ZOOM_VIEW_TAG];

}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
}


#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
