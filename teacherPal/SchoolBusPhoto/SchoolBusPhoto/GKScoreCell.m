//
//  GKScoreCell.m
//  ssssss
//
//  Created by CaiJingPeng on 13-11-1.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "GKScoreCell.h"

@implementation GKScoreCell
@synthesize scoreView,dateLabel,markScore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
        [self addSubview:sview];
        [sview release];
        
        self.scoreView = sview;
        
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 15)];
//        label1.backgroundColor = [UIColor blueColor];
//        label1.font = [UIFont systemFontOfSize:10];
        //        label.layer.anchorPoint = CGPointMake(0, 1);
        //        label.transform = CGAffineTransformMakeRotation(M_PI_2);
//        [self addSubview:label1];
//        [label1 release];
        
      
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-10, 10, 35, 15)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.anchorPoint = CGPointMake(0.5, 0.5);
        label.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:label];
        [label release];
        
        self.dateLabel = label;
        
        UIImageView *markImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 23)];
        markImgV.image = [UIImage imageNamed:@"markScore.png"];
        markImgV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        markImgV.transform = CGAffineTransformMakeRotation(M_PI_2);
        markImgV.hidden = YES;
        [self addSubview:markImgV];
        [markImgV release];
        
        self.markScore = markImgV;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
