//
//  ETActiveCell.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETActiveCell.h"

@implementation ETActiveCell
@synthesize dateLabel,nameLabel;
@synthesize stateLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 60/2.0-22,170, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        
        
        dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,60/2.0+3, 150,20)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:dateLabel];
        
        
        stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(190, (60-20)/2,320-170-20-15-20, 20)];
        stateLabel.backgroundColor=[UIColor clearColor];
        stateLabel.font=[UIFont systemFontOfSize:12];
        stateLabel.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:stateLabel];
        
        UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(320-20-15, (60-15)/2 , 15, 15)];
        arrowImageView.image=[UIImage imageNamed:@"right.png"];
        arrowImageView.tag=1111;
        [self.contentView addSubview:arrowImageView];
        [arrowImageView release];
        
        
        
        UIImageView *divisionImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 60-1 , 320, 1)];
        divisionImageView.image=[UIImage imageNamed:@"division.png"];
        divisionImageView.tag=1112;
        [self.contentView addSubview:divisionImageView];
        [divisionImageView release];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
