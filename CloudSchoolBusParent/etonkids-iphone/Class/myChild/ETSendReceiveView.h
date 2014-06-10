//
//  ETSendReceiveView.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-4.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ETSendReceiveViewDelegate;
@interface ETSendReceiveView : UIView
{
    UIImageView *photoImageView;
    UILabel *namelabel;
}
@property (nonatomic,assign)id<ETSendReceiveViewDelegate>delegate;
@property(nonatomic,retain)UIImageView *photoImageView;
@property(nonatomic,retain)UILabel *namelabel;
@property (nonatomic,assign) int type; // 1 表示接送人 2 表示增加按钮
@end

@protocol ETSendReceiveViewDelegate <NSObject>

-(void)longPressView;
-(void)tapPressViewAddNewSendReceivePeople;

@end