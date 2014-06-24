//
//  GKSearchCell.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKStudentAdd.h"
#import "EKRequest.h"

@class GKSearchCell;
@protocol searchCelldelegate <NSObject>

-(void)cell:(GKSearchCell *)_cell  student:(GKStudentAdd *)st;

@end
@interface GKSearchCell : UITableViewCell
{
    UIButton *seleBtn;
}
@property (nonatomic,assign)id <searchCelldelegate> delegate;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *telLabel;
@property(nonatomic,retain) UILabel *agelabel;
@property(nonatomic,retain) UILabel *sexLabel;
@property(nonatomic,retain) UILabel *classLabel;
@property (nonatomic,retain)GKStudentAdd *student;
@end

