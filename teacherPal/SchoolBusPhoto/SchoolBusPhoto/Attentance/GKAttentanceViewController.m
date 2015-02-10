//
//  GKAttentanceViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-6-3.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKAttentanceViewController.h"
#import "GKMainViewController.h"
#import "GKAttentance.h"
#import "GKUserLogin.h"
#import "Student.h"
#import "UIImageView+WebCache.h"
#import "GKShowBigImageViewController.h"
#import "GKImageView.h"
#import "GKDetailAttendanceViewController.h"
#import "GKAttentanceObj.h"
#define TAGNAME 6256
#define TAGINLABEL 6257
#define TAGOUTLABEL 6258
//#define TAGINTIME 6259
//#define TAGOUTTIME 6260
#define TAGINIMAGE 6261
#define TAGOUTIMAGE 6262


@interface GKAttentanceViewController ()

@end

@implementation GKAttentanceViewController
@synthesize _tableView;
@synthesize attenceArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    attenceArr=[[NSMutableArray alloc]init];
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    todayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    todayBtn.frame=CGRectMake(240, 8, 70, 30);
    [todayBtn setTitle:NSLocalizedString(@"today", @"") forState:UIControlStateNormal];
    todayBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [todayBtn setBackgroundImage:[UIImage imageNamed:@"inclass.png"] forState:UIControlStateNormal];
    [todayBtn setBackgroundImage:[UIImage imageNamed:@"inclassed.png"] forState:UIControlStateHighlighted];
    todayBtn.hidden=YES;
    //[photobutton setImage:[UIImage imageNamed:@"upNormal.png"] forState:UIControlStateNormal];
    //[photobutton setImage:[UIImage imageNamed:@"upHight.png"] forState:UIControlStateHighlighted];
    [todayBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:todayBtn];
    
    UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(210,titlelabel.frame.origin.y+18, 10, 10)];
    arrowImageView.image=[UIImage imageNamed:@"arrowdown.png"];
    [navigationView addSubview:arrowImageView];
    [arrowImageView release];

    
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
   
    numLabel.textAlignment=NSTextAlignmentCenter;
   
    numLabel.font=[UIFont systemFontOfSize:14];
    
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
    
    [self loaddatebyDate:today];
    UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateClick:)];
    tapG.numberOfTapsRequired=1;
    [titlelabel addGestureRecognizer:tapG];
    [tapG release];
    
 


    
    
       // Do any additional setup after loading the view.
}
-(void)rightClick:(UIButton *)btn
{
    NSDate *date=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *today = [formatter stringFromDate:date];
    [formatter release];
    
    titlelabel.text=today;
    [self loaddatebyDate:today];
    
    todayBtn.hidden=YES;

}
-(void)loaddatebyDate:(NSString *)date
{
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD release];
    }

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",date,@"date", nil];
    [[EKRequest Instance] EKHTTPRequest:attendancemanager parameters:dic requestMethod:GET forDelegate:self];

}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
   // NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
 //   NSLog(@"%@",aa);
    if(method==attendancemanager)
    {
        if(code==1)
        {
            [attenceArr removeAllObjects];
            NSDictionary *rootDic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSArray *arr=[rootDic objectForKey:@"attendance"];
            for (int i=0; i<[arr count]; i++) {
                
                NSDictionary *dic=[arr objectAtIndex:i];
                
                GKAttentanceObj *obj=[[GKAttentanceObj alloc]init];
                obj.stuentid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"studentid"]];
                obj.cnname=[dic objectForKey:@"cnname"];
                obj.isAttence=YES;
               
                NSArray *attArr=[dic objectForKey:@"record"];
                
                for (int j=0; j<[attArr count]; j++) {
                    GKAttentance *attence=[[GKAttentance alloc]init];
                    attence.studentId=[[attArr objectAtIndex:j] objectForKey:@"studentid"];
                 
            
                    attence.studentName=[[attArr objectAtIndex:j] objectForKey:@"enname"];
                    attence.imagepath=[[attArr objectAtIndex:j] objectForKey:@"imgpath"];
                    attence.createtime=[[attArr objectAtIndex:j] objectForKey:@"createtime"];
                    [obj.attendanceArr addObject:attence];
                    [attence release];
                }
                
                [attenceArr addObject:obj];
                [obj release];
                

            }
            numLabel.text=[NSString stringWithFormat:@"%lu %@",(unsigned long)[attenceArr count],NSLocalizedString(@"alreadyattendance", @"")];
            
            //计算出未考勤孩子
            NSMutableArray *arrtemp=[[NSMutableArray alloc]init];
            
            GKUserLogin *user=[GKUserLogin currentLogin];
            for (int i=0; i<[user.studentArr count]; i++) {
                Student *st=[user.studentArr objectAtIndex:i];
                BOOL found=NO;
                for (int j=0; j<[attenceArr count]; j++) {
                    GKAttentanceObj *attence=[attenceArr objectAtIndex:j];
                    
                    if([st.studentid intValue]  ==  [attence.stuentid intValue])
                    {
                        found=YES;
                        break;
                    }

                }
                if(found==NO)
                {
                    GKAttentanceObj *attence=[[GKAttentanceObj alloc]init];
                    attence.cnname=st.cnname;
                    attence.isAttence=NO;
                    attence.stuentid=[NSString stringWithFormat:@"%@",st.studentid];
                    [arrtemp addObject:attence];
                    [attence release];
                }
            }
            
            [attenceArr addObjectsFromArray:arrtemp];
            [arrtemp release];
          //  NSLog(@"-------%d",[attenceArr count]);
            [self._tableView reloadData];

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
        
        [self loaddatebyDate:str];
        
        
        

        
        NSString *today = [formatter stringFromDate:[NSDate date]];
        if([today isEqualToString:str])
        {
            todayBtn.hidden=YES;
        }
        else
        {
            todayBtn.hidden=NO;
        }

        
  
    }
    
}
-(void)tapInClick:(UIGestureRecognizer *)tap
{
    GKShowBigImageViewController *show=[[GKShowBigImageViewController alloc]init];

    
    GKImageView *iamgeView=(GKImageView *)tap.view;
    show.path=iamgeView.urlPath;
    [self.navigationController presentViewController:show animated:YES completion:^{
        
    }];
    [show release];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attenceArr count];
} 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * namelabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.font=[UIFont systemFontOfSize:15];
        //namelabel.text=@"温培方";
        namelabel.tag=TAGNAME;
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        
        
        
        UILabel * normalLabel =[[UILabel alloc]initWithFrame:CGRectMake(150, 15, 100, 18)];
        normalLabel.backgroundColor=[UIColor clearColor];
        normalLabel.font=[UIFont systemFontOfSize:14];
        //inlabel.text=@"入园时间：";
        normalLabel.tag=TAGINLABEL;
        [cell.contentView addSubview:normalLabel];
        [normalLabel release];
        

        
    }
    
    GKAttentanceObj *attence=[attenceArr objectAtIndex:indexPath.row];
//    
    UILabel *namelabel=(UILabel *)[cell.contentView viewWithTag:TAGNAME];
    namelabel.text=attence.cnname;
    UILabel *normalLabel=(UILabel *)[cell.contentView viewWithTag:TAGINLABEL];
    if(attence.isAttence==YES)
    {
        normalLabel.text=@"有考勤";
    }
    else
    {
        normalLabel.text=@"无考勤";
    }

    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKAttentanceObj *obj=[attenceArr objectAtIndex:indexPath.row];
    
    NSMutableArray *arr=obj.attendanceArr;
    

    GKDetailAttendanceViewController *DetailVc=[[GKDetailAttendanceViewController alloc]init];
    DetailVc.attendanceArr=arr;
    [self.navigationController pushViewController:DetailVc animated:YES];
    [DetailVc release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self._tableView=nil;
    self.attenceArr=nil;
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
