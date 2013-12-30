//
//  GKMarketCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-31.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMarket.h"
//#import "GKMarketGird.h"

#import "GKBuyCountView.h"
#import "GKUserLogin.h"

@protocol  marketDelegate;

@interface GKMarketCell : UITableViewCell  <UIAlertViewDelegate>
{
//    GKMarketGird *girdOne;
//    GKMarketGird *girdTwo;
//    GKMarketGird *girdThree;
    
    
    
   // u
    
    UIImageView *goodsImageView;
    
    UILabel *goodsLabel;
    UIImageView *jifenImageView;
    UILabel *jifenLabel;
    UILabel *goodsDesc;
    
    UIButton *buyButton;
    GKBuyCountView *countView;
    
    int buyCount;
    
    

    
}
@property (nonatomic,assign)id<marketDelegate>delegate;
@property (nonatomic,retain) UIImageView *goodsImageView;
@property (nonatomic,retain) UILabel *goodsLabel;
@property (nonatomic,retain) UILabel *jifenLabel;
@property (nonatomic,retain) UILabel *goodsDesc;
@property (nonatomic,retain)UIButton *buyButton;
@property (nonatomic,retain)GKMarket *market;

//@property (nonatomic,retain)  GKMarketGird *girdOne;
//@property (nonatomic,retain)  GKMarketGird *girdTwo;
//@property (nonatomic,retain)  GKMarketGird *girdThree;



@end

@protocol  marketDelegate <NSObject>
-(void)clickBuy:(GKMarketCell *)cell isselected:(BOOL)select market:(GKMarket *)mark;

@end




