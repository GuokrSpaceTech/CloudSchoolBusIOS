//
//  GKMarketDetailView.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMarket.h"
@interface GKMarketDetailView : UIView
{
    UILabel *nameLable;
    UILabel *CreditLable;
    UIImageView *imageView;
    UITextView *textView;
}
@property (nonatomic,retain)GKMarket *market;
@end
