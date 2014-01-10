//
//  GKNoticeCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNotice.h"
@interface GKNoticeCell : UITableViewCell
{
    UILabel *titleLable;
    UILabel *contentlabel;
    UILabel *timeLabel;
    
    UIView *bottomView;
    
    UIImageView *IconImageView;

    UIImageView *lineImageView;
}
@property (nonatomic,retain)  UILabel *titleLable;
@property (nonatomic,retain)  UILabel *contentlabel;
@property (nonatomic,retain)  UILabel *timeLabel;

@property (nonatomic,retain)  UILabel *huizhiLabel;
@property (nonatomic,retain)  GKNotice *notice;

@property (nonatomic,retain)  UIImageView *IconImageView;

@end
