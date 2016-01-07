//
//  ContactGroupTableViewCell.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/23.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactGroupTableViewCell : UITableViewCell

@property UILabel *groupNameLabel;

- (void)setBadge:(int)number;
- (void)clearBadge;
-(void)setIcon:(UIImage *)iconImage;
@end
