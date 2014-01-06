//
//  ETActivityCell.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETActivityCell.h"
#import "ETKids.h"

@implementation ETActivityCell
@synthesize titleLabel,timeLabel,statusLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 220, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:TITLEFONTSIZE];
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 260, 18)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = TIMETEXTCOLOR;
        self.timeLabel.font = [UIFont systemFontOfSize:TIMEFONTSIZE];
        [self addSubview:self.timeLabel];
        [self.timeLabel release];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 80, 70/2.0f - 10, 80, 20)];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.font = [UIFont systemFontOfSize:CONTENTFONTSIZE - 2];
        [self addSubview:self.statusLabel];
        [self.statusLabel release];
        
        self.contentView.backgroundColor = CELLCOLOR;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70-2, 320, 2)];
        line.image = [UIImage imageNamed:@"cellline.png"];
        [self addSubview:line];
        [line release];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.timeLabel = nil;
    self.statusLabel = nil;
    
    
    [super dealloc];
}

@end
