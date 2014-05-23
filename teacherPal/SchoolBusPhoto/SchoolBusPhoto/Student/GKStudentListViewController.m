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

    // 显示一共多少学生的View
   // NSLog(@"%@",self.view.frame.size.height);
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 320, 20)];
    bottomView.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.textColor=[UIColor whiteColor];
    if(IOSVERSION>=6.0)
        numLabel.textAlignment=NSTextAlignmentCenter;
    else
        numLabel.textAlignment=UITextAlignmentCenter;
    numLabel.font=[UIFont systemFontOfSize:14];
    numLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"studentCount", @""),self.studentArr.count];
    [bottomView addSubview:numLabel];
    
   // studentCount
    
    [self.view addSubview:bottomView];
    [numLabel release];
    [bottomView release];
    
	// Do any additional setup after loading the view.
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
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 65, 40)];
        imageView.backgroundColor=[UIColor clearColor];
        imageView.tag=CELLTAG;
        
        [cell.contentView addSubview:imageView];
        [imageView release];
    
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 15, 90, 20)];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag=CELLTAG+1;
        nameLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(150 , 15, 60, 20)];
        ageLabel.backgroundColor=[UIColor clearColor];
        ageLabel.font=[UIFont systemFontOfSize:14];
        if(IOSVERSION>=6.0)
            ageLabel.textAlignment=NSTextAlignmentCenter;
        else
            ageLabel.textAlignment=UITextAlignmentCenter;
        ageLabel.tag=CELLTAG+2;
        [cell.contentView addSubview:ageLabel];
        [ageLabel release];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(220, 15, 70, 20)];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.tag=CELLTAG+3;
        priceLabel.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:priceLabel];
        [priceLabel release];
        
        UIImageView *LineimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49, 320, 1)];
        
        LineimageView.image=IMAGENAME(IMAGEWITHPATH(@"line"));;
        [cell.contentView addSubview:LineimageView];
        [LineimageView release];
        
        
   
        
    }
     Student *st=[studentArr objectAtIndex:indexPath.row];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:CELLTAG];
    
    [imageView setImageWithURL:[NSURL URLWithString:st.avatar] placeholderImage:nil options:SDWebImageRefreshCached];
    UILabel *nameLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+1];
    nameLabel.text=st.enname;;
   
    UILabel *ageLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+2];
    if([st.uid integerValue]==0)
    {
        ageLabel.text=[NSString stringWithFormat:@"%@",@"未激活"];
    }
    else
    {
        ageLabel.text=[NSString stringWithFormat:@"%@ %@",st.age,NSLocalizedString(@"oldyear", @"")];
    }
    UILabel *priceLabel=(UILabel *)[cell.contentView viewWithTag:CELLTAG+3];
    
    if(st.orderendtime==nil  || [st.orderendtime isKindOfClass:[NSNull class]]  || [st.orderendtime isEqualToString:@""])
    {
        priceLabel.text=NSLocalizedString(@"Notservice", @"");
        priceLabel.textColor=[UIColor redColor];
        
    }
    else
    {
        int time=[[NSDate date] timeIntervalSinceNow];
        if(time<[[st orderendtime] integerValue])
        {
            priceLabel.text=NSLocalizedString(@"Inservice", @"");
            priceLabel.textColor=[UIColor blackColor];
        }
        else
        {
            priceLabel.text=NSLocalizedString(@"renewal", @"");
            priceLabel.textColor=[UIColor redColor];
        }
        
    }
    
  
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
