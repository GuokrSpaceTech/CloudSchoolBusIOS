//
//  ContentUpCell.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-22.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ContentUpCell.h"
#import "ETKids.h"
#import <QuartzCore/QuartzCore.h>


@implementation ContentUpCell
@synthesize nameLab,lineView,bView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = CELLCOLOR;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 45)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        [view release];
        self.bView = view;
        
        UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(10, 44 + 10, 300, 1)];
        lView.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f];
        [self.contentView addSubview:lView];
        [lView release];
        self.lineView = lView;
        
        
        UIImageView *headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20 + 5, 20, 16)];
        headImgV.image = [UIImage imageNamed:@"cellPraise.png"];
        [self addSubview:headImgV];
        [headImgV release];
        
        for (int i = 0; i < HEADMAXCOUNT; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
            imgV.tag = 222 + i;
            imgV.layer.borderWidth = 3;
            imgV.layer.masksToBounds = YES;
            imgV.layer.borderColor = [UIColor whiteColor].CGColor;
            imgV.backgroundColor = [UIColor redColor];
            imgV.layer.cornerRadius = 10;
            [self.contentView addSubview:imgV];
            [imgV release];
        }
        
        UILabel *nLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nLab.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
        nLab.textColor = CONTENTTEXTCOLOR;
        nLab.backgroundColor = [UIColor clearColor];
        nLab.numberOfLines = 0;
        nLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:nLab];
        [nLab release];
        self.nameLab = nLab;
        
    }
    return self;
}

- (void)dealloc
{
    self.lineView = nil;
    self.nameLab = nil;
    self.bView = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
