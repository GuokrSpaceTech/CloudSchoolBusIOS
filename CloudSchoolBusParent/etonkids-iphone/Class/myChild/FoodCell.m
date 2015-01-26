//
//  FoodCell.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-3.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "FoodCell.h"
#import "ETKids.h"
@implementation FoodCell
@synthesize LeftImageview,ChineseLabel,EnglishLabel,backView,leftBackView,leftTitleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        if (!iphone5)
//        {
        
        self.contentView.backgroundColor = CELLCOLOR;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 140)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        [backView release];
        
        self.leftBackView = [[[UIView alloc] initWithFrame:CGRectMake(10, 5, 100, backView.frame.size.height)] autorelease];
        self.leftBackView.backgroundColor = [UIColor colorWithRed:164/255.0f green:228/255.0f blue:243/255.0f alpha:1.0f];
        [self.contentView addSubview:self.leftBackView];
        //[self.leftBackView release];
        
        self.LeftImageview=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)] autorelease];
        self.LeftImageview.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.LeftImageview];
       // [self.LeftImageview release];
            
        self.ChineseLabel=[[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 180, 0)] autorelease];
        self.ChineseLabel.textAlignment=NSTextAlignmentCenter;
        self.ChineseLabel.backgroundColor = [UIColor clearColor];
        self.ChineseLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.ChineseLabel.numberOfLines = 0;
        self.ChineseLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.ChineseLabel];
        //[self.ChineseLabel release];
        
        self.leftTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 40)] autorelease];
        self.leftTitleLabel.backgroundColor = [UIColor clearColor];
        self.leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.leftTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.leftTitleLabel];
        //[self.leftTitleLabel release];
        
        
        
//        self.EnglishLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 180, 0)];
//        self.EnglishLabel.backgroundColor = [UIColor blackColor];
//        self.EnglishLabel.textAlignment=NSTextAlignmentCenter;
//        self.EnglishLabel.lineBreakMode=NSLineBreakByWordWrapping;
//        self.EnglishLabel.numberOfLines = 0;
//        self.EnglishLabel.font=[UIFont systemFontOfSize:15];
//        [self.contentView addSubview:self.EnglishLabel];
//        [self.EnglishLabel release];
        

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
    self.leftBackView = nil;
    [LeftImageview release];
    [ChineseLabel release];
    [EnglishLabel release];
    [super dealloc];
}

@end
