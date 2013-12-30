//
//  ETZoomScrollView.h
//  ScrollViewWithZoom
//

#import <UIKit/UIKit.h>

@protocol ETZoomScrollViewDelegate <NSObject>

- (void)handleSingleTap;

@end

@interface ETZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) id<ETZoomScrollViewDelegate> tDelegate;

//- (void)reloadFrame:(float)originX;

@end
