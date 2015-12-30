//
//  BigImageView.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/23.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "BigImageView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface BigImageView()
{
    BOOL isZoomed;
}

@end

@implementation BigImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
//        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initUI:frame];
    }
    return self;
}

-(void)initUI:(CGRect)frame
{
    /*
     * 添加ScrollView
     */
    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    [self addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(self.mas_height);
//        make.center.mas_equalTo(self);
//    }];
    /*
     *  根据maxZoomLevel给ScroolView添加一个最大的ImageView
     */
    self.maxZoomLevel = 2;
    
    CGRect frameImage = self.scrollView.bounds;
    frameImage.size.width= frame.size.width * self.maxZoomLevel;
    frameImage.size.height = frame.size.height * self.maxZoomLevel;
    
    _imageView = [[UIImageView alloc] initWithFrame:frameImage];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:_imageView];
    
    _scrollView.contentSize = _imageView.frame.size;

    //Description Label
    _descriptionLabel = [[UILabel alloc]init];
    [self addSubview:_descriptionLabel];
    _descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = [UIColor whiteColor];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
    
    // 设置代理
    self.scrollView.delegate = self;
    
    //计算并设置最小缩小系数
    float minimumScale = [_scrollView  frame].size.width  / [_imageView frame].size.width;
    [_scrollView setMinimumZoomScale:minimumScale];
    [_scrollView setZoomScale:minimumScale];
    
    //添加手势
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
    [singletap requireGestureRecognizerToFail:doubleTap];
    
    
    [self.scrollView addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer* longPress = [ [ UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(longPressEvent:)];
    [self.scrollView addGestureRecognizer:longPress];
    

    
    // Init Vars
    isZoomed = NO;
}

#pragma mark - private functions
- (void)loadPage:(NSString *)imageUrl
{
    NSString *imageUrlThumb = [imageUrl stringByAppendingString:@".tiny.jpg"];
    
//    SDWebImageDownloader *manager = [[SDWebImageDownloader alloc]init];
//    [manager downloadImageWithURL:[NSURL URLWithString:imageUrlThumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//    }];
    
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlThumb]
                  placeholderImage:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, NSURL *imageURL){
                  }];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];

}

- (void)zoomToPoint:(CGPoint)point
{
    CGRect zoomRect;
    if(isZoomed)
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


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


#pragma mark - User Actions
-(void)singleTap:(id)sender
{
    [_delegate exitGalleryMode];
}

-(void)doubleTap:(UIGestureRecognizer *)sender
{
    [self zoomToPoint:[sender locationInView:sender.view]];
    isZoomed = !isZoomed;
}

-(void)longPressEvent:(id)sender
{
    [_delegate actionSheetPopup:_imageView.image];
}

@end
