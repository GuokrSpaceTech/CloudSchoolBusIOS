//
//  ETInformation.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-24.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETInformation.h"

@implementation ETInformation
@synthesize nameLabel,dateLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 15,160, 30)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:nameLabel];
        
        
        dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+170,15, 100, 30)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:dateLabel];
        
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
