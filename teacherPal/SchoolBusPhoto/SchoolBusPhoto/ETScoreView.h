//
//  ETScoreView.h
//  ssssss
//
//  Created by CaiJingPeng on 13-11-7.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKRequest.h"

@interface ETScoreView : UIView<EKProtocol>

@property (nonatomic, retain)NSArray *lineDataArray;
@property (nonatomic, retain)NSString *curWeekScore;
@property (nonatomic, retain)NSArray *bottomScore;
    @property (nonatomic,retain)NSString *year;

@end
