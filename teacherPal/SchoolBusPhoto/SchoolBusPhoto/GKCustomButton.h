//
//  GKCustomButton.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-2-12.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKCustomButton : UIButton
{
    CGRect titleRect;
    CGRect imageRect;
}
@property(nonatomic,assign) CGRect titleRect;
@property(nonatomic,assign) CGRect imageRect;
- (id)initWithFrame:(CGRect)frame;
@end
