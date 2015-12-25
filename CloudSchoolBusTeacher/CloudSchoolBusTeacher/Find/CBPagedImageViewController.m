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

@interface CBPagedImageViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate, BigImageViewDelegate>
{
    int currentPageIndex;
    UIView *imageViewsContainer;
    float scrollY;
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
        imageView.commentsLabel.text = _comments;
        [imageView loadPage:_pageImages[i-1]];
        imageView.delegate = self;

        [_scrollView addSubview:imageView];
    }
    [self layoutScrollImages];
    
    
    [[self navigationController] setNavigationBarHidden:YES];
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


#pragma mark - private function
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


-(void)layoutScrollImages
{
    BigImageView *view = nil;
    NSArray *subviews = [_scrollView subviews];
    float singleFrameWidth = [[UIScreen mainScreen] bounds].size.width;
    float singleFrameHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        if ([view isKindOfClass:[BigImageView class]] && view.tag > 0)
        {
            CGRect frame = CGRectMake(curXLoc, 0, singleFrameWidth, singleFrameHeight);
            view.frame = frame;
            
            curXLoc += (frame.size.width);
            
        }
    }
    
    // set the content size
    [_scrollView setContentSize:CGSizeMake((_pageImages.count * singleFrameWidth), singleFrameHeight)];
    
    //Force Horizontal scroll to the same Y
    scrollY = _scrollView.contentOffset.y;
    
    _scrollView.contentOffset = CGPointMake([_startIndex intValue] * singleFrameWidth, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    if (sView.tag == 1)
    {
        NSInteger index = fabs(sView.contentOffset.x) / sView.frame.size.width;
        [_pageControl setCurrentPage:index];
    }
}

#pragma mark
#pragma mark == BigImageViewDelegate
-(void)exitGalleryMode
{
    //Exit
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)actionSheetPopup
{
    
}
@end
