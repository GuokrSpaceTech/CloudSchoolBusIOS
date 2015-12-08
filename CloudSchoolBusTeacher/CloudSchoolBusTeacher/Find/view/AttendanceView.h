//
//  AttendanceView.h
//  CloudBusParent
//
//  Created by macbook on 15/11/28.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface AttendanceView : UIView

@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UIImageView *timeCardImageView;

@property (nonatomic,strong) Message *message;
@property (nonatomic,strong) NSNumber *height;
@end
