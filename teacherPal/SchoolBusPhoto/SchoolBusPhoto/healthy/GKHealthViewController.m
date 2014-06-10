//
//  GKHealthViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKHealthViewController.h"
#import "KKNavigationController.h"
#import "GKMainViewController.h"
#include "GKTempature.h"
#import "GKUserLogin.h"
#import "Student.h"
#define NAMWTAG 1235
#define TEMPATURETAGLABELTAG 1236

#define STATETAG 1238
#define OTHERLABELTAG 1239
@interface GKHealthViewController ()

@end

@implementation GKHealthViewController
@synthesize _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
    
  //  numLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"studentCount", @""),self.studentArr.count];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-20) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    // _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 320, 20)];
    bottomView.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.textColor=[UIColor whiteColor];
    if(IOSVERSION>=6.0)
        numLabel.textAlignment=NSTextAlignmentCenter;
    else
        numLabel.textAlignment=UITextAlignmentCenter;
    numLabel.font=[UIFont systemFontOfSize:14];
    numLabel.text=@"数量";
    [bottomView addSubview:numLabel];
    
    // studentCount
    
    [self.view addSubview:bottomView];
    [numLabel release];
    [bottomView release];
    
    
    NSDate *date=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *today = [formatter stringFromDate:date];
    self.titlelabel.text=today;
    [formatter release];
    titlelabel.userInteractionEnabled=YES;
    
    
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateClick:)];
    tapG.numberOfTapsRequired=1;
    [titlelabel addGestureRecognizer:tapG];
    [tapG release];
    
    _tempatureArr=[[NSMutableArray alloc]init];
//    for (int i=0; i<10; i++) {
//        GKTempature *tempature=[[GKTempature alloc]init];
//        
//        int a= arc4random()%2;
//        tempature.name=@"小米";
//        if(a==0)
//        {
//            tempature.isTempature=NO;
//            tempature.tempature=@"";
//            tempature.state=@"";
//            tempature.otherstate=@"";
//            
//        }
//        else
//        {
//            tempature.isTempature=YES;
//            tempature.tempature=@"38.2";
//            tempature.state=@"温度过高";
//               int b= arc4random()%2;
//            if(b==0)
//            {
//                tempature.otherstate=@"异常状态：发热，流涕";
//            }
//            else
//            {
//                tempature.otherstate=@"";
//            }
//            
//        }
//        
//        [self.tempatureArr addObject:tempature];
//        [tempature release];
    //}
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",@"2014-06-05",@"date", nil];
    [[EKRequest Instance] EKHTTPRequest:attendancemanager parameters:dic requestMethod:GET forDelegate:self];

//
    // Do any additional setup after loading the view.
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(method==attendancemanager)
    {
        if(code==1)
        {
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            
            for (int i=0; i<[arr count]; i++) {
                GKTempature *temperature=[[GKTempature alloc]init];
                temperature.studentid=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"studentid"]];
                temperature.name=[[arr objectAtIndex:i] objectForKey:@"enname"];
                temperature.tempature=[[arr objectAtIndex:i] objectForKey:@"temperature"];
                if([temperature.tempature floatValue]>36.5 && [temperature.tempature floatValue]<=37.5)
                {
                    temperature.state=@"体温正常";
                }
                else
                {
                    temperature.state=@"体温异常";
                }
                temperature.otherstate=[[arr objectAtIndex:i] objectForKey:@"state"];
                temperature.isTempature=YES;
                [_tempatureArr addObject:temperature];
                
            }
            numLabel.text=[NSString stringWithFormat:@"考勤学生数量：%d",[arr count]];
            
            //计算出未考勤孩子
            GKUserLogin *user=[GKUserLogin currentLogin];
            for (int i=0; i<[user.studentArr count]; i++) {
                Student *st=[user.studentArr objectAtIndex:i];
                BOOL found=NO;
                for (int j=0; j<[_tempatureArr count]; j++) {
                    GKTempature *attence=[_tempatureArr objectAtIndex:j];
                    
                    if([st.studentid intValue]  ==  [attence.studentid intValue])
                    {
                        found=YES;
                        break;
                    }
                    
                }
                if(found==NO)
                {
                    GKTempature *attence=[[GKTempature alloc]init];
                    attence.studentid=[NSString stringWithFormat:@"%@",st.studentid];
                    attence.name=st.enname;
                    attence.state=@"";
                    attence.otherstate=@"";
                    [_tempatureArr addObject:attence];
                    [attence release];
                }
            }
            NSLog(@"-------%d",[_tempatureArr count]);
            [self._tableView reloadData];
//
        }
        
        
    }

}
-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}
-(void)dateClick:(UIGestureRecognizer *)tap
{
    NSDateFormatter *formate = [[[NSDateFormatter alloc] init] autorelease];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formate dateFromString:self.titlelabel.text];
    MTCustomActionSheet* sheet = [[MTCustomActionSheet alloc] initWithDatePicker:date];
    sheet._delegate = self;
    
    [sheet showInView:self.view.window];
    [sheet release];
    
}

- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index selectDate:(NSDate *)date
{
    if (index == 1) {
        //        NSLog(@"%f",[date timeIntervalSinceNow]);
        
        // UserLogin *user = [UserLogin currentLogin];
        
        NSDateFormatter  *formatter=[[[NSDateFormatter alloc]init] autorelease];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *str = [formatter stringFromDate:date];
        
        self.titlelabel.text=str;
        
        
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tempatureArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
      //  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        
        
        UILabel * namelabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.font=[UIFont systemFontOfSize:15];
        //namelabel.text=@"温培方";
        namelabel.tag=NAMWTAG;
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        
        
        
        UILabel * tempatureLabel =[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 18)];
        tempatureLabel.backgroundColor=[UIColor clearColor];
        tempatureLabel.font=[UIFont systemFontOfSize:14];
       // tempatureLabel.text=@"体温";
        tempatureLabel.tag=TEMPATURETAGLABELTAG;
        [cell.contentView addSubview:tempatureLabel];
        [tempatureLabel release];
        
        UILabel * stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(170, 10, 100, 18)];
        stateLabel.backgroundColor=[UIColor clearColor];
        stateLabel.font=[UIFont systemFontOfSize:14];

       // stateLabel.text=@"体温正常";
        stateLabel.tag=STATETAG;
        [cell.contentView addSubview:stateLabel];
        [stateLabel release];
        
        UILabel * otherLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 300, 18)];
        otherLabel.backgroundColor=[UIColor clearColor];
        otherLabel.font=[UIFont systemFontOfSize:14];
;
      //  otherLabel.text=@"异常状态";
        otherLabel.tag=OTHERLABELTAG;
        [cell.contentView addSubview:otherLabel];
        [otherLabel release];

        
    }
    
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:NAMWTAG];
    UILabel *tempature=(UILabel *)[cell.contentView viewWithTag:TEMPATURETAGLABELTAG];
    UILabel *statelabel=(UILabel *)[cell.contentView viewWithTag:STATETAG];
    UILabel *otherLabel=(UILabel *)[cell.contentView viewWithTag:OTHERLABELTAG];
    GKTempature *temp=[self.tempatureArr objectAtIndex:indexPath.row];
    nameLabel.text=temp.name;
    statelabel.text=temp.state;
    tempature.text=[NSString stringWithFormat:@"%@℃",temp.tempature];
    otherLabel.text=[NSString stringWithFormat:@"异常状态：%@",temp.otherstate];
    if(temp.isTempature)
    {
        //if([temp.otherstate isEqualToString:@""])
        if([temp.otherstate isEqualToString:@""])
        {
            nameLabel.frame=CGRectMake(10, 10, 80, 20);
            tempature.frame=CGRectMake(90, 10, 100, 18);
            statelabel.frame=CGRectMake(200, 10, 100, 18);
             otherLabel.frame=CGRectZero;
            
        }
        else
        {
            nameLabel.frame=CGRectMake(10, 5, 80, 20);
            tempature.frame=CGRectMake(90, 5, 100, 18);
            statelabel.frame=CGRectMake(200, 5, 100, 18);
            otherLabel.frame=CGRectMake(10, 25, 300, 18);
        }
            
        
    }
    else
    {
        nameLabel.frame=CGRectMake(10, 10, 80, 20);
        tempature.frame=CGRectMake(150, 10, 100, 18);
        tempature.text=@"无晨检";
        statelabel.frame=CGRectZero;
        otherLabel.frame=CGRectZero;

    }

    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKTempature *temp=[self.tempatureArr objectAtIndex:indexPath.row];
    if(temp.isTempature)
    {
        if([temp.otherstate isEqualToString:@""])
        return 44;
        else
            return 50;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self._tableView=nil;
    self.tempatureArr=nil;
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
