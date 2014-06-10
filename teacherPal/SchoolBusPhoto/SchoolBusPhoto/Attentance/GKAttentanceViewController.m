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
    
    attenceArr=[[NSMutableArray alloc]init];
//    for (int i=0; i<10; i++) {
//        GKAttentance *attence=[[GKAttentance alloc]init];
//        
//       int a= arc4random()%2;
//        attence.studentName=@"小米";
//        if(a==0)
//        {
//            attence.isAttence=NO;
//            attence.intime=@"";
//            attence.outtime=@"";
//            
//        }
//        else
//        {
//            attence.isAttence=YES;
//            attence.intime=@"08:25";
//            attence.outtime=@"16:50";
//        }
//        
//        [self.attenceArr addObject:attence];
//        [attence release];
    //}
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",@"2014-06-05",@"date", nil];
    [[EKRequest Instance] EKHTTPRequest:attendancemanager parameters:dic requestMethod:GET forDelegate:self];
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
                GKAttentance *attence=[[GKAttentance alloc]init];
                attence.studentId=[[arr objectAtIndex:i] objectForKey:@"studentid"];
                attence.intime=[[arr objectAtIndex:i] objectForKey:@"start_time"];
                attence.outtime=[[arr objectAtIndex:i] objectForKey:@"end_time"];
                attence.inavater=[NSString stringWithFormat:@"http://%@",[[arr objectAtIndex:i] objectForKey:@"startpath"]];
                attence.outavater=[NSString stringWithFormat:@"http://%@",[[arr objectAtIndex:i] objectForKey:@"endpath"]];
                attence.studentName=[[arr objectAtIndex:i] objectForKey:@"enname"];
                attence.isAttence=YES;
                [attenceArr addObject:attence];

            }
            numLabel.text=[NSString stringWithFormat:@"考勤学生数量：%d",[arr count]];
            
            //计算出未考勤孩子
            GKUserLogin *user=[GKUserLogin currentLogin];
            for (int i=0; i<[user.studentArr count]; i++) {
                Student *st=[user.studentArr objectAtIndex:i];
                BOOL found=NO;
                for (int j=0; j<[attenceArr count]; j++) {
                    GKAttentance *attence=[attenceArr objectAtIndex:j];
                    
                    if([st.studentid intValue]  ==  [attence.studentId intValue])
                    {
                        found=YES;
                        break;
                    }

                }
                if(found==NO)
                {
                    GKAttentance *attence=[[GKAttentance alloc]init];
                    attence.studentId=[NSString stringWithFormat:@"%@",st.studentid];
                    attence.studentName=st.enname;
                    attence.intime=@"";
                    attence.outtime=@"";
                    [attenceArr addObject:attence];
                    [attence release];
                }
            }
            NSLog(@"-------%d",[attenceArr count]);
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
        
  
    }
    
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
        
        UILabel * namelabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
        namelabel.backgroundColor=[UIColor clearColor];
        namelabel.font=[UIFont systemFontOfSize:15];
        namelabel.text=@"温培方";
        namelabel.tag=TAGNAME;
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        
        
        
        UILabel * inlabel =[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 150, 18)];
        inlabel.backgroundColor=[UIColor clearColor];
        inlabel.font=[UIFont systemFontOfSize:14];
        inlabel.text=@"入园时间：";
        inlabel.tag=TAGINLABEL;
        [cell.contentView addSubview:inlabel];
        [inlabel release];
        
        UILabel * outlabel =[[UILabel alloc]initWithFrame:CGRectMake(80, 25, 150, 18)];
        outlabel.backgroundColor=[UIColor clearColor];
        outlabel.font=[UIFont systemFontOfSize:14];
        outlabel.text=@"离园时间：";
        outlabel.tag=TAGOUTLABEL;
        [cell.contentView addSubview:outlabel];
        [outlabel release];
        
//        
//        UILabel * inlabelR =[[UILabel alloc]initWithFrame:CGRectMake(170, 5, 50, 20)];
//        inlabelR.backgroundColor=[UIColor clearColor];
//        inlabelR.font=[UIFont systemFontOfSize:14];
//        inlabelR.text=@"09:34";
//        inlabelR.tag=TAGINTIME;
//        [cell.contentView addSubview:inlabelR];
//        [inlabelR release];
//        
//        UILabel * outlabelR =[[UILabel alloc]initWithFrame:CGRectMake(170, 30, 50, 20)];
//        outlabelR.backgroundColor=[UIColor clearColor];
//        outlabelR.font=[UIFont systemFontOfSize:14];
//        outlabelR.text=@"17:30";
//        outlabelR.tag=TAGOUTTIME;
//        [cell.contentView addSubview:outlabelR];
//        [outlabelR release];
        
        
        UIImageView *imageViewIn=[[UIImageView alloc]initWithFrame:CGRectMake(220, 5, 40, 40)];
        imageViewIn.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imageViewIn];
        imageViewIn.tag=TAGINIMAGE;
        [imageViewIn release];
        
        UIImageView *imageViewout=[[UIImageView alloc]initWithFrame:CGRectMake(265, 5, 40, 40)];
        imageViewout.backgroundColor=[UIColor clearColor];
        imageViewout.tag=TAGOUTIMAGE;
        [cell.contentView addSubview:imageViewout];
        [imageViewout release];
    }
    
    GKAttentance *attence=[attenceArr objectAtIndex:indexPath.row];
    
    UILabel *namelabel=(UILabel *)[cell.contentView viewWithTag:TAGNAME];
    namelabel.text=attence.studentName;
    UILabel *inlabel=(UILabel *)[cell.contentView viewWithTag:TAGINLABEL];
    inlabel.text=@"";
//    UILabel *intime=(UILabel *)[cell.contentView viewWithTag:TAGINTIME];
//    intime.text=@"";
    
    UILabel *outlabel=(UILabel *)[cell.contentView viewWithTag:TAGOUTLABEL];
    outlabel.text=@"";
//    UILabel *outtime=(UILabel *)[cell.contentView viewWithTag:TAGOUTTIME];
//    outtime.text=@"";
    
    
    UIImageView *inImageView=(UIImageView *)[cell.contentView viewWithTag:TAGINIMAGE];
    
    UIImageView *outImageView=(UIImageView *)[cell.contentView viewWithTag:TAGOUTIMAGE];
    inImageView.image=nil;
    outImageView.image=nil;
    
    if(attence.isAttence==NO)
    {
        inlabel.frame=CGRectMake(80, 15, 100, 18);
        inlabel.text=@"无记录";
        inImageView.image=nil;
        outImageView.image=nil;
    }
    else
    {
        inlabel.frame=CGRectMake(80, 5, 150, 18);
        inlabel.text=[NSString stringWithFormat:@"%@%@",@"入园时间：",attence.intime];
        outlabel.text=[NSString stringWithFormat:@"%@%@",@"离园时间：",attence.outtime];
        
        [inImageView setImageWithURL:[NSURL URLWithString:attence.inavater] placeholderImage:nil];
        [outImageView setImageWithURL:[NSURL URLWithString:attence.outavater] placeholderImage:nil];
//        intime.text=attence.intime;
//        outtime.text=attence.outtime;
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
