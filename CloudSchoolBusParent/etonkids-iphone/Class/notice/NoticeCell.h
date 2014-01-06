//
//  NoticeCell.h
//  etonkids-iphone
//
//  Created by wpf on 1/22/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

/**
 *	@file   NoticeCell
 *  @brief  通知消息cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "NoticeInfo.h"

@protocol noticeCelldelegate ;


@interface NoticeCell : UITableViewCell<UIAlertViewDelegate>

{
   
}
@property(nonatomic,assign) id<noticeCelldelegate>delegate;
@property(nonatomic,retain)UILabel *noticeTitleLabel;
@property(nonatomic,retain)UILabel *noticeContentLabel;
@property(nonatomic,retain)UILabel *noticeTimeLabel;

@property(nonatomic,retain)NoticeInfo *notice;
@property(nonatomic,retain)UIButton * buttonMore;
@property(nonatomic,retain)UIButton  *buttonreceipt;
@property(nonatomic,readonly)UILabel  *redlabel;

@property (nonatomic, retain) UIImageView *backImgV;
@property (nonatomic, retain) UIImageView *lineImgV;

@property (nonatomic, retain) NSMutableArray *photoImgVArr;
@property (nonatomic, retain)UIImageView *line; // bottom

@property (nonatomic, retain) UIImageView *triangle;

@end

@protocol noticeCelldelegate <NSObject>

/// 点击更多.
-(void)noticeCell:(NoticeCell *)_notice notice:(NoticeInfo *)info;

/// 点击分享.
-(void)share:(NoticeCell *)_notice notice:(NoticeInfo *)info;

// 点击回执
- (void)clickComfirmNoticeCell:(NoticeCell *)_notice;

- (void) didTapImageWithImageArray:(NSArray *)imgArr showNumber:(int)num content:(NoticeInfo *)notice;


@end