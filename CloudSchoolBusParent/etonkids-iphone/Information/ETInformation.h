//
//  ETInformation.h
//  etonkids-iphone
//
//  Created by Simon on 13-7-24.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETInformation
 *  @brief  教育资讯界面自定义cell
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>

@interface ETInformation : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *dateLabel;
}
@property(nonatomic,retain)   UILabel *nameLabel;
@property(nonatomic,retain)   UILabel *dateLabel;

@end
