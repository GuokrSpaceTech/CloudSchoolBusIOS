//
//  CBPagedImageViewController.m
//  CloudBusParent
//
//  Created by mactop on 11/22/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import "CBPagedImageViewController.h"
#import "UIImageView+WebCache.h"

@interface CBPagedImageViewController ()
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation CBPagedImageViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] init];
        
        NSString *imageUrl = [_pageImages objectAtIndex:page];
        
        [newPageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:nil completed:^(UIImage *image, NSError *error,
                                                      SDImageCacheType cacheType, NSURL *imageURL){}];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


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
}

- (void)viewDidAppear:(BOOL)animated
{
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
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




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

@end
