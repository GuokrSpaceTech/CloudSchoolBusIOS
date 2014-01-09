//
//  GKNoticeCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKNoticeCell : UITableViewCell
{
    UILabel *titleLable;
    UILabel *contentlabel;
    UILabel *timeLabel;
}
@property (nonatomic,retain)  UILabel *titleLable;
@property (nonatomic,retain)  UILabel *contentlabel;
@property (nonatomic,retain)  UILabel *timeLabel;
@end
