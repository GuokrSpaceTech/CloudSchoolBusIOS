//
//  GKMarketButton.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-1.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol markerButtonDelegate;
@interface GKMarketButton : UIView
{
    UILabel *textLabel;
    UILabel *countLabel;
    UIImageView *iamgeView;
    
    BOOL isSelected;
}
@property (nonatomic,assign)id<markerButtonDelegate>delegate;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,retain)UIImage *selectedIamge;
@property (nonatomic,retain)UIImage *noneSelectedImage;
@property (nonatomic,retain)  UILabel *textLabel;
@property (nonatomic,retain)  UILabel *countLabel;

//- (id)initWithFrame:(CGRect)frame noSelectImage:(UIImage *)noSelctImage selectImage:(UIImage *)selectIamge;
@end


@protocol markerButtonDelegate <NSObject>

-(void)isSelectedTheButton:(GKMarketButton *)marketView isSelected:(BOOL)selected;

@end