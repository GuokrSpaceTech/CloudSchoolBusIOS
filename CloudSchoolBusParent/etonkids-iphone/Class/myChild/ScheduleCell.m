//
//  ScheduleCell.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-3.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ScheduleCell.h"
#import "ETKids.h"
@implementation ScheduleCell
@synthesize leftView,courseLabel,timeLabel,backView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = CELLCOLOR;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView release];
        
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 100, 50)];
        self.leftView.backgroundColor = [UIColor colorWithRed:164/255.0f green:228/255.0f blue:243/255.0f alpha:1.0f];
        [self.contentView addSubview:self.leftView];
        [self.leftView release];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel release];
        
        self.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 0)];
        self.courseLabel.textAlignment = NSTextAlignmentCenter;
        self.courseLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.courseLabel.backgroundColor = [UIColor clearColor];
        self.courseLabel.numberOfLines = 0;
        self.courseLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.courseLabel];
        [self.courseLabel release];
               
         
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.courseLabel = nil;
    self.timeLabel = nil;
    self.leftView = nil;
    self.backView = nil;
    
    [super dealloc];
}
@end
