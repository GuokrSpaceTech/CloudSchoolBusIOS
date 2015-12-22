//
//  OperationCollectionViewCell.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/22.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ClassModule.h"


@interface OperationCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@property (strong,nonatomic) ClassModule *module;

@end
