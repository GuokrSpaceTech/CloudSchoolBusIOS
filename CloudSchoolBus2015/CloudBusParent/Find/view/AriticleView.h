//
//  AriticleView.h
//  CloudBusParent
//
//  Created by mactop on 11/20/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface AriticleView : UIView
@property (nonatomic,strong) Message *message;
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *width;
@end
