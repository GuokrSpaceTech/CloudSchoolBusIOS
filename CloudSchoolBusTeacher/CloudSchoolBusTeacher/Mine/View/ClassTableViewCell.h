//
//  ClassTableViewCell.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 1/7/16.
//  Copyright © 2016 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassObj.h"
#import "School.h"
@interface ClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionIndicatorImg;

@end
