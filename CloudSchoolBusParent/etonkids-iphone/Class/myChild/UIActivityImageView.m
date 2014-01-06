

#import "UIActivityImageView.h"


@interface UIActivityImageView()

@property(nonatomic,retain) UIActivityIndicatorView * activity;

@end
@implementation UIActivityImageView

@synthesize activity;

- (void)setWebImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    
    activityIndicator.frame = CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20);
    [activityIndicator startAnimating];
    self.activity = activityIndicator;
    
    [self addSubview:self.activity];
    [activityIndicator release];
    
    [self setWebImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setWebImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
        
    }
}

#pragma SDWebImageManager_Delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self.activity stopAnimating];
    
    self.image = image;
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    [self.activity stopAnimating];
}
#pragma --

-(void) dealloc
{
    self.activity = nil;
    
    [super dealloc];
}
@end
