//
//  ETZoomScrollView.m
//  ScrollViewWithZoom
//
//

#import "ETZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface ETZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation ETZoomScrollView

@synthesize imageView,tDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(frame.origin.x, 0, MRScreenWidth, MRScreenHeight);
        
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 1.0f;
        
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    imageView = [[UIImageView alloc]init];
    
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView release];
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
//    float minimumScale = self.frame.size.width / imageView.frame.size.width;
//    [self setMinimumZoomScale:minimumScale];
//    [self setZoomScale:minimumScale];
    
    
    
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSingleTap:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
    
    
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    
    
    UITapGestureRecognizer *s = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    [s setNumberOfTapsRequired:1];
    [self addGestureRecognizer:s];
    [s release];
}


#pragma mark - Zoom methods

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture
{
    if (tDelegate && [tDelegate respondsToSelector:@selector(handleSingleTap)]) {
        [tDelegate handleSingleTap];
    }
}


- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    float newScale = 2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
    
}
    

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
    
    if (scale < 1) {
        [UIView animateWithDuration:0.2f animations:^{
            imageView.center = CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height/2);
        }];
    }
    

    
    
    
}

#pragma mark - View cycle
- (void)dealloc
{
    [super dealloc];
}

@end
