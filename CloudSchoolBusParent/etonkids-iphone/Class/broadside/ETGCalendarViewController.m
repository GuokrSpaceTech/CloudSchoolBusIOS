//
//  ETCalendarViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-23.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETGCalendarViewController.h"
#import "ETKids.h"
#import "AppDelegate.h"
#import "NSDate+convenience.h"
#import "ETCoreDataManager.h"
#import "GKShowReceiveBigImageViewController.h"
#import "UIImageView+WebCache.h"
@interface ETGCalendarViewController ()

@end

@implementation ETGCalendarViewController
@synthesize fesArr,attArr;

@synthesize scroller;
- (void)dealloc
{
    self.fesArr = nil;
    self.attArr = nil;
    self.scroller=nil;
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
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"checkAndCalendar", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    myCalendar = [[VRGCalendarView alloc] init];
    myCalendar.delegate=self;
    [self.view addSubview:myCalendar];
    [myCalendar release];
    
    
  //  float positiony=iphone5 ? (548-97) : (460-97);

   // positiony=(ios7?(positiony+20):positiony);
    
//    float positiony = 460-97;

    

    
    scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 0)];
    scroller.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scroller];
   
    
    UIImageView *circleImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 10)];
    circleImageView1.backgroundColor=[UIColor clearColor];
    [circleImageView1 setImage:[UIImage imageNamed:@"point_attendance.png"]];
    [scroller addSubview:circleImageView1];
    [circleImageView1 release];
    
    inLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, 150, 20)];
    inLabel.text =[NSString stringWithFormat:@"%@:%@",LOCAL(@"checkin", @""),LOCAL(@"none", @"")];//等待考勤数据
    inLabel.backgroundColor = [UIColor clearColor];
    inLabel.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:inLabel];
    [inLabel release];
    
    outlable = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 150, 20)];
    outlable.text = [NSString stringWithFormat:@"%@:%@",LOCAL(@"checkout", @""),LOCAL(@"none", @"")];//等待考勤数据
    outlable.backgroundColor = [UIColor clearColor];
    outlable.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:outlable];
    [outlable release];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    inImageView=[[MyImageView alloc]initWithFrame:CGRectMake(200, 2, 40, 40)];
    inImageView.backgroundColor=[UIColor clearColor];
    
    [scroller addSubview:inImageView];
    [inImageView release];
    [inImageView addGestureRecognizer:tap];
    [tap release];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap2.numberOfTapsRequired=1;
    
    outImageView=[[MyImageView alloc]initWithFrame:CGRectMake(250, 2, 40, 40)];
    outImageView.backgroundColor=[UIColor clearColor];
    [scroller addSubview:outImageView];
  
    [outImageView release];
    [outImageView addGestureRecognizer:tap2];
    [tap2 release];
    
    
    
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, 310, 1)];
    line1.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    [scroller addSubview:line1];
    [line1 release];
    
    UIImageView *circleImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 10, 10)];
    circleImageView2.backgroundColor=[UIColor clearColor];
     [circleImageView2 setImage:[UIImage imageNamed:@"point_attendance.png"]];
    [scroller addSubview:circleImageView2];
    [circleImageView2 release];
    
    tempatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 150, 20)];
    tempatureLabel.text =[NSString stringWithFormat:@"%@:%@",LOCAL(@"temperature", @""),LOCAL(@"none", @"")];//等待考勤数据
    tempatureLabel.backgroundColor = [UIColor clearColor];
    tempatureLabel.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:tempatureLabel];
    [tempatureLabel release];
    
    tempatureStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 150, 20)];
    tempatureStateLabel.text = @"";//等待考勤数据
    tempatureStateLabel.backgroundColor = [UIColor clearColor];
    tempatureStateLabel.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:tempatureStateLabel];
    [tempatureStateLabel release];
    
    line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 75, 310, 1)];
    line2.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    [scroller addSubview:line2];
    [line2 release];
    
    circleImageView3=[[UIImageView alloc]initWithFrame:CGRectMake(10, 85, 10, 10)];
    circleImageView3.backgroundColor=[UIColor clearColor];
     [circleImageView3 setImage:[UIImage imageNamed:@"point_attendance.png"]];
    [scroller addSubview:circleImageView3];
    [circleImageView3 release];
    
    otherStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 150, 20)];
    otherStateLabel.text = @"";//等待考勤数据
    otherStateLabel.backgroundColor = [UIColor clearColor];
    otherStateLabel.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:otherStateLabel];
    [otherStateLabel release];
    
    
    
    line3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 105, 310, 1)];
    line3.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    [scroller addSubview:line3];
    [line3 release];
    
    
    
    circleImageView4=[[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 10, 10)];
    circleImageView4.backgroundColor=[UIColor clearColor];
     [circleImageView4 setImage:[UIImage imageNamed:@"point_attendance.png"]];
    [scroller addSubview:circleImageView4];
    [circleImageView4 release];
    
    fesLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 250, 20)];
    fesLabel.text = @"";//等待考勤数据
    fesLabel.backgroundColor = [UIColor clearColor];
    fesLabel.font = [UIFont systemFontOfSize:15];
    [scroller addSubview:fesLabel];
    [fesLabel release];

    

    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-25, 320, 25)];
    countLabel.backgroundColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:199/255.0f alpha:1.0f];
    countLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:countLabel];
    [countLabel release];
    

    
     scroller.contentSize=CGSizeMake(300, 130);
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doBack:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    
    
//    [self makeStatus:[NSDate date]];
    // Do any additional setup after loading the view from its nib.
}
-(void)tapClick:(UIGestureRecognizer *)tap
{
    
    MyImageView *iamgeView=(MyImageView *)tap.view;
    GKShowReceiveBigImageViewController *showVC=[[GKShowReceiveBigImageViewController alloc]init];
    showVC.path=iamgeView.path;
    [self presentModalViewController:showVC animated:YES];
    [showVC release];
}
- (void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
   // NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
   // NSLog(@"%@",aa);
    if(method == attendancemanager && code == 1)
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
//        [ETCoreDataManager removeCalendarByMonth:m];
//        [ETCoreDataManager addCalendar:self.fesArr withMonth:m];
//        [ETCoreDataManager removeAttendanceByMonth:m];
//        [ETCoreDataManager addAttendance:self.attArr withMonth:m];
        
        
        //判定如果是当前月则更新点击状态
        
        
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"MM"];
//        NSLog(@"%@,%@",[m substringFromIndex:2],[format stringFromDate:[NSDate date]]);
        if([[m substringFromIndex:5] isEqualToString:[format stringFromDate:[NSDate date]]])
        {
            [self makeStatus:[NSDate date]];
        }
        
    }
}
- (void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
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
   // attLabel.text =LOCAL(@"noMsgAtt", @"");
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
            NSString *inschoolstr=[dateDic objectForKey:@"start_time"];
            NSString *outschoolstr=[dateDic objectForKey:@"end_time"];
            NSString *tempature=[NSString stringWithFormat:@"%@",[dateDic objectForKey:@"temperature"]];
            NSString *inpath=[NSString stringWithFormat:@"%@",[dateDic objectForKey:@"startpath"]];
            NSString *outPath=[NSString stringWithFormat:@"%@",[dateDic objectForKey:@"endpath"]];
            
            NSString *otherstate=[dateDic objectForKey:@"state"];
            
            // "checkin" ="Check In";
            //"checkout" ="Leave";
            
            if([inschoolstr isEqualToString:@""])
            {
                inLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"checkin",@""),NSLocalizedString(@"none",@"")];
            }
            else
            {
                inLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"checkin",@""),inschoolstr];
            }
            if([outschoolstr isEqualToString:@""])
            {
                outlable.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"checkout",@""),NSLocalizedString(@"none",@"")];
            }
            else
            {
                outlable.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"checkout",@""),outschoolstr];
            }
            if([tempature isEqualToString:@""])
            {
                tempatureLabel.text=[NSString stringWithFormat:@"%@：%@",LOCAL(@"temperature",@""),NSLocalizedString(@"none",@"")];
                tempatureStateLabel.text=@"";
            }
            else
            {
                tempatureLabel.text=[NSString stringWithFormat:@"%@：%@%@",LOCAL(@"temperature",@""),tempature,@"℃"];
                if([tempature floatValue]>=36.0 && [tempature floatValue]<=37.5)
                {
                    //                    "normal"="体温正常";
                    //                    "heighter"="体温过高";
                    
                    tempatureStateLabel.text=NSLocalizedString(@"normal", @"");
                    tempatureStateLabel.textColor=[UIColor blackColor];
                }
                else
                {
                    tempatureStateLabel.text=NSLocalizedString(@"heighter", @"");
                    tempatureStateLabel.textColor=[UIColor redColor];
                }
            }
            inImageView.userInteractionEnabled=NO;
            outImageView.userInteractionEnabled=NO;
            
            if(![inpath isEqualToString:@""])
            {
                inImageView.userInteractionEnabled=YES;
                [inImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",inpath]] placeholderImage:nil];
                inImageView.path=[NSString stringWithFormat:@"http://%@",inpath];
            }
            else
            {
                inImageView.userInteractionEnabled=NO;
            }
            
            if(![outPath isEqualToString:@""])
            {
                outImageView.userInteractionEnabled=YES;
                [outImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",outPath]] placeholderImage:nil];
                outImageView.path=[NSString stringWithFormat:@"http://%@",outPath];
            }
            else
            {
                outImageView.userInteractionEnabled=NO;
            }
           
            if([otherstate isEqualToString:@""])
            {
                otherStateLabel.frame=CGRectZero;
            }
            else
            {
                otherStateLabel.text=otherstate;
            }
            
            break;
        }
        
    }
    
    NSDateFormatter *tempFormate = [[[NSDateFormatter alloc] init] autorelease];
    [tempFormate setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [tempFormate stringFromDate:date];
    
    //    NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
    
    // fesLabel.text = LOCAL(@"noMsgFes", @"");
    fesLabel.text = @"";
    fesImgV.hidden = YES;
    
    if (self.fesArr != nil && self.fesArr.count != 0) {
        
        for (int i = 0; i<self.fesArr.count; i++) {
            
            NSString *fstr = [self.fesArr objectAtIndex:i];
            
            NSString *fdateStr = [[fstr componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *fname = [[fstr componentsSeparatedByString:@","] objectAtIndex:1];
            
            if ([str isEqualToString:fdateStr]) {
                fesLabel.text =fname;// LOCAL(fname, @"");
                fesLabel.hidden=NO;
                fesImgV.hidden = NO;
                break;
            }
            
        }
        
        
    }
    NSLog(@"%@-----%@",fesLabel.text,otherStateLabel.text);
    if([fesLabel.text isEqualToString:@""] && [otherStateLabel.text isEqualToString:@""])
    {
        //circleImageView4.hidden=YES;
        circleImageView4.hidden=YES;
        circleImageView3.hidden=YES;
        line2.hidden=YES;
        line3.hidden=YES;
        fesLabel.hidden=YES;
        otherStateLabel.hidden=YES;
        
        scroller.contentSize=CGSizeMake(300, 80);
        
    }
    else if([fesLabel.text isEqualToString:@""] && ![otherStateLabel.text isEqualToString:@""])
    {
        otherStateLabel.frame=CGRectMake(30, 80, 150, 20);
        otherStateLabel.hidden=NO;
        circleImageView3.hidden=NO;
        line2.hidden=NO;
        circleImageView4.hidden=YES;
        line3.hidden=YES;
        fesLabel.hidden=YES;
        scroller.contentSize=CGSizeMake(300, 100);
        
    }
    else if(![fesLabel.text isEqualToString:@""] && [otherStateLabel.text isEqualToString:@""])
    {
        circleImageView3.hidden=NO;
        line2.hidden=NO;
        
        fesLabel.frame=CGRectMake(30, 80, 150, 20);
        otherStateLabel.hidden=YES;
        circleImageView4.hidden=YES;
        line3.hidden=YES;
        fesLabel.hidden=NO;
        otherStateLabel.hidden=YES;
        scroller.contentSize=CGSizeMake(300, 100);
        
    }
    else
    {
        otherStateLabel.frame=CGRectMake(30, 80, 150, 20);
        circleImageView3.hidden=NO;
        line2.hidden=NO;
        circleImageView4.hidden=NO;
        line3.hidden=NO;
        fesLabel.hidden=NO;
        otherStateLabel.hidden=NO;
        fesLabel.frame=CGRectMake(30, 110, 250, 20);
        scroller.contentSize=CGSizeMake(300, 130);
    }
    
   // otherStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 150, 20)];
    //fesLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 250, 20)];
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
    //NSMutableArray * quqinArr = [[NSMutableArray alloc] initWithCapacity:1];
  //  NSMutableArray *budengArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for(int i=0;i<[dateArr count];i++)
    {
        NSDictionary * dateDic = [dateArr objectAtIndex:i];
        NSString * attendaceday = [dateDic objectForKey:@"attendaceday"];
        
      //  int type=[[dateDic objectForKey:@"attendancetypeid"] integerValue];
        
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
        
        //if(type==1)
            [mutDateArr addObject:myDate];
        //if(type==2)
           // [quqinArr addObject:myDate];
        //if (type == 3) {
           // [budengArr addObject:myDate];
       // }
    }
    
    if(mutDateArr.count >0)
        [myCalendar markDates:mutDateArr];
//    if(quqinArr.count >0)
//        [myCalendar markqueqinDates:quqinArr];
//    if (budengArr.count > 0) {
//        [myCalendar markedBuDengDates:budengArr];
//    }
    
    NSString * totalDays =LOCAL(@"allDay", @"本月出勤总数:") ;//; @"本月出勤总数:";
    totalDays = [totalDays stringByAppendingFormat:@"%d",mutDateArr.count];
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

//-(NSString *) attendanceStatus:(int) typeid
//{
//    switch (typeid)
//    {
//        case 1:
//            return LOCAL(@"normalDuty", @"正常出勤") ;
//        case 2:
//            return LOCAL(@"affair", @"请事假") ;
//        case 3:
//            return LOCAL(@"sick", @"请病假") ;
//        case 4:
//            return LOCAL(@"queqin", @"缺勤") ;
//        default:
//            return LOCAL(@"normalDuty", @"正常出勤");
//    }
//}



- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(int)year switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    
    inLabel.text =[NSString stringWithFormat:@"%@:%@",LOCAL(@"checkin", @""),LOCAL(@"none", @"")];//@"入园：无";
    outlable.text = [NSString stringWithFormat:@"%@:%@",LOCAL(@"checkout", @""),LOCAL(@"none", @"")];
    tempatureLabel.text = [NSString stringWithFormat:@"%@:%@",LOCAL(@"temperature", @""),LOCAL(@"none", @"")];
//    inLabel.text =@"入园：无";
//    outlable.text = @"离园：无";
//    tempatureLabel.text = @"体温：无";

    otherStateLabel.hidden=YES;
    fesLabel.hidden=YES;
    circleImageView3.hidden=YES;
    circleImageView4.hidden=YES;
    line2.hidden=YES;
    line3.hidden=YES;
    scroller.contentSize=CGSizeMake(310, 80);

    [UIView animateWithDuration:0.2 animations:^{
           scroller.frame=CGRectMake(10, targetHeight+NAVIHEIGHT+(ios7?20:0)+5, 300, self.view.frame.size.height-targetHeight-NAVIHEIGHT-(ios7?20:0)-8-25);
    }];

    NSString *s = [NSString stringWithFormat:@"%d",year];
    NSString *pStr = [NSString stringWithFormat:@"%@-%02d",s,month];
   // NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month",nil];

    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD release];
    }


    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month", nil];
        [[EKRequest Instance] EKHTTPRequest:attendancemanager parameters:dic requestMethod:GET forDelegate:self];
    }];

    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    //scroller.contentOffset=CGPointMake(0, 0);
    [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"d";
    dateLabel.text = [format stringFromDate:date];
    // "checkin" ="Check In";
    //"checkout" ="Leave";
    
    inLabel.text =[NSString stringWithFormat:@"%@:%@",LOCAL(@"checkin", @""),LOCAL(@"none", @"")];//@"入园：无";
    outlable.text = [NSString stringWithFormat:@"%@:%@",LOCAL(@"checkout", @""),LOCAL(@"none", @"")];
    tempatureLabel.text = [NSString stringWithFormat:@"%@:%@",LOCAL(@"temperature", @""),LOCAL(@"none", @"")];
    tempatureStateLabel.text = @"";
    otherStateLabel.text = @"";
    fesLabel.text = @"";
    inImageView.image=nil;
    outImageView.image=nil;
    
    [self makeStatus:date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
