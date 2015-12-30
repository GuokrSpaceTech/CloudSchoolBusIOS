//
//  HeaderCollectionReusableView.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/30.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic,weak) IBOutlet UILabel *classLabel;
@property (nonatomic,weak) IBOutlet UILabel *schoolLabel;
@property (nonatomic,weak) IBOutlet UIImageView *teacherAvatar;

@end
