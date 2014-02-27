//
//  ClassShareCell.h
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

/**
 *	@file   ClassShareCell
 *  @brief  班级分享界面tabelview 自定义cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ShareContent.h"
#import "MBProgressHUD.h"
#import "ETShowBigImageView.h"
#import "ETShowBigImageViewController.h"
#import "EKRequest.h"
#import "UserLogin.h"


@class  ClassShareCell;

@protocol ClassShareCellDelegate <NSObject>

@optional

- (void) shareCell:(ClassShareCell *)_notice share:(ShareContent *)info;
- (void) shareWeibo:(ShareContent *)info withTag:(int) tag;
- (void) clickComment:(ShareContent *)content;
- (void) clickPraise:(UITableViewCell *)cell;
- (void) didTapImageWithImageArray:(NSArray *)imgArr showNumber:(int)num content:(ShareContent *)content;


-(void)playAudioStreamView:(ClassShareCell *)viewCell Info:(ShareContent *)info;

@end


typedef enum{
    Normal,
    Detail
    
} CellMode ;


@interface ClassShareCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIImageView *picImageView;
    
    UILabel *timeLabel;
    
    
    UIImageView *boundsImageView;
    UIImageView *lineImageView;
    
    UIImageView *photoImageView;
    NSString * bigImagePath;
    MBProgressHUD *HUD;
    
    
}

@property(nonatomic,assign) id<ClassShareCellDelegate>delegate;
@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *contentLabel;
@property(nonatomic,retain) UILabel *timeLabel;
@property(nonatomic,retain) ShareContent *theShareCtnt;

@property(nonatomic,retain) UIButton *praiseButton;
@property(nonatomic,retain) UIButton *commentsButton;
@property(nonatomic,retain) UILabel *praiseLab;
@property(nonatomic,retain) UILabel *commentLab;
@property(nonatomic, retain) UIImageView *commentImgV;
@property(nonatomic, retain) UIImageView *praiseImgV;
@property (nonatomic, retain) UIImageView *backImgV;

@property (nonatomic, retain)NSMutableArray *photoImgVArr;

@property (nonatomic, retain)UIImageView *line;

@property (nonatomic, retain) UIImageView *triangle;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellMode:(CellMode)mode;

- (void)addPraiseNumber;
- (void)subPraiseNumber;

@end
