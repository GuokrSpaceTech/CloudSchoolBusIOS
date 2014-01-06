//
//  ETEducationViewController.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-25.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBaseViewController.h"
#import "ETKids.h"
#import "OrderBlock.h"

@interface ETEducationViewController : ETBaseViewController<OrderBlockDelegate>

@property (nonatomic, retain) NSMutableArray *blockArr;

- (void)setAllBlockNormal;

@end
