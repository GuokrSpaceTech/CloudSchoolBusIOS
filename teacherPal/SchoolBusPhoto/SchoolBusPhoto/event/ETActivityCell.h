//
//  ETActivityCell.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETEvents.h"
@interface ETActivityCell : UITableViewCell
@property (nonatomic,retain)ETEvents *events;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic,retain)UIButton *btn;
@end
