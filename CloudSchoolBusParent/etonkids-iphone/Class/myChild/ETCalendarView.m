
#import "ETCalendarView.h"
#import "UserLogin.h"
#import "ETKids.h"
#import "ETCommonClass.h"

@implementation ETCalendarView

@synthesize listArr,calendar,schoolArr,calendarDic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        NSMutableArray * mutArr = [[NSMutableArray alloc] initWithCapacity:1];
        self.listArr = mutArr;
        [mutArr release];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        
        imageView.image=[UIImage imageNamed:@"calendarImage"];
        [self addSubview:imageView];
        [imageView release];
        
        [self addCalendar];
        
        UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if (user.loginStatus == LOGIN_OFF)
        {
            NSDictionary * response = [keyedArchiver getArchiver:@"CALENDAR" forKey:@"CALENDAR"];
            NSArray * arr = [response objectForKey:@"attendance"];
            if(response == nil || arr == nil) return self;
            [self.listArr setArray:arr];
            [self calendarMark:self.listArr andschool:nil];
        }
        else
        {
            if(HUD==nil)
            {
                HUD=[[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, 280, self.frame.size.height)];
                [self addSubview:HUD];
                [HUD release];
                [HUD show:YES];
                
            }
        }
    }
    return self;
}
-(void)LoginFailedresult:(NSString *)str
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
#pragma EKRequest_Delegate
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
         HUD=nil;
    }
    if(code == 1 && response != nil && method == attendance)
    {
        //缓存数据
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];

        NSLog(@"%@",dic);
        
        [keyedArchiver setArchiver:@"CALENDAR" withData:dic forKey:@"CALENDAR"];
        [self.listArr setArray:[dic objectForKey:@"attendance"]];
        
        
        NSMutableArray *markDays = [NSMutableArray array];
        
        NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
        
        
        self.calendarDic = [dic objectForKey:@"calendar"];
        
        NSLog(@"%d",self.calendarDic.count);
        
        if (self.calendarDic != nil && self.calendarDic.count != 0) {
            NSArray *keys = [calendarDic allKeys];
            for (int i = 0; i<keys.count; i++) {
                
                NSString *keyStr = [keys objectAtIndex:i];
                
                if ([festivalsKey containsObject:keyStr]) {
                    NSArray *cArr = [calendarDic objectForKey:keyStr];
                    [markDays addObjectsFromArray:cArr];
                    
                }
            }
        }
        
        
        
//        if (key != nil) {
//            self.schoolArr = [[dic objectForKey:@"calendar"] objectForKey:key];
//        }
//        else
//        {
//            self.schoolArr = nil;
//        }
        NSLog(@"%@",markDays);
        
        [self calendarMark:self.listArr andschool:markDays];
        //判定如果是当前月则更新点击状态
        static int st = 0;
        if(st == 0)
        {
            st = 1;
            [self makeStatus:[NSDate date]];
        }
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma --
-(void)dealloc
{
    self.listArr=nil;
    
    [super dealloc];
}

/// 添加日历.

-(void)addCalendar
{
    VRGCalendarView *myCalendar = [[VRGCalendarView alloc] init];
    myCalendar.delegate=self;
    self.calendar = myCalendar;
    [self addSubview:myCalendar];
    [myCalendar release];
    
    if(iphone5)
    {
        dutyView=[[DutyDayView alloc]initWithFrame:CGRectMake(5, 430, 281, 84)];
        dutyView.backgroundColor=[UIColor clearColor];
        dutyView.tag = 100;
        [self addSubview:dutyView];
        [dutyView release];
    }
    else
    {
        dutyView=[[DutyDayView alloc]initWithFrame:CGRectMake(4, self.frame.size.height-75-25, 279, 70)];
        dutyView.backgroundColor=[UIColor clearColor];
        dutyView.tag = 100;
        [self addSubview:dutyView];
        [dutyView release];
    }
 
    sumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, 320, 20)];
    sumLabel.backgroundColor=[UIColor clearColor];
    sumLabel.textColor=[UIColor whiteColor];
    [self addSubview:sumLabel]; 
    [sumLabel release];
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
    for(int i=0;i<[dateArr count];i++)
    {
        NSDictionary * dateDic = [dateArr objectAtIndex:i];
        NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
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
        if(calendar.currentMonth != nil)
            tmpDate = calendar.currentMonth;
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
        
        [mutDateArr addObject:myDate];
    }
    
    if(mutDateArr.count >0)
        [calendar markDates:mutDateArr];
    
    NSString * totalDays =LOCAL(@"allDay", @"本月出勤总数:") ;//; @"本月出勤总数:";
    totalDays = [totalDays stringByAppendingFormat:@"%d",mutDateArr.count];
    sumLabel.text = totalDays;
    
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
            if(calendar.currentMonth != nil)
                tmpDate = calendar.currentMonth;
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
            [calendar markSchoolDates:schDateArr];
    }
    
}



/// 日历代理方法  回调当前选择的年份，月份，并根据参数请求数据.

-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(int)year switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    NSString * myYear = [NSString stringWithFormat:@"%d",year];
    myYear = [myYear substringFromIndex:2];
    NSMutableString * myMonth = [NSMutableString stringWithCapacity:1];
    [myMonth setString:[NSString stringWithFormat:@"%d",month]];
    if(myMonth.length < 2)
    {
        [myMonth insertString:@"0" atIndex:0];
    }
    NSString * param = [NSString stringWithFormat:@"%@%@",myYear,myMonth];
//    NSString * param = [NSString stringWithFormat:@"1307"];
    
    UserLogin * user = [keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    if(user.loginStatus == LOGIN_SERVER){
        
        reqMonth = month;
        
        [[EKRequest Instance] EKHTTPRequest:attendance parameters:[NSDictionary dictionaryWithObjectsAndKeys:param,@"month",nil] requestMethod:GET forDelegate:self];
    }
    else
    {
        NSDictionary * response = [keyedArchiver getArchiver:@"CALENDAR" forKey:@"CALENDAR"];
        
        [self calendarMark:[response objectForKey:@"attendance"] andschool:nil];
    }
}

/**
 *	@brief  日历代理方法 
 *
 *  @param  calendarView 日历变量
 *	@param 	date  当前选择的日期
 */

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    DutyDayView * myDutyView = (DutyDayView *)[self viewWithTag:100];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger day = [components day];
    myDutyView.dayLabel.text = [NSString stringWithFormat:@"%d",day];
//    if([date compare:[NSDate date]] == NSOrderedDescending)
//        dutyView.dutyStatus.text = @"";
//    else
    
        [self makeStatus:date];
}

/**
 *	@brief  标记日期信息
 *
 *  
 *	@param 	date  选择的日期
 */

-(void) makeStatus:(NSDate *)date
{
    dutyView.dutyStatus.text =@"";// @"正常出勤";
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyMMdd"];
    NSString * dateStr = [format stringFromDate:date];
    [format release];
    
    for(int i=0;i<[self.listArr count];i++)
    {
        NSDictionary * dateDic = [self.listArr objectAtIndex:i];
        NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
        if([dateStr isEqualToString:attendaceday])
        {
            int status = [[dateDic objectForKey:@"typeid"] intValue];
//            NSLog(@"kkk=%d",status);
            dutyView.dutyStatus.text = [self attendanceStatus:status];
            break;
        }
    }
    
    NSDateFormatter *tempFormate = [[[NSDateFormatter alloc] init] autorelease];
    [tempFormate setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [tempFormate stringFromDate:date];
    
    NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
    
    dutyView.festivalLabel.text = @"";
    
    if (self.calendarDic != nil && self.calendarDic.count != 0) {
        NSArray *keys = [calendarDic allKeys];
        for (int i = 0; i<keys.count; i++) {
            
            NSString *keyStr = [keys objectAtIndex:i];
            
            if ([festivalsKey containsObject:keyStr]) {
                
                NSArray *dateArr = [self.calendarDic objectForKey:keyStr];
                for (int j = 0; j < dateArr.count; j++) {
                    
                    NSString *fStr = [dateArr objectAtIndex:j];
                    
//                    NSLog(@"%@ %@",fStr, str);
                    
                    if ([str isEqualToString:fStr]) {
                        dutyView.festivalLabel.text = LOCAL(keyStr, @"");
                        break;
                    }
                }
                
            }
            
            
        }
    }
    
}




/**
 *	出勤信息对照
 *  
 *  @param  typeid  类型编号
 *
 *	@return	返回对应的出勤信息
 */
-(NSString *) attendanceStatus:(int) typeid

{
    
//    "normalDuty" ="Check in on time";
//    "queqin"="Absence";
//    "sick"="Sick";
//    "affair"="Affair";
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    if(touch.tapCount==1)
    {
        prePoint=[touch locationInView:self.window];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    if(touch.tapCount==1)
    {
        CGPoint currentPoint=[touch locationInView:self.window];
        
        distence=prePoint.x-currentPoint.x;
        if(distence>0)
        {
            self.center=CGPointMake(self.frame.size.width/2-distence, self.center.y);
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:self.window];
    
    distence=prePoint.x-currentPoint.x;
    if(distence>0)
    {
        if(distence>160)
        {
            [UIView animateWithDuration:.2 animations:^{
                self.center=CGPointMake(-160, self.center.y);
                
            } completion:^(BOOL finished)
            {
                self.listArr=nil;
                [self removeFromSuperview];
                [self release];
             
            }]; 
        }
        else
        {
            [UIView animateWithDuration:.2 animations:^{
                self.center=CGPointMake(160, self.center.y);
            }];
        }
    }
    else
    {
        [UIView animateWithDuration:.2 animations:^{
            self.center=CGPointMake(160, self.center.y);
        }];
    }
    prePoint=CGPointZero;
}

@end
