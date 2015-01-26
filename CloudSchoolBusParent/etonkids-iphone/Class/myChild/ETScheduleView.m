
#import "ETScheduleView.h"
#import "UserLogin.h"
#import "ETApi.h"
#import "ETCoreDataManager.h"
#import "ScheduleCell.h"
#import "Modify.h"
#import "ETCommonClass.h"

@implementation ETScheduleView
@synthesize dataArray,tableview,currentday;
@synthesize datebutton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *leftArrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 17)];
        leftArrowImgV.image = [UIImage imageNamed:@"GO1.png"];
        leftArrowImgV.center = CGPointMake(175, leftButton.center.y);
        leftArrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:leftArrowImgV];
        [leftArrowImgV release];
        
        UIImageView *rightArrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 17)];
        rightArrowImgV.image = [UIImage imageNamed:@"GO1.png"];
        rightArrowImgV.center = CGPointMake(300, leftButton.center.y);
        [self addSubview:rightArrowImgV];
        [rightArrowImgV release];
        
        
        UIButton  *leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        //        leftArrow.backgroundColor = [UIColor redColor];
        leftArrow.frame = CGRectMake(0, 0, 20, 30);
        leftArrow.center = leftArrowImgV.center;
        [leftArrow addTarget:self action:@selector(LeftTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftArrow];
        
        //右箭头
        UIButton  *rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        //        rightArrow.backgroundColor = [UIColor redColor];
        rightArrow.frame = CGRectMake(0, 0, 20, 30);
        rightArrow.center = rightArrowImgV.center;
        [rightArrow addTarget:self action:@selector(RightTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightArrow];
        
        
        todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [todayBtn setFrame:CGRectMake(0, 0, 75, 35)];
        todayBtn.hidden = YES;
        //        todayBtn.backgroundColor = [UIColor redColor];
        [todayBtn setBackgroundImage:[UIImage imageNamed:@"todayButton.png"] forState:UIControlStateNormal];
        [todayBtn setTitle:LOCAL(@"today", @"") forState:UIControlStateNormal];
        todayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [todayBtn setCenter:CGPointMake(105, leftButton.center.y)];
        [todayBtn addTarget:self action:@selector(doToday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:todayBtn];
        
        //获取系统当前时间
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
//        NSString *lan= NSLocalizedString(@"Lanague", @"2");
//        if([lan isEqualToString:@"1"])
//        {
//            dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        }
//        else
//        {
//            dateFormat.locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        }
//        //[dateFormat.locale release];
//        //时间显示区域
//        
        
        datebutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        datebutton.backgroundColor=[UIColor clearColor];
        datebutton.center = CGPointMake(238, leftButton.center.y);
        [datebutton addTarget:self action:@selector(CenterTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:datebutton];
        NSDate *curDate = [NSDate date];
        NSString *timestamp = [dateFormat stringFromDate:curDate];
        [datebutton setTitle:[NSString stringWithFormat:@"%@",timestamp] forState:UIControlStateNormal];
        [datebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        datebutton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
//        UILabel  *noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,300,80)];
//        noDataLabel.backgroundColor=[UIColor clearColor];
//        noDataLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        noDataLabel.text=LOCAL(@"defaultcourse", @"暂无课程安排");
//        noDataLabel.font=[UIFont systemFontOfSize:28];
//        noDataLabel.textColor=[UIColor grayColor];
//        noDataLabel.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:noDataLabel];
//        [noDataLabel release];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 131)];
        imgV.image = [UIImage imageNamed:@"nodata.png"];
        imgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:imgV];
        [imgV release];
        
        
        //列表
        tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.frame.size.height - NAVIHEIGHT)];
        [self addSubview:self.tableview];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = CELLCOLOR;
        
        [self requestDataAndReloadButtonByDate:[NSDate date]];
        
    }
    return self;
}




/**
 *	@brief  请求某个日期中的课程表信息.
 *
 *	@param 	reqDate 指定日期.
 */
- (void)requestDataAndReloadButtonByDate:(NSDate *)reqDate
{
//    int week = ((int)[reqDate timeIntervalSince1970]/(3600*24)%7 + 1)%7;
//    NSArray *weekArr = [NSArray arrayWithObjects:LOCAL(@"four", @"星期四"),LOCAL(@"five", @"星期五"),LOCAL(@"six",@"星期六"),LOCAL(@"seven",@"星期日"),LOCAL(@"one",@"星期一"),LOCAL(@"two",@"星期二"),LOCAL(@"three",@"星期三"), nil];
    
    
    NSString *btnStr = [dateFormat stringFromDate:reqDate];
    
    NSArray *dateArr = [btnStr componentsSeparatedByString:@"-"];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@",[dateArr objectAtIndex:0],[dateArr objectAtIndex:1],[dateArr objectAtIndex:2]];
    NSString *paraStr = [tempStr substringFromIndex:2];
    
    [datebutton setTitle:[NSString stringWithFormat:@"%@", btnStr] forState:UIControlStateNormal];
    
    
    NSArray *result = [ETCoreDataManager searchScheduleByDate:paraStr];
    if (result != nil && result.count != 0) {
        self.dataArray = result;
        self.tableview.hidden = NO;
        [self.tableview reloadData];
        return;
    }
    
    NSDictionary *dateDic = [NSDictionary dictionaryWithObjectsAndKeys:btnStr,@"day", nil];
    
    NSLog(@"%@",dateDic);
    [[EKRequest Instance] EKHTTPRequest:schedule parameters:dateDic requestMethod:GET forDelegate:self];
}
#pragma mark ----- UIGestureRecognizer

/// 点击左箭头 日期改为当前日期的前一天 并请求数据.
-(void)LeftTap:(UIButton*)sender
{
    
    NSString *centerBtnTitle = [datebutton titleForState:UIControlStateNormal];

    NSDate *cDate = [dateFormat dateFromString:[[centerBtnTitle componentsSeparatedByString:@" "] objectAtIndex:0]];
    
    int seconds = [cDate timeIntervalSince1970] - 3600 * 24;
    
    NSDate *lDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    if ([[dateFormat stringFromDate:lDate] isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
    {
        todayBtn.hidden = YES;
    }
    else
    {
        todayBtn.hidden = NO;
    }
    
    [self requestDataAndReloadButtonByDate:lDate];
    
}

/// 点击右箭头 日期改为当前日期的后一天 并请求数据.
-(void)RightTap:(UIButton*)sender
{
 
    NSString *centerBtnTitle = [datebutton titleForState:UIControlStateNormal];
    
    NSDate *cDate = [dateFormat dateFromString:[[centerBtnTitle componentsSeparatedByString:@" "] objectAtIndex:0]];
    
    NSDate *rDate = [NSDate dateWithTimeInterval:3600*24 sinceDate:cDate];
    
    if ([[dateFormat stringFromDate:rDate] isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
    {
        todayBtn.hidden = YES;
    }
    else
    {
        todayBtn.hidden = NO;
    }
    
    [self requestDataAndReloadButtonByDate:rDate];
    
    
}

/// 点击日期 通过datepicker 选择日期 并完成后请求数据.
-(void)CenterTap:(UIButton*)sender
{
    NSString *centerBtnTitle = [datebutton titleForState:UIControlStateNormal];
    NSDate *cDate = [dateFormat dateFromString:[[centerBtnTitle componentsSeparatedByString:@" "] objectAtIndex:0]];
    
    MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:cDate];
    sheet.delegate = self;
    [sheet showInView:self];
    [sheet release];
//    NSString *lan= NSLocalizedString(@"Lanague", @"2");
//    if([lan isEqualToString:@"1"])
//    {
//        datapick.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    }
//     else
//     {
//         datapick.locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//     }
//        [datapick.locale release];
    
}
#pragma EKRequest_Delegate
-(void)LoginFailedresult:(NSString *)str
{
    self.tableview.hidden=YES;
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void) getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == schedule) {
        if(code!=1)
        {
            [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
            return;
        }
        
        
        id r = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
        if (![r isKindOfClass:[NSArray class]]) {
            NSLog(@"课程表返回格式错误");
            return;
        }
        
        NSMutableArray *result = r;
        
        
       // NSLog(@"%@,%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding],result);
        
//        if (![resultDic objectForKey:@"schedule"]) {
//            
//            NSLog(@"无课程表数据");
//            
//            return;
//        }
        
//        NSMutableArray *result = [resultDic objectForKey:@"schedule"];
        
        NSString *paramDay = [param objectForKey:@"day"];
        
        
        NSArray *dateArr = [paramDay componentsSeparatedByString:@"-"];
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@",[dateArr objectAtIndex:0],[dateArr objectAtIndex:1],[dateArr objectAtIndex:2]];
        NSString *paraStr = [tempStr substringFromIndex:2];
        

        
        NSString *t = [datebutton titleForState:UIControlStateNormal];
        NSString *t1 = [t stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if (![paraStr isEqualToString:[t1 substringFromIndex:2]])
        {
            return;
        }
        self.dataArray = result;
        
        
        
        
        
//        NSString *paramDay = [param objectForKey:@"day"];
        [ETCoreDataManager removeScheduleByDate:paraStr];
        [ETCoreDataManager addSchedule:self.dataArray withDate:paraStr];
        
        
        if (self.dataArray.count == 0)
        {
            self.tableview.hidden = YES;
        }
        else
        {
            self.tableview.hidden = NO;
        }
        
        [tableview reloadData];
        //NSMutableArray *ScheduleArray=(NSMutableArray*)response;
//        for (int i=0; i<result.count;i++)
//        {
//            NSDictionary *TimrDictionary=[result objectAtIndex:i];
//            NSString *str1 = [TimrDictionary objectForKey:@"scheduletime"];
//            [self.TimeArray addObject:str1];
//            
//            NSDictionary  *ChinaDictiinary=[result objectAtIndex:i];
//            NSString *str2=[ChinaDictiinary objectForKey:@"cnname"];
//            [self.ChinaArray addObject:str2];
//            
//            NSDictionary  *EnglishDictionary=[result objectAtIndex:i];
//            NSString *str3=[EnglishDictionary objectForKey:@"enname"];
//            [self.EnglishArray addObject:str3];
//        }
        
    }

    
}
#pragma --

#pragma mark--tabelview
- (NSInteger)tableView:(UITableView *)Tableview numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (ScheduleCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *string = @"singleIdentifier";
    ScheduleCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell=[[[ScheduleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string] autorelease];
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    
    cell.timeLabel.text = [dic objectForKey:@"scheduletime"];
    
    NSString *course = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
//    NSString *course = @"sdflaksdjflk jlsd卡放假嗖地就说的";
    if ([course isEqualToString:@"(null)"]) {
        course = @"";
    }
    
    
    
    CGSize size = [course sizeWithFont:cell.courseLabel.font constrainedToSize:CGSizeMake(180, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.courseLabel.frame = CGRectMake(cell.courseLabel.frame.origin.x, size.height > 40 ? 10 : (60 - size.height)/2, cell.courseLabel.frame.size.width, size.height);
    cell.courseLabel.text = course;
    
    cell.timeLabel.center = CGPointMake(cell.timeLabel.center.x,
                                        MAX(60, size.height + 20)/2);
    
    cell.leftView.frame = CGRectMake(cell.leftView.frame.origin.x,
                                     cell.leftView.frame.origin.y,
                                     cell.leftView.frame.size.width,
                                     MAX(60 - 10, size.height + 10));
    
    cell.backView.frame = CGRectMake(cell.backView.frame.origin.x,
                                     cell.backView.frame.origin.y,
                                     cell.backView.frame.size.width,
                                     MAX(60 - 10, size.height + 10));
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *course = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
    if ([course isEqualToString:@"(null)"]) {
        course = @"";
    }
    
    CGSize size = [course sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(180, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(60, size.height + 20);
}

- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index selectDate:(NSDate *)date
{
    if (index == 1) {
        NSString *dateStr = [dateFormat stringFromDate:date];
        [datebutton setTitle:dateStr forState:UIControlStateNormal];
        
        if ([dateStr isEqualToString:[dateFormat stringFromDate:[NSDate date]]])
        {
            todayBtn.hidden = YES;
        }
        else
        {
            todayBtn.hidden = NO;
        }
        
        [self requestDataAndReloadButtonByDate:date];
    }
    
}

- (void)doToday:(id)sender
{
    todayBtn.hidden = YES;
    NSString *date = [dateFormat stringFromDate:[NSDate date]];
    [datebutton setTitle:date forState:UIControlStateNormal];
    [self requestDataAndReloadButtonByDate:[NSDate date]];
}


-(void)dealloc
{
    [dateFormat release];
    [super dealloc];
    
}
@end
