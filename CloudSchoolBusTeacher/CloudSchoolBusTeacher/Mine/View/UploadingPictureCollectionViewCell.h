//
//  UploadingPictureCollectionViewCell.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadingPictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIView *coverView;


@end
