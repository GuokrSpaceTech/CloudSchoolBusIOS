//
//  ETActivityCell.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETActivityCell.h"

#import "NSDate+convenience.h"
@implementation ETActivityCell
@synthesize titleLabel,timeLabel,statusLabel;
@synthesize btn;
@synthesize events;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 220, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 260, 18)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
      //  self.timeLabel.textColor = TIMETEXTCOLOR;
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.timeLabel];
        [self.timeLabel release];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 80, 15, 80, 20)];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.statusLabel];
        [self.statusLabel release];
        
        //s0elf.contentView.backgroundColor = CELLCOLOR;
        
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(320-100, 40, 90, 20);
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickNum:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70-2, 320, 2)];
        line.image = [UIImage imageNamed:@"cellline.png"];
        [self addSubview:line];
        [line release];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
        
    }
    return self;
}
-(void)setEvents:(ETEvents *)_events
{
    [events release];
    events=[_events retain];
    
    titleLabel.text = events.title;
    
    //    cell.timeLabel.text = event.addtime;
    
    //---- calculate time -------
    
    [btn setTitle:[NSString stringWithFormat:@"报名人数：%@人",events.num] forState:UIControlStateNormal];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *addDate = [format dateFromString:events.addtime];
    
    
    NSString *time = [NSString stringWithFormat:@"%d",(int)[addDate timeIntervalSince1970]];
    
    int cDate = [[NSDate date] timeIntervalSince1970];
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    int sub = cDate - time.intValue;
    
    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,NSLocalizedString(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60)
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),NSLocalizedString(@"hoursago", @"")];
    }
    else if (pDate.year == [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else if (pDate.year < [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"error time"];
    }
    
    
    if (time !=nil) {
        timeLabel.text = dateStr;
    }
    
    
    
    
    
    
    NSString *status ;
    
    if ([events.SignupStatus isEqualToString:@"1"]) {
        status = [NSString stringWithFormat:@"%@",NSLocalizedString(@"activeStatus4", @"进行中")];
    }
    else if ([events.SignupStatus isEqualToString:@"-1"]){
        status = [NSString stringWithFormat:@"%@",NSLocalizedString(@"activeStatus1", @"未开始")];
    }
    else if ([events.SignupStatus isEqualToString:@"-2"]){
        status = [NSString stringWithFormat:@"%@",NSLocalizedString(@"activeStatus2", @"已结束")];
    }
    else if ([events.SignupStatus isEqualToString:@"-3"]){
        status = [NSString stringWithFormat:@"%@",NSLocalizedString(@"activeStatus3", @"满员")];
    }
    else{
        status = @"";
    }
    
    statusLabel.text = status;
    
}
-(void)clickNum:(UIButton *)button
{
    
    if([events.num isEqualToString:@"0"])
    {
        return;
    }

    NSString *message=@"";
    for (int i=0; i<[events.peopleArr count]; i++) {
        NSDictionary *dic=[events.peopleArr objectAtIndex:i];
        
        NSString *cnname=[dic objectForKey:@"cnname"];
        message=[NSString stringWithFormat:@"%@ %@",message,cnname];
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"报名名单" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
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
