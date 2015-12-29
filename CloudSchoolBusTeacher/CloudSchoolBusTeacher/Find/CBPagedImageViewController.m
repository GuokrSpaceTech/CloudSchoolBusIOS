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
        imageView.descriptionLabel.text = _desc;
        [imageView loadPage:_pageImages[i-1]];
        imageView.delegate = self;

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
    
    // Scroll the View to the right start page
    _scrollView.frame = CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    CGRect frame = _scrollView.frame;
    frame.origin.x = [_startIndex intValue]* [[UIScreen mainScreen] bounds].size.width;
    
    [_scrollView scrollRectToVisible:frame animated:YES];
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

#pragma mark - BigImageView Delegate
-(void)exitGalleryMode
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)actionSheetPopup:(UIImage *)image
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"图像操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"保存到本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
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

@end
