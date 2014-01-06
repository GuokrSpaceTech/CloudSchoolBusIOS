//
//  ETLockView.h
//  jiesuo
//
//  Created by wen peifang on 13-9-25.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

typedef enum {
    ReSet,
    Unlock,
}LockState;

#import <UIKit/UIKit.h>
#import "ETImageView.h"

@protocol LockDelegate ;
@interface ETLockView : UIView
{
    CGPoint beginPoint;
    
    CGPoint nextPoint;
    

    
    NSMutableArray *arr;
    
    
    ETImageView  *currentImage;
    
    UIImageView *bgImageView;
    
}
@property (nonatomic,assign) id<LockDelegate>delegate;
@property (nonatomic,assign) LockState state;
@property (nonatomic,retain)NSMutableArray *arr;

@property (nonatomic,retain)NSMutableArray *selectPointArr;

@property (nonatomic,retain)ETImageView  *currentImage;
@end

@protocol LockDelegate <NSObject>

-(void)isSuccess:(BOOL)isSuccess;

- (void)gesturePassword:(NSString *)pwd;

@end