
#import "ETFoodView.h"
#import "UserLogin.h"
#import "ETApi.h"
#import "ImageScaleView.h"
#import "AppDelegate.h"
#import "FoodCell.h"
#import "ETCoreDataManager.h"
#import "ETCommonClass.h"

@implementation ETFoodView

@synthesize datebutton,tableview;
@synthesize dataArray;
-(void) dealloc
{
    
 //   [dateFormat.locale release];
    
    self.tableview = nil;
    self.dataArray = nil;
    self.datebutton = nil;
    
    [super dealloc];
}
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
//        todayBtn.backgroundColor = [UIColor redColor];
        [todayBtn setBackgroundImage:[UIImage imageNamed:@"todayButton.png"] forState:UIControlStateNormal];
        [todayBtn setTitle:LOCAL(@"today", @"") forState:UIControlStateNormal];
        todayBtn.hidden = YES;
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
        //[dateFormat.locale release];
        //时间显示区域
        
        
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
//        noDataLabel.text=LOCAL(@"default", @"暂无食谱安排");
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
        UITableView *tv=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, 320, self.frame.size.height - NAVIHEIGHT)];
        
        tv.delegate=self;
        tv.dataSource=self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.backgroundColor = CELLCOLOR;
        [self addSubview:tv];
        [tv release];
        
        self.tableview = tv;
        
        NSDictionary *dateDic = [NSDictionary dictionaryWithObjectsAndKeys:timestamp,@"menu_time", nil];
        [[EKRequest Instance] EKHTTPRequest:menu parameters:dateDic requestMethod:GET forDelegate:self];

    }
    return self;
}
#pragma mark--tabelview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
   
}

- (FoodCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string=@"singleIdentifier";
    FoodCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil)
    {
        cell=[[[FoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string] autorelease];
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
//    NSString *enMenu = [NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_enname"]];
    NSString *menu;
//    if ([enMenu isEqualToString:@""]) {
        menu = [NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_name"]];
//    }
//    else
//    {
//        menu = [NSString stringWithFormat:@"%@\n%@",[dic objectForKey:@"menu_name"],enMenu];
//    }
    
    CGSize size = [menu sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(180, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.ChineseLabel.frame = CGRectMake(cell.ChineseLabel.frame.origin.x, size.height > 130 ? 10 : (150 - size.height)/2, 180, size.height);
    cell.ChineseLabel.text=menu;
    
    
    cell.leftBackView.frame = CGRectMake(cell.leftBackView.frame.origin.x,
                                          cell.leftBackView.frame.origin.y,
                                          cell.leftBackView.frame.size.width,
                                          MAX(140, size.height + 10));
    
    cell.backView.frame = CGRectMake(cell.backView.frame.origin.x,
                                     cell.backView.frame.origin.y,
                                     cell.backView.frame.size.width,
                                     MAX(140, size.height + 10));
    
    cell.LeftImageview.center = CGPointMake(cell.leftBackView.center.x,
                                            MAX(150, size.height + 20)/2 - 10);
    
    NSArray *arr = [NSArray arrayWithObjects:@"早餐",@"加餐",@"午餐",@"午点",@"晚餐", nil];
    
    NSString *tstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_type_name"]];
    
    if ([arr containsObject:tstr]) {
        cell.LeftImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tstr]];
    }else{
        cell.LeftImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arr objectAtIndex:0]]];
    }
    
//    if (indexPath.row < 5)
//    {
//        cell.LeftImageview.image = [UIImage imageNamed:[arr objectAtIndex:indexPath.row]];
//    }
//    else
//    {
//        cell.LeftImageview.image = [UIImage imageNamed:[arr objectAtIndex:0]];
//    }
    
    cell.leftTitleLabel.center = CGPointMake(cell.leftBackView.center.x,
                                             MAX(150, size.height + 20)/2 + 18 + 10);
    cell.leftTitleLabel.text = tstr;
    

     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
//    NSString *enMenu = [dic objectForKey:@"menu_enname"];
    NSString *menu;
//    if ([enMenu isEqualToString:@""]) {
        menu = [NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_name"]];
//    }
//    else
//    {
//        menu = [NSString stringWithFormat:@"%@\n%@",[dic objectForKey:@"menu_name"],enMenu];
//    }
    CGSize size = [menu sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(180, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    int height = size.height + 20;
    
    return MAX(150, height);
}

/**
 *	@brief  请求某个日期中的信息.
 *
 *	@param 	reqDate 指定日期.
 */
- (void)requestDataAndReloadButtonByDate:(NSDate *)reqDate
{
    NSString *btnStr = [dateFormat stringFromDate:reqDate];
    [datebutton setTitle:[NSString stringWithFormat:@"%@", btnStr] forState:UIControlStateNormal];
    
    NSArray *tempArr = [ETCoreDataManager searchFoodByDate:btnStr];
    if (tempArr != nil && tempArr.count != 0) {
        self.dataArray = tempArr;
        self.tableview.hidden = NO;
        [self.tableview reloadData];
        return;
    }
    
    NSDictionary *dateDic = [NSDictionary dictionaryWithObjectsAndKeys:btnStr,@"menu_time", nil];
    [[EKRequest Instance] EKHTTPRequest:menu parameters:dateDic requestMethod:GET forDelegate:self];
}

#pragma mark  HUD
-(void)SelectHUD
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, 280, self.frame.size.height)];
        [self.window addSubview:HUD];
        [HUD show:YES];
        
    }
   
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
    NSDate *cDate = [dateFormat dateFromString:[[centerBtnTitle componentsSeparatedByString:@" "]objectAtIndex:0]];
    MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:cDate];
    sheet.delegate = self;
    [sheet showInView:self];
    [sheet release];
//    NSString *lan= NSLocalizedString(@"Lanague", @"2");
//    if([lan isEqualToString:@"1"])
//    {
//        datapick.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
//    }
//    else
//    {
//        datapick.locale= [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
//    }
//   // [datapick.locale release];
    
}

/// 获取当前默认日期数据.
-(void)loadLabel
{

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
    
    if(method == menu && code == 1)
    {
        id r =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        
        if (![r isKindOfClass:[NSArray class]]) {
            NSLog(@"食谱返回格式错误");
            return;
        }
        
        NSMutableArray *result = r;
        
        //NSMutableArray *MenuArray=(NSMutableArray*)response;
        NSLog(@"%@",result);
        
        NSString *paramDate = [param objectForKey:@"menu_time"];
        NSString *t = [datebutton titleForState:UIControlStateNormal];
        if (![paramDate isEqualToString:t]) {
            return;
        }
        
        self.dataArray = result;
        
        
        
        [ETCoreDataManager removeFoodByDate:paramDate];
        [ETCoreDataManager addFood:self.dataArray];
        
        
        if (self.dataArray.count == 0)
        {
            self.tableview.hidden = YES;
        }
        else
        {
            self.tableview.hidden = NO;
        }
        
        [self.tableview reloadData];
        
    }
    else if (method == status)
    {
//        NSMutableArray *result =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        //NSMutableArray *MenuArray=(NSMutableArray*)response;
//        NSLog(@"%@",result);
    }

    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
    }
}

#pragma --
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
    
    
//    [[EKRequest Instance]EKHTTPRequest:ad parameters:nil requestMethod:GET forDelegate:self];
}


@end
