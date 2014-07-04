//
//  CYDetailCell.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemDetail.h"
@protocol DetailCellDelegate;
@interface CYDetailCell : UITableViewCell
@property (nonatomic,retain)ProblemDetail *detail;
@property (nonatomic,retain)UILabel *labelcontent;

@property (nonatomic,retain)UILabel *timelabel;
@property (nonatomic,assign)id<DetailCellDelegate>delegate;

@property (nonatomic,retain)UIImageView *photoImageView;
@property (nonatomic,retain)UILabel *namelabel;
@property (nonatomic,retain)UILabel *levelLabel;
@end

@protocol DetailCellDelegate <NSObject>

-(void)clickToDoctorDetailController;

@end