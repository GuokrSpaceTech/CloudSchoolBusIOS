//
//  DetailContentCell.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-19.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   DetailContentCell
 *  @brief  评论详细页面自定义cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>



@class DetailContentCell;

@protocol DetailContentCellDelegate <NSObject>

/// 点击评论回调.
- (void)didClickComments:(DetailContentCell *)cell;

@end

@interface DetailContentCell : UITableViewCell
{
    
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIImageView *headImgV;
@property (nonatomic, retain) UILabel *replyLabel;
@property (nonatomic, retain) id<DetailContentCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *comImgV;
@property (nonatomic, retain) UILabel *timeLabel;

@property (nonatomic, retain) UIView *bView;
@property (nonatomic, retain) UIView *lineView;






@end
