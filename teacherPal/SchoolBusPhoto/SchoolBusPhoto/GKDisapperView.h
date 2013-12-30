//
//  GKDisapperView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-12-19.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKDisapperView : UIView
{
    UILabel *textLabel;
    UIActivityIndicatorView *activityView;
    UIImageView *imageView;
    
    CGRect orgFrame;
}
@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;

-(void)setactiveStop:(BOOL)an;
@end
