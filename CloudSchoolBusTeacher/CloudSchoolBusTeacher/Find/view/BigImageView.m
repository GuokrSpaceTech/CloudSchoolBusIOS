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

//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if(self = [super initWithCoder:aDecoder])
//    {
//        [self initUI];
//    }
//    return self;
//}

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
    
    /*
     * Comments Label
     */
    _commentsLabel = [[UILabel alloc]init];
    _commentsLabel.backgroundColor = [UIColor clearColor];
    _commentsLabel.font =[UIFont systemFontOfSize:14.0f];
    _commentsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_commentsLabel];
    [_commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
    
    /*
     * ThumbNail
     */
    _thumbNailView = [[UIImageView alloc]init];
    [self addSubview:_thumbNailView];
    [_thumbNailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
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
    NSString *thumbNailStr = [imageUrl stringByAppendingString:@".tiny.jpg"];
    [_thumbNailView sd_setImageWithURL:[NSURL URLWithString:thumbNailStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                      placeholderImage:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, NSURL *imageURL){
                          _thumbNailView.hidden = YES;
                      }];
    }];
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
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFade;
//    transition.delegate = self;
//    
    [_delegate exitGalleryMode];
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    [[self navigationController] setNavigationBarHidden:NO];
}

-(void)doubleTap:(UIGestureRecognizer *)sender
{
    [self zoomToPoint:[sender locationInView:sender.view]];
    isZoomed = !isZoomed;
}

-(void)longPressEvent:(id)sender
{
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"图像操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//        // Cancel button tappped.
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//    }]];
    
    
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"保存到本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        // OK button tapped.
//        if (_imageView) {
//            UIImage *imageToBeSaved = _imageView.image;
//            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
//        }
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//    }]];
//    
//    // Present action sheet.
//    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
}

@end
