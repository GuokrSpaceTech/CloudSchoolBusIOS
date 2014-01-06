
#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
//#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface UIActivityImageView:UIImageView <SDWebImageManagerDelegate>

- (void)setWebImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
