//
//  GKMarketGird.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMarket.h"
#import "EKRequest.h"
@protocol marketGirdDelegate ;
@interface GKMarketGird : UIView<UIAlertViewDelegate,EKProtocol>
{
    
    UIImageView *imageViewBG;
    UIImageView *markerImageView;
    UILabel *titleLabel;
    UILabel *creditLabel;
    UIButton *buyButton;
    UITapGestureRecognizer *tap;
}
@property (nonatomic,retain)GKMarket *market;
@property (nonatomic,assign)id<marketGirdDelegate>delegate;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *creditLabel;
@end


@protocol marketGirdDelegate <NSObject>

-(void)tapGirdView:(GKMarketGird *)girdView marker:(GKMarket *)mark;


@end