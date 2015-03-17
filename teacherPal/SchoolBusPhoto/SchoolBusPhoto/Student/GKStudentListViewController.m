//
//  GKStudentListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-2.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKStudentListViewController.h"
#import "GKUserLogin.h"
#import "Student.h"
#import "KKNavigationController.h"
#import "GKStudentInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "GKAddStudentSearchViewController.h"
#import "GKMainViewController.h"
#import "GKTempature.h"
#define CELLTAG 100
@interface GKStudentListViewController ()

@end

@implementation GKStudentListViewController
@synthesize _tableView;
@synthesize studentArr;
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
    
     numLabel.text=[NSString stringWithFormat:@"%@%lu",NSLocalizedString(@"studentCount", @""),(unsigned long)self.studentArr.count];
    [_tableView reloadData];
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
    // 139 56

    UIButton *buttonRight=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame=CGRectMake(240, 8, 70, 30);
    NSString * addstr=NSLocalizedString(@"add", "");
    [buttonRight setTitle:addstr forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"inclass.png"] forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"inclassed.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonRight];
    buttonRight.titleLabel.font=[UIFont systemFontOfSize:15];
    [buttonRight addTarget:self action:@selector(addStudent:) forControlEvents:UIControlEventTouchUpInside];
    
    titlelabel.text=NSLocalizedString(@"student", @"");
    GKUserLogin *user=[GKUserLogin currentLogin];
    
    self.studentArr= user.studentArr;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-20) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_tableView];

    
    headView=[[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    
    summeryLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    summeryLabel.backgroundColor=[UIColor clearColor];
    summeryLabel.numberOfLines=0;
    summeryLabel.textColor=[UIColor whiteColor];
    summeryLabel.font=[UIFont systemFontOfSize:12];
    [headView addSubview:summeryLabel];
    [summeryLabel release];
    _tableView.tableHeaderView=[headView autorelease];
    
    // 显示一共多少学生的View
   // NSLog(@"%@",self.view.frame.size.height);
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 320, 20)];
    bottomView.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.textColor=[UIColor whiteColor];

    numLabel.textAlignment=NSTextAlignmentCenter;

    numLabel.font=[UIFont systemFontOfSize:14];
    numLabel.text=[NSString stringWithFormat:@"%@%lu",NSLocalizedString(@"studentCount", @""),(unsigned long)self.studentArr.count];
    [bottomView addSubview:numLabel];
    
   // studentCount
    
    [self.view addSubview:bottomView];
    [numLabel release];
    [bottomView release];
    
    
    [self loadHealthState];
	// Do any additional setup after loading the view.
}
-(void)loadHealthState
{
  
    [[EKRequest Instance] EKHTTPRequest:studenthealth parameters:nil requestMethod:GET forDelegate:self];
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aa);

    if(method==studenthealth)
    {
        if(code==1)
        {
          //  [_tempatureArr removeAllObjects];
            
            NSDictionary *alldic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            
            NSArray *arr=[alldic objectForKey:@"reminder"];
            for (int i=0; i<[arr count]; i++) {
                NSDictionary *dic=[arr objectAtIndex:i];
                
                NSString *stuid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"studentid"]];
                
                for (int j=0; j<[studentArr count]; j++) {
                    Student *st=[studentArr objectAtIndex:j];
                    
                    if([st.studentid intValue]==[stuid intValue])
                    {
                        st.parentAlert=[dic objectForKey:@"reminder"];
                        st.inSchoolHealth=[dic objectForKey:@"healthstate"];
                   
                        break;
                        
                    }
                    
                }
                
            }
            
            
            NSArray *sumeryArr=[alldic objectForKey:@"summery"];
            NSMutableString *temstr=[[NSMutableString alloc]initWithString:@""];
            for (int i=0; i<sumeryArr.count; i++) {
                NSDictionary *dic=[sumeryArr objectAtIndex:i];
                
                
                [temstr appendFormat:@"%@:%@ 人 ",[dic objectForKey:@"title"],[dic objectForKey:@"num"]];
                
                
            }
            
            if([temstr isEqualToString:@""])
            {
                
            }
            else
            {
                CGSize size=[temstr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width-10, 200) lineBreakMode:NSLineBreakByWordWrapping];
                
                summeryLabel.frame=CGRectMake(5, 0, self.view.frame.size.width-10, size.height);
                headView.frame=CGRectMake(0, 0, self.view.frame.size.width, size.height+5);
                summeryLabel.text=temstr;
            }
 
            [self._tableView reloadData];
            //
        }
        
        
    }
    
}
-(void)addStudent:(UIButton *)btn
{
    GKAddStudentSearchViewController *addStudentVC=[[GKAddStudentSearchViewController alloc]init];
    [self.navigationController pushViewController:addStudentVC animated:YES];
    [addStudentVC release];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [studentArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 65, 60)];
        imageView.backgroundColor=[UIColor clearColor];
        imageView.tag=CELLTAG;
        
        [cell.contentView addSubview:imageView];
        [imageView release];
    
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 5, 90, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag=CELLTAG+1;
        nameLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        

        UIImageView *stateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 8, 8)];
        stateImageView.backgroundColor=[UIColor clearColor];
        stateImageView.tag=CELLTAG+3;
        [cell.contentView addSubview:stateImageView];
        [stateImageView release];
        
        UILabel *healthLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 220, 20)];
        healthLabel.backgroundColor=[UIColor clearColor];
        healthLabel.tag=CELLTAG+4;
        healthLabel.textColor=[UIColor grayColor];
        healthLabel.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:healthLabel];
        [healthLabel release];
        
        

        
        
        UILabel *reminderLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 220, 20)];
        reminderLabel.backgroundColor=[UIColor clearColor];
        reminderLabel.tag=CELLTAG+5;
        reminderLabel.textColor=[UIColor grayColor];
        reminderLabel.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:reminderLabel];
        [reminderLabel release];
        
        
        UIImageView *LineimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69, 320, 1)];
        
        LineimageView.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [cell.contentView addSubview:LineimageView];
        [LineimageView release];
        
        
   
        
    }
    Student *st=[studentArr objectAtIndex:indexPath.row];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:CELLTAG];
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+1];
   // UILabel *ageLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+2];
    UIImageView *stateImageView=(UIImageView *)[cell.contentView viewWithTag:CELLTAG+3];
    UILabel *healthLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+4];
    UILabel *reminderLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+5];
    
    if([st.healthstate isEqualToString:@""])
    {
        nameLabel.frame=CGRectMake(75, 10, 90, 20);
       // ageLabel.frame=CGRectMake(150 , 15, 60, 20);
        //inschoolLabel.frame=CGRectMake(220, 10, 70, 20);
        healthLabel.frame=CGRectZero;
        
        reminderLabel.frame=CGRectMake(75, 40, 220, 20);
    }
    else
    {
        nameLabel.frame=CGRectMake(75, 5, 90, 20);
       // ageLabel.frame=CGRectMake(150 , 5, 60, 20);
        //inschoolLabel.frame=CGRectMake(220, 5, 70, 20);

        reminderLabel.frame=CGRectMake(75, 25, 220, 20);
        healthLabel.frame=CGRectMake(75, 45, 220, 20);
    }
   
    
    [imageView setImageWithURL:[NSURL URLWithString:st.avatar] placeholderImage:nil options:SDWebImageRefreshCached];
    if([st.parentAlert isEqualToString:@""])
    {
        reminderLabel.text=@"今日提醒：无";
    }
    else
    {
        reminderLabel.text=[NSString stringWithFormat:@"今日提醒：%@",st.parentAlert];
    }
    nameLabel.text=st.enname;;
//    if([st.age intValue]<=0)
//     ageLabel.text=[NSString stringWithFormat:@"%d %@",0,NSLocalizedString(@"oldyear", @"")];
//    else
//    ageLabel.text=[NSString stringWithFormat:@"%@ %@",st.age,NSLocalizedString(@"oldyear", @"")];
   // inschoolLabel.text=st.inSchoolHealth;
    if([st.inSchoolHealth integerValue]==0)
    {
        //bu
        stateImageView.image=[UIImage imageNamed:@"greenPoint.png"];
    }
    else if([st.inSchoolHealth integerValue]==1)
    {
        stateImageView.image=[UIImage imageNamed:@"redPoint.png"];
    }
    else
    {
        stateImageView.image=nil;
         //stateImageView.image=[UIImage imageNamed:@"redPoint.png"];
    }
    
    healthLabel.text=st.healthstate;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Student *st=[studentArr objectAtIndex:indexPath.row];
    GKStudentInfoViewController *infoVC=[[GKStudentInfoViewController alloc]init];
    infoVC.st=st;
    [self.navigationController pushViewController:infoVC animated:YES];
    [infoVC release];
}
-(void)viewDidUnload
{
    [_tableView release];
    _tableView=nil;
    [super viewDidUnload];
}
-(void)dealloc
{
    self._tableView=nil;
    self.studentArr=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
