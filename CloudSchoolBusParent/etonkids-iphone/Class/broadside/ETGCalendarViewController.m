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
@synthesize dateList;
//@synthesize scroller;
@synthesize _tableView;
@synthesize festvStr,currentDateStr;
- (void)dealloc
{
    self.fesArr = nil;
    self.attArr = nil;
   // self.scroller=nil;
    self.dateList=nil;
    self.festvStr=nil;
    self.currentDateStr=nil;
    self._tableView=nil;
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

    

    dateList=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 0) style:UITableViewStylePlain];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-25, 320, 25)];
    countLabel.backgroundColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:199/255.0f alpha:1.0f];
    countLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:countLabel];
    [countLabel release];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
  
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-25, 320, 25)];
    headerView.backgroundColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:199/255.0f alpha:1.0f];



    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 25, 25)];
    dateLabel.text=self.currentDateStr;
    dateLabel.textColor=[UIColor whiteColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:dateLabel];
    [dateLabel release];


    todaycount = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 150, 25)];
    todaycount.text=[NSString stringWithFormat:@"当天打卡次数:%d",[dateList count]];
    todaycount.backgroundColor = [UIColor clearColor];
    todaycount.font = [UIFont systemFontOfSize:15];
    todaycount.textColor=[UIColor whiteColor];
    [headerView addSubview:todaycount];
    [todaycount release];


    fesLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 100, 25)];
    fesLabel.text=self.festvStr;
    fesLabel.textColor=[UIColor whiteColor];
    fesLabel.backgroundColor = [UIColor clearColor];
    fesLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:fesLabel];
    [fesLabel release];


    return [headerView autorelease];

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(45, 5, 100, 30)];
        label.tag=100;
        [cell.contentView addSubview:label];
        [label release];
        
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        imageView.tag=101;
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    
    
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:100];
    
    NSDictionary *dic=[dateList objectAtIndex:indexPath.row];
     NSString *time=[dic objectForKey:@"createtime"];
    NSDate *date= [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    //[dateformatter setDateStyle:"hh:MM:ss"];
    [dateformatter setTimeStyle:@"hh:MM"];
    
    NSString *timestr=[dateformatter stringFromDate:date];
    
    label.text=timestr;
    
    NSString *url=[NSString stringWithFormat:@"http://%@",[dic objectForKey:@"imgpath"]];
     UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:101];
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[dateList objectAtIndex:indexPath.row];
     NSString *url=[NSString stringWithFormat:@"http://%@",[dic objectForKey:@"imgpath"]];
    
    GKShowReceiveBigImageViewController *showVC=[[GKShowReceiveBigImageViewController alloc]init];
    showVC.path=url;
    [self presentModalViewController:showVC animated:YES];
    [showVC release];
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
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);
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
        
        //NSString *str=[format stringFromDate:[NSDate date]];
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
    [dateList removeAllObjects];
    [_tableView reloadData];
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
         
            
            NSArray *arr=[dateDic objectForKey:@"record"];
            
            self.dateList=[NSMutableArray arrayWithArray:arr];
            [_tableView reloadData];
            
            
            
            break;
        }
        
    }
    //todaycount.text=[NSString stringWithFormat:@"当天打卡次数:%d",[dateList count]];

    self.currentDateStr=[NSString stringWithFormat:@"%@",[dateStr substringFromIndex:[dateStr length]-2]];
 //   dateLabel.text=[;
    NSDateFormatter *tempFormate = [[[NSDateFormatter alloc] init] autorelease];
    [tempFormate setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [tempFormate stringFromDate:date];
    fesLabel.text = @"";
 
    self.festvStr=@"";
    
    if (self.fesArr != nil && self.fesArr.count != 0) {
        
        for (int i = 0; i<self.fesArr.count; i++) {
            
            NSString *fstr = [self.fesArr objectAtIndex:i];
            
            NSString *fdateStr = [[fstr componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *fname = [[fstr componentsSeparatedByString:@","] objectAtIndex:1];
            
            if ([str isEqualToString:fdateStr]) {
               // fesLabel.text =fname;// LOCAL(fname, @"");
                self.festvStr=fname;
                break;
            }
            
        }
        
        
    }
    NSLog(@"%@-----%@",fesLabel.text,otherStateLabel.text);

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




- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(int)year switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    

    [UIView animateWithDuration:0.2 animations:^{
           _tableView.frame=CGRectMake(0, targetHeight+NAVIHEIGHT+(ios7?20:0), self.view.frame.size.width, self.view.frame.size.height-targetHeight-NAVIHEIGHT-(ios7?20:0)-25);
    }];

    NSString *s = [NSString stringWithFormat:@"%d",year];
    NSString *pStr = [NSString stringWithFormat:@"%@-%02d",s,month];
   // NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:pStr,@"month",nil];
    [self.dateList removeAllObjects];
    [_tableView reloadData];
    self.currentDateStr=@"";
    self.festvStr=@"";
    dateLabel.text=@"";
    todaycount.text=@"";
    fesLabel.text=@"";
    
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
    [self makeStatus:date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
