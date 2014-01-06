
#import "DutyDayView.h"
#import "ETKids.h"
@implementation DutyDayView

@synthesize dayLabel,dutyStatus,festivalLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel * _dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, self.frame.size.height-10)];

        _dayLabel.textColor=[UIColor colorWithRed:24/255.0 green:117/255.0 blue:176/255.0 alpha:1];
      
        _dayLabel.textAlignment=UITextAlignmentCenter;
        _dayLabel.font=[UIFont fontWithName:@"Arial" size:40];
        _dayLabel.backgroundColor=[UIColor clearColor];
        self.dayLabel = _dayLabel;
        [self addSubview:_dayLabel];
        [_dayLabel release];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 5, 1, self.frame.size.height-10)];
        imageView.image=[UIImage imageNamed:@"duty_line.png"];
        [self addSubview:imageView];
        [imageView release];
        
        
        UILabel * _dutyStatus=[[UILabel alloc]initWithFrame:CGRectMake(95, (self.frame.size.height-10)/2 -15, 180, 20)];
        _dutyStatus.backgroundColor=[UIColor clearColor];
        _dutyStatus.text=@"正常";
        _dutyStatus.font=[UIFont systemFontOfSize:18];
        self.dutyStatus = _dutyStatus;
        [self addSubview:_dutyStatus];
        [_dutyStatus release];
        
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(95-15, (self.frame.size.height-10)/2 - 10, 9, 9)];
        imageView1.image=[UIImage imageNamed:@"bluePoint.png"];
        [self addSubview:imageView1];
        [imageView1 release];
        
        UILabel *festivalLab = [[UILabel alloc] initWithFrame:CGRectMake(95, (self.frame.size.height-10)/2 - 5 + 20, 180, 20)];
        festivalLab.backgroundColor = [UIColor clearColor];
        festivalLabel.font=[UIFont systemFontOfSize:18];
        [self addSubview:festivalLab];
        [festivalLab release];
        
        self.festivalLabel = festivalLab;
        
    }
    return self;
}

-(void)dealloc
{
    self.dayLabel=nil;
    self.dutyStatus=nil;

    [super dealloc];
}

@end
