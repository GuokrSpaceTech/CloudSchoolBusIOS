//
//  GKNoticeCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNotice.h"
#import "HTCopyableLabel.h"
@protocol noticeCelldelegate;
@interface GKNoticeCell : UITableViewCell
{
    UILabel *titleLable;
    HTCopyableLabel *contentlabel;
    UILabel *timeLabel;
    
    UIView *bottomView;
    
    UIImageView *IconImageView;

    UIImageView *lineImageView;
}
@property (nonatomic,retain)  UILabel *titleLable;
@property (nonatomic,retain)  HTCopyableLabel *contentlabel;
@property (nonatomic,retain)  UILabel *timeLabel;
@property (nonatomic,retain)  UILabel *teachreLabel;
@property (nonatomic,retain)  UILabel *huizhiLabel;
@property (nonatomic,retain)  GKNotice *notice;
@property (nonatomic,assign) id<noticeCelldelegate>delegate;
@property (nonatomic,retain)  UIImageView *IconImageView;

@end


@protocol noticeCelldelegate <NSObject>

-(void)clickImageViewLookImage:(NSString *)path;

@end
