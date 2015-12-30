//
//  BigImageView.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/23.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BigImageViewDelegate <NSObject>
@required
-(void) exitGalleryMode;
-(void) actionSheetPopup:(UIImage *)image;
@end


@interface BigImageView : UIView <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) int maxZoomLevel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (nonatomic,strong) id<BigImageViewDelegate> delegate;

- (void)loadPage:(NSString *)imageUrl;
@end
