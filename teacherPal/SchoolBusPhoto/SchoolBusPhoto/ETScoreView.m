//
//  ETScoreView.m
//  ssssss
//
//  Created by CaiJingPeng on 13-11-7.
//  Copyright (c) 2013年 cai jingpeng. All rights reserved.
//

#import "ETScoreView.h"
#import "KLineScrollView.h"


@implementation ETScoreView
@synthesize lineDataArray,curWeekScore,bottomScore;
    @synthesize year;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadData];
        
        
    }
    return self;
}
-(void)dealloc
{
    self.year=nil;
    self.lineDataArray=nil;
    self.curWeekScore=nil;
    self.bottomScore=nil;
    self.year=nil;
    [super dealloc];
}
- (void)loadData
{
    NSDate *date=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[formatter stringFromDate:date];
    [formatter release];
    self.year=[str substringToIndex:4];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"year", nil];
    [[EKRequest Instance] EKHTTPRequest:Credit parameters:param requestMethod:GET forDelegate:self];
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code{
    
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-01",@"credit_date",@"50",@"credit", nil];
//    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-02",@"credit_date",@"150",@"credit", nil];
//    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-03",@"credit_date",@"60",@"credit", nil];
//    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-04",@"credit_date",@"10",@"credit", nil];
//    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-05",@"credit_date",@"30",@"credit", nil];
//    NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-11-06",@"credit_date",@"90",@"credit", nil];
//    
//    NSArray *__dataArr = [NSArray arrayWithObjects:dic,dic1,dic2,dic3,dic4,dic5,nil];

    
    
    if(code==1 && method==Credit)
    {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        NSLog(@"%@",dic);
        NSArray *arr=[dic objectForKey:@"month_list"];
    
//        for (int i=0; i<; <#increment#>) {
//            <#statements#>
//        }
        NSMutableArray *dataArr=[[NSMutableArray alloc]init];
        for (int i=0; i<[arr count]; i++) {
            
            [dataArr addObject:[arr objectAtIndex:i]];

        }
        
        
        self.lineDataArray=dataArr;
        [dataArr release];
        if([dic objectForKey:@"week_sum"])
        {
        self.curWeekScore=[NSString stringWithFormat:@"%@",[dic objectForKey:@"week_sum"]];
        }
        else
        {
            self.curWeekScore=@"0";
        }

    }
}

- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)setLineDataArray:(NSArray *)dataArray
{
    [dataArray retain];
    if (lineDataArray != nil) {
        [lineDataArray release];
    }
    lineDataArray = dataArray;
    
    [self setNeedsDisplay];
}

- (void)setCurWeekScore:(NSString *)weekScore
{
    [weekScore retain];
    if (curWeekScore != nil) {
        [curWeekScore release];
    }
    curWeekScore = weekScore;
    
    [self setNeedsDisplay];
}
- (void)setBottomScore:(NSArray *)bScore
{
    [bScore retain];
    if (bottomScore != nil) {
        [bottomScore release];
    }
    bottomScore = [bScore retain];
    
    [self setNeedsDisplay];
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSMutableArray *score = [NSMutableArray array];
    NSMutableArray *date = [NSMutableArray array];
    
    for (int i = 0; i<self.lineDataArray.count; i++) {
        NSDictionary *dic = [self.lineDataArray objectAtIndex:i];
        [score addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit"]]];
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"credit_date"]];
        [date addObject:[str substringFromIndex:5]];
    }
    
    NSLog(@"%@,%@",date,score);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.text = NSLocalizedString(@"Daily", @"");
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
    [label release];
    
    
    KLineScrollView *kline = [[KLineScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height - 215) AndData:score xTitle:date];
    kline.showsHorizontalScrollIndicator = NO;
    kline.showsVerticalScrollIndicator = NO;
    kline.backgroundColor = [UIColor clearColor];
    [self addSubview:kline];
    [kline release];
    
       NSString *imagestr=[[NSBundle mainBundle]pathForResource:@"scoreBack_new" ofType:@"png"];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 215, 320, 215)];
    imgV.image = [UIImage imageWithContentsOfFile:imagestr];
    [self addSubview:imgV];
    [imgV release];
    
    UILabel *weekScore = [[UILabel alloc] initWithFrame:CGRectMake(160 - 35, imgV.frame.origin.y + 37, 70, 20)];
    weekScore.backgroundColor = [UIColor clearColor];
    weekScore.font = [UIFont fontWithName:@"FZZongYi-M05S" size:20];
    weekScore.textAlignment = NSTextAlignmentCenter;
    if (self.curWeekScore != nil) {
        weekScore.text = self.curWeekScore;
    }
    weekScore.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:1.0f];
    [self addSubview:weekScore];
    [weekScore release];
    
    
    UILabel *weekText = [[UILabel alloc] initWithFrame:CGRectMake(160 - 35, imgV.frame.origin.y + 53, 70, 20)];
    weekText.backgroundColor = [UIColor clearColor];
    weekText.font = [UIFont fontWithName:@"FZZongYi-M05S" size:13];
    weekText.textAlignment = NSTextAlignmentCenter;
    weekText.text = NSLocalizedString(@"week", @"");
    weekText.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:1.0f];
    [self addSubview:weekText];
    [weekText release];
    
//    "ask"="我要提问";
//    "Daily"="每日增长"
//    "week"="本周积分";
//    
//    "Product"="商品积分";
//    "Photo"="拍照积分";
//    "Sharing"="推广积分";
    
    
    NSArray *titArr = [NSArray arrayWithObjects:NSLocalizedString(@"Product", @""),NSLocalizedString(@"Photo", @""),NSLocalizedString(@"Sharing", @""), nil];
    for (int i = 0; i < 3; i++) {
        
        UILabel *weekText = [[UILabel alloc] initWithFrame:CGRectMake(10 + i*110, imgV.frame.origin.y + 115, 80, 20)];
        weekText.backgroundColor = [UIColor clearColor];
        weekText.font = [UIFont fontWithName:@"FZZongYi-M05S" size:15];
        weekText.textAlignment = NSTextAlignmentCenter;
        weekText.text = [titArr objectAtIndex:i];
        weekText.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
        [self addSubview:weekText];
        [weekText release];
        
        UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(10 + i*110, imgV.frame.origin.y + 140, 80, 40)];
        scoreLab.backgroundColor = [UIColor clearColor];
        scoreLab.font = [UIFont fontWithName:@"FZZongYi-M05S" size:28];
        scoreLab.textAlignment = NSTextAlignmentCenter;
        if (self.bottomScore != nil) {
            
            if([bottomScore count]>0)
            scoreLab.text = [self.bottomScore objectAtIndex:i];
        }
        if (i == 0)
        {
            scoreLab.textColor = [UIColor redColor];
        }
        else if (i == 1)
        {
            scoreLab.textColor = [UIColor orangeColor];
        }
        else
        {
            scoreLab.textColor = [UIColor colorWithRed:139/255.0f green:198/255.0f blue:212/255.0f alpha:1.0f];
        }
        [self addSubview:scoreLab];
        [scoreLab release];
        
        
        UILabel *yearLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        yearLab.center = CGPointMake(scoreLab.center.x, scoreLab.center.y + 30);
        yearLab.backgroundColor = [UIColor clearColor];
        yearLab.font = [UIFont fontWithName:@"FZZongYi-M05S" size:15];
        yearLab.textAlignment = NSTextAlignmentCenter;
        yearLab.text = [NSString stringWithFormat:@"%@%@",year,NSLocalizedString(@"year", @"")];
        yearLab.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
        [self addSubview:yearLab];
        [yearLab release];
        
    }
    
    
//    NSLog(@"%@",[UIFont familyNames]);
}


@end
