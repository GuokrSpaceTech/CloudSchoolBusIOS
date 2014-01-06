//
//  FoodCell.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-3.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   FoodCell
 *  @brief  自定义食谱cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <UIKit/UIKit.h>

@interface FoodCell : UITableViewCell
{
    UIImageView  *LeftImageview;
    UILabel  *ChineseLabel;
    UILabel  *EnglishLabel;
}

@property(nonatomic,retain)IBOutlet UIImageView  *LeftImageview;
@property(nonatomic,retain)IBOutlet UILabel      *ChineseLabel;
@property(nonatomic,retain)IBOutlet UILabel      *EnglishLabel;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIView *leftBackView;
@property (nonatomic, retain) UILabel *leftTitleLabel;
@end
