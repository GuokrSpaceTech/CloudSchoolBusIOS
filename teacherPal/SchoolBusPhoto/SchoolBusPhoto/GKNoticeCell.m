//
//  GKNoticeCell.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-8.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKNoticeCell.h"

@implementation GKNoticeCell
@synthesize titleLable,timeLabel,contentlabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    self.titleLable=nil;
    self.timeLabel=nil;
    self.contentlabel=nil;
    [super dealloc];
}
@end
