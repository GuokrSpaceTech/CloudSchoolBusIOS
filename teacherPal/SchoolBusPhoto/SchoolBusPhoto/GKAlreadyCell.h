//
//  GKAlreadyCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-11-7.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKMarket.h"
@interface GKAlreadyCell : UITableViewCell
{
    
}
@property (nonatomic,retain)GKMarket *market;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *timeLabel;
@property (nonatomic,retain)UILabel *jifenlabel;
@property (nonatomic,retain)UILabel *stateLabel;

@property (nonatomic,retain) UIImageView *goodsImageView;
@end
