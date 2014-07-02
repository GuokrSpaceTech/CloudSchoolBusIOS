//
//  GKHealthCell.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-20.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKHealthCell.h"

@implementation GKHealthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
       // 137+20
        
        UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 320-16, 137)];
        bgImageView.backgroundColor=[UIColor clearColor];
        bgImageView.image=[UIImage imageNamed:@"health_cellBG.png"];
        [self.contentView addSubview:bgImageView];
        [bgImageView release];
        
        
       // health_cellBG
       // health_topblue
        UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 320-16, 36)];
        topImageView.backgroundColor=[UIColor clearColor];
        topImageView.image=[UIImage imageNamed:@"health_topblue.png"];
        [self.contentView  addSubview:topImageView];
        [topImageView release];
        
        
        _titleLatel=[[UILabel alloc]initWithFrame:CGRectMake(8+10, 10, 320-16-20, 36)];
        _titleLatel.backgroundColor=[UIColor clearColor];
        //_titleLatel.text=@"眼科";
        _titleLatel.textColor=[UIColor whiteColor];
        [self.contentView  addSubview:_titleLatel];
        
        
        _contentLatel=[[UILabel alloc]initWithFrame:CGRectMake(8+10, 10+40, 320-16-20, 36)];
        _contentLatel.backgroundColor=[UIColor clearColor];
        //_contentLatel.text=@"为什么我的眼里常含泪水,因为我对这土地爱的深沉";
        [self.contentView  addSubview:_contentLatel];
        
        
        _timeLatel=[[UILabel alloc]initWithFrame:CGRectMake(8+10, 8+137-25, 120, 20)];
        _timeLatel.backgroundColor=[UIColor clearColor];
        _timeLatel.textColor=[UIColor grayColor];
        _timeLatel.font=[UIFont systemFontOfSize:14];
        //_timeLatel.text=@"2014-02-16";
        [self.contentView  addSubview:_timeLatel];
        
        
        _pointImageView=[[UIImageView alloc]initWithFrame:CGRectMake(300-16-60, 8+137-18, 7, 7)];
        _pointImageView.image=[UIImage imageNamed:@"health_point.png"];
        _pointImageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_pointImageView];
        
        _stateLatel=[[UILabel alloc]initWithFrame:CGRectMake(300-16-50, 8+137-25, 80, 20)];
        _stateLatel.backgroundColor=[UIColor clearColor];
        _stateLatel.textColor=[UIColor grayColor];
        _stateLatel.font=[UIFont systemFontOfSize:14];
 
        //_stateLatel.text=@"待处理";
        [self.contentView  addSubview:_stateLatel];
        
//        UIImageView
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)dealloc
{
    self.titleLatel=nil;
    self.contentLatel=nil;
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
