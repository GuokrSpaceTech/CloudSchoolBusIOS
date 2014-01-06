//
//  OrderBlock.h
//  ssssss
//
//  Created by CaiJingPeng on 13-9-2.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderBlock;

@protocol OrderBlockDelegate <NSObject>

- (void)didLongPressBlock:(OrderBlock *)block;
- (void)didTapPressBlock:(OrderBlock *)block;
- (void)didClickDeleteButton:(OrderBlock *)block;
- (void)moveBlock:(OrderBlock *)block Position:(CGPoint)pos touchPos:(CGPoint)tPos;
- (void)endMoveBlock:(OrderBlock *)block;

@end


typedef enum
{
    
    DeleteStatus = 0,
    NormalStatus
    
}BlockStatus;


typedef enum
{
    MyCollection = 0,
    AddOrder,
    NormalOrder
    
}BlockType;

@interface OrderBlock : UIView
{
    BlockStatus status;
    CGPoint startPos;
    UIButton *deleteBtn;
    UILongPressGestureRecognizer *lpGes;
}

@property (nonatomic, assign) id<OrderBlockDelegate> delegate;
@property (nonatomic, assign) UIImageView *orderImageView;
@property (nonatomic, assign) BlockType obType;

- (id)initWithFrame:(CGRect)frame AndImage:(UIImage *)img;

- (void)setDeleteStatus;
- (void)resetNormalStatus;

@end
