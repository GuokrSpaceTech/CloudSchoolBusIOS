//
//  DetailContentCell.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-19.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "DetailContentCell.h"
#import "ETKids.h"
#import <QuartzCore/QuartzCore.h>

@implementation DetailContentCell
@synthesize titleLabel,contentLabel,headImgV,delegate,replyLabel,comImgV,timeLabel,bView,lineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = CELLCOLOR;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        [view release];
        self.bView = view;
        
        UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 1)];
        lView.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f];
        [self.contentView addSubview:lView];
        [lView release];
        self.lineView = lView;
        
        UIImageView *cImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 20, 16)];
        cImgV.image = [UIImage imageNamed:@"cellComment.png"];
        [self addSubview:cImgV];
        [cImgV release];
        self.comImgV = cImgV;
        
        
        UIImageView *hImgV = [[UIImageView alloc] initWithFrame:CGRectMake(DETAILLEFTMARGIN, 6, 30, 30)];
//        self.headImgV.image = [UIImage imageNamed:@"cellComment.png"];
        hImgV.layer.borderWidth = 2;
        hImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        hImgV.layer.masksToBounds = YES;
        hImgV.layer.cornerRadius = 10;
        hImgV.backgroundColor= [UIColor whiteColor];
        [self addSubview:hImgV];
        [hImgV release];
        self.headImgV = hImgV;
        
        
        
        UILabel *tLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.headImgV.frame.origin.x + self.headImgV.frame.size.width + 5, 5, 110, 15)];
        tLabel.backgroundColor=[UIColor clearColor];
        tLabel.textColor = [UIColor colorWithRed:145/255.0f green:166/255.0f blue:179/255.0f alpha:1.0f];
        tLabel.font=[UIFont systemFontOfSize:TITLEFONTSIZE];
        [self.contentView addSubview:tLabel];
        [tLabel release];
        self.titleLabel = tLabel;
        
        
        UILabel *rLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, 0, 0)];
        rLabel.textColor = [UIColor colorWithRed:145/255.0f green:166/255.0f blue:179/255.0f alpha:1.0f];
        rLabel.backgroundColor = [UIColor clearColor];
        rLabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        rLabel.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        rLabel.hidden = NO;
        [self.contentView addSubview:rLabel];
        [rLabel release];
        self.replyLabel = rLabel;
        
        UILabel *ctntLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, 0, 0)];
        ctntLabel.backgroundColor=[UIColor clearColor];
        ctntLabel.textColor = CONTENTTEXTCOLOR;
        ctntLabel.font=[UIFont systemFontOfSize:CONTENTFONTSIZE];
        ctntLabel.numberOfLines = 0;
        ctntLabel.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        ctntLabel.hidden = NO;
        [self.contentView addSubview:ctntLabel];
        [ctntLabel release];
        self.contentLabel = ctntLabel;
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5, self.titleLabel.frame.origin.y, 105, 20)];
        timeLab.textColor = TIMETEXTCOLOR;
        timeLab.textAlignment = NSTextAlignmentRight;
        timeLab.font=[UIFont systemFontOfSize:TIMEFONTSIZE];
        timeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:timeLab];
        [timeLab release];
        
        self.timeLabel = timeLab;

        
        
    }
    return self;
}

- (void)dealloc
{
    self.timeLabel = nil;
    self.contentLabel = nil;
    self.titleLabel = nil;
    self.headImgV = nil;
    self.comImgV = nil;
    self.bView = nil;
    self.lineView = nil;
    self.replyLabel = nil;
    
    [super dealloc];
    
}

- (void)doComments:(UIButton *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickComments:)]) {
        [delegate didClickComments:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
