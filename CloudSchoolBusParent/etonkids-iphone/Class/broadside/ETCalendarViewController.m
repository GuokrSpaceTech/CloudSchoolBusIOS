//
//  ETCalendarViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-23.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETCalendarViewController.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import "NSDate+convenience.h"
#import "ETCoreDataManager.h"

@interface ETCalendarViewController ()

@end

@implementation ETCalendarViewController
@synthesize fesArr,attArr;


- (void)dealloc
{
    self.fesArr = nil;
    self.attArr = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 46 + (ios7 ? 20 : 0), 320, iphone5 ? (548 - 46) : (460 - 46))];
    bView.backgroundColor = [UIColor colorWithRed:238/255.0f green:235/255.0f blue:226/255.0f alpha:1.0f];
    [self.view addSubview:bView];
    [bView release];
    
    //    middleView =[[UIImageView alloc]initWithFrame:CGRectZero];
    //    [self.view addSubview:middleView];
    //    middleView.hidden=YES;
    //    [middleView release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"checkAndCalendar", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
//    UIScrollView *mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, iphone5 ? (548 - 46 - 57) : (460 - 46 - 57))];
//    mainSV.backgroundColor = CELLCOLOR;
//    mainSV.contentSize = CGSizeMake(320, 460);
//    [self.view addSubview:mainSV];
//    [mainSV release];
    
    myCalendar = [[VRGCalendarView alloc] init];
    myCalendar.delegate=self;
    [self.view addSubview:myCalendar];
    [myCalendar release];
    
    
    float positiony=iphone5 ? (548-97) : (460-97);

    positiony=(ios7?(positiony+20):positiony);
    
//    float positiony = 460-97;
    
    
    UIView *msgView = [[UIView alloc] initWithFrame:CGRectMake(8, positiony, 305, 85)];
    msgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:msgView];
    [msgView release];

    UIImageView *infoBackImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 307, 65)];
    infoBackImgV.image = [UIImage imageNamed:@"infoBack2.png"];
    [msgView addSubview:infoBackImgV];
    [infoBackImgV release];
    
    attLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 4, 150, 25)];
    attLabel.text = LOCAL(@"noMsgAtt", @"");
    attLabel.backgroundColor = [UIColor clearColor];
    attLabel.font = [UIFont systemFontOfSize:15];
    [msgView addSubview:attLabel];
    [attLabel release];
    
    fesLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 34, 150, 25)];
    fesLabel.text = LOCAL(@"noMsgFes", @"");
    fesLabel.font = [UIFont systemFontOfSize:15];
    fesLabel.backgroundColor = [UIColor clearColor];
    [msgView addSubview:fesLabel];
    [fesLabel release];
    
    UIImageView *attImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    attImgV.image = [UIImage imageNamed:@"attimg.png"];
    attImgV.center = CGPointMake(110, attLabel.center.y);
    [msgView addSubview:attImgV];
    [attImgV release];
    
    fesImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    fesImgV.image = [UIImage imageNamed:@"fesimg.png"];
    fesImgV.center = CGPointMake(110, fesLabel.center.y);
    [msgView addSubview:fesImgV];
    [fesImgV release];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8, 73, 320, 25)];
    countLabel.backgroundColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:199/255.0f alpha:1.0f];
    countLabel.textColor = [UIColor whiteColor];
    [msgView addSubview:countLabel];
    [countLabel release];
    
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"d";
    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 50, 50)];
    dateLabel.text = [format stringFromDate:[NSDate date]];
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:25];
    dateLabel.backgroundColor = [UIColor clearColor];
    [msgView addSubview:dateLabel];
    [dateLabel release];
    
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doBack:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    
    
//    [self makeStatus:[NSDate date]];
    // Do any additional setup after loading the view from its nib.
}

- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);
    if(method == attendance && code == 1)
    {
        id result =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"校历返回格式错误");
            return;
        }
        
        NSDictionary *dic = result;
//        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",dic);
        
        self.attArr = [dic objectForKey:@"attendance"];
        
        self.fesArr = [dic objectForKey:@"festival"];
        
//        NSLog(@"%d",self.calendarDic.count);
        
        [self updateCalendarView];
        
                
        NSString *m = [param objectForKey:@"month"];
        [ETCoreDataManager removeCalendarByMonth:m];
        [ETCoreDataManager addCalendar:self.fesArr withMonth:m];
        [ETCoreDataManager removeAttendanceByMonth:m];
        [ETCoreDataManager addAttendance:self.attArr withMonth:m];
        
        
        //判定如果是当前月则更新点击状态
        
        
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"MM"];
//        NSLog(@"%@,%@",[m substringFromIndex:2],[format stringFromDate:[NSDate date]]);
        if([[m substringFromIndex:2] isEqualToString:[format stringFromDate:[NSDate date]]])
        {
            [self makeStatus:[NSDate date]];
        }
        
    }
}
- (void)getErrorInfo:(NSError *)error
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)updateCalendarView
{
    NSMutableArray *markDays = [NSMutableArray array];
    
//    NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
    
    if (self.fesArr != nil && self.fesArr.count != 0) {
        
//        NSArray *keys = [fesDic allKeys];
        NSMutableArray *dArr = [NSMutableArray array];
        for (int i = 0; i<self.fesArr.count; i++) {
            
            NSString *str = [self.fesArr objectAtIndex:i];
            [dArr addObject:[[str componentsSeparatedByString:@","] objectAtIndex:0]];
        }
        
        [markDays addObjectsFromArray:dArr];
        
    }
    
    NSLog(@"%@",markDays);
    
    [self calendarMark:self.attArr andschool:markDays];

}

-(void) makeStatus:(NSDate *)date
{
    attLabel.text =LOCAL(@"noMsgAtt", @"");
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyMMdd"];
    NSString * dateStr = [format stringFromDate:date];
    [format release];
    
    for(int i=0;i<[self.attArr count];i++)
    {
        NSDictionary * dateDic = [self.attArr objectAtIndex:i];
        NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
        if([dateStr isEqualToString:attendaceday])
        {
            int status = [[dateDic objectForKey:@"attendancetypeid"] intValue];
            if (status == 1)
            {
                attLabel.text = LOCAL(@"normalDuty", @"正常出勤");
            }
            else if (status == 2)
            {
                NSString *str = [NSString stringWithFormat:@"%@",[dateDic objectForKey:@"reason"]];
                if (![str isEqualToString:@"(null)"])
                {
                    attLabel.text = [NSString stringWithFormat:@"%@(%@)",LOCAL(@"queqin", @"") , str];
                }
                
            }
            else if (status == 3)
            {
                attLabel.text = [NSString stringWithFormat:@"%@",LOCAL(@"budeng", @"")];
            }
            
            break;
        }
    }
    
    NSDateFormatter *tempFormate = [[NSDateFormatter alloc] init];
    [tempFormate setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [tempFormate stringFromDate:date];
    
//    NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
    
//    fesLabel.text = LOCAL(@"noMsgFes", @"");
    fesLabel.text = @"";
    fesImgV.hidden = YES;
    
    if (self.fesArr != nil && self.fesArr.count != 0) {
        
        for (int i = 0; i<self.fesArr.count; i++) {
            
            NSString *fstr = [self.fesArr objectAtIndex:i];
            
            NSString *fdateStr = [[fstr componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *fname = [[fstr componentsSeparatedByString:@","] objectAtIndex:1];
            
            if ([str isEqualToString:fdateStr]) {
                fesLabel.text = LOCAL(fname, @"");
                fesImgV.hidden = NO;
                break;
            }
            
        }
        
        
//        NSArray *keys = [fesDic allKeys];
//        for (int i = 0; i<keys.count; i++) {
//            
//            NSString *keyStr = [keys objectAtIndex:i];
//            
//            if ([festivalsKey containsObject:keyStr]) {
//                
//                NSArray *dateArr = [self.fesDic objectForKey:keyStr];
//                for (int j = 0; j < dateArr.count; j++) {
//                    
//                    NSString *fStr = [dateArr objectAtIndex:j];
//                    
//                    //NSLog(@"%@ %@",fStr, str);
//                    
//                    if ([str isEqualToString:fStr]) {
//                        fesLabel.text = LOCAL(keyStr, @"");
//                        fesImgV.hidden = NO;
//                        break;
//                    }
//                }
//                
//            }
//            
//            
//        }
    }
    
}


/**
 *	@brief  在日历中标记出勤和校历
 *
 *  @param  dateArr 出勤数据
 *	@param 	schArr  校历数据
 */
- (void)calendarMark:(NSArray *) dateArr andschool:(NSArray *)schArr

{
    NSMutableArray * mutDateArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray * quqinArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *budengArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for(int i=0;i<[dateArr count];i++)
    {
        NSDictionary * dateDic = [dateArr objectAtIndex:i];
        NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
        
        int type=[[dateDic objectForKey:@"attendancetypeid"] integerValue];
        
        NSMutableString * year = [NSMutableString stringWithCapacity:1];
        [year setString:[NSString stringWithFormat:@"20%@",[attendaceday substringToIndex:2]]];
        NSString * month = [attendaceday substringWithRange:NSMakeRange(2, 2)];
        
        NSString * day = [attendaceday substringWithRange:NSMakeRange(4, 2)];
        NSString * dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate * myDate = [format dateFromString:dateStr];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:myDate];
        //本地登录状态下calendar.currentMonth = nil;所以判定.
        NSDate * tmpDate = nil;
        if(myCalendar.currentMonth != nil)
            tmpDate = myCalendar.currentMonth;
        else
            tmpDate = [NSDate date];
        
        NSDateComponents *components_A = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tmpDate];
        
        NSInteger myMonth = [components month];
        NSInteger currMonth = [components_A month];
        NSInteger myYear = [components year];
        NSInteger currYear = [components_A year];
        
        [format release];
        
        if(myMonth != currMonth || myYear != currYear)
            continue;
        
        if(type==1)
            [mutDateArr addObject:myDate];
        if(type==2)
            [quqinArr addObject:myDate];
        if (type == 3) {
            [budengArr addObject:myDate];
        }
    }
    
    if(mutDateArr.count >0)
        [myCalendar markDates:mutDateArr];
    if(quqinArr.count >0)
        [myCalendar markqueqinDates:quqinArr];
    if (budengArr.count > 0) {
        [myCalendar markedBuDengDates:budengArr];
    }
    
    NSString * totalDays =LOCAL(@"allDay", @"本月出勤总数:") ;//; @"本月出勤总数:";
    totalDays = [totalDays stringByAppendingFormat:@"%d",mutDateArr.count + budengArr.count];
    countLabel.text = totalDays;
    
    [mutDateArr release];
    
    
    
    
    if (schArr != nil) {
        
        NSMutableArray *schDateArr = [NSMutableArray array];
        
        for (int i = 0; i < [schArr count]; i++) {
            NSString *dateStr = [schArr objectAtIndex:i];
            
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSDate * myDate = [format dateFromString:dateStr];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:myDate];
            //本地登录状态下calendar.currentMonth = nil;所以判定.
            NSDate * tmpDate = nil;
            if(myCalendar.currentMonth != nil)
                tmpDate = myCalendar.currentMonth;
            else
                tmpDate = [NSDate date];
            
            NSDateComponents *components_A = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tmpDate];
            
            NSInteger myMonth = [components month];
            NSInteger currMonth = [components_A month];
            NSInteger myYear = [components year];
            NSInteger currYear = [components_A year];
            
            [format release];
            
            if(myMonth != currMonth || myYear != currYear)
                continue;
            
            [schDateArr addObject:myDate];
        }
        
//        NSLog(@"#####  %@",schDateArr);
        //        if(mutDateArr.count >0)
        [myCalendar markSchoolDates:schDateArr];
    }
    
}

-(NSString *) attendanceStatus:(int) typeid
{
    switch (typeid)
    {
        case 1:
            return LOCAL(@"normalDuty", @"正常出勤") ;
        case 2:
            return LOCAL(@"affair", @"请事假") ;
        case 3:
            return LOCAL(@"sick", @"请病假") ;
        case 4:
            return LOCAL(@"queqin", @"缺勤") ;
        default:
            return LOCAL(@"normalDuty", @"正常出勤");
    }
}



- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(int)year switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
//    NSLog(@"%d,%d",year,month);
    NSString *s = [NSString stringWithFormat:@"%d",year];
    NSString *pStr = [NSString stringWithFormat:@"%@%02d",[s substringFromIndex:2],month];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month",nil];

    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"2014-06",@"month", nil];
    [[EKRequest Instance] EKHTTPRequest:attendancemanager parameters:dic requestMethod:GET forDelegate:self];
    
//    if ([calendarView.currentMonth month] == [[NSDate date] month])
//    {
//        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
//        [com requestLoginWithComplete:^(NSError *err){
//            [[EKRequest Instance] EKHTTPRequest:attendance parameters:param requestMethod:GET forDelegate:self];
//        }];
//        
//    }
//    else
//    {
//        NSArray *result = [ETCoreDataManager searchAttendanceByMonth:pStr];
//        
//        if (result == nil || result.count == 0) {
//            
//            ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
//            [com requestLoginWithComplete:^(NSError *err){
//                [[EKRequest Instance] EKHTTPRequest:attendance parameters:param requestMethod:GET forDelegate:self];
//            }];
//            
//        }
//        else
//        {
//            self.attArr = [NSMutableArray arrayWithArray:[ETCoreDataManager searchAttendanceByMonth:pStr]];
//            self.fesArr = [NSMutableArray arrayWithArray:[ETCoreDataManager searchCalendarByMonth:pStr]];
//            NSLog(@"%@ , %@",self.attArr,self.fesArr);
//            
//            [self updateCalendarView];
//        }
//    }
//    
    
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"d";
    dateLabel.text = [format stringFromDate:date];
    
    [self makeStatus:date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
