//
//  ETActiveCell.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETActiveCell
 *  @brief  活动报名列表 自定义cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <UIKit/UIKit.h>

@interface ETActiveCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *dateLabel;
    
    UILabel *stateLabel;
    
}
@property(nonatomic,retain)   UILabel *nameLabel;
@property(nonatomic,retain)   UILabel *dateLabel;

@property(nonatomic,retain)   UILabel *stateLabel;
@end

