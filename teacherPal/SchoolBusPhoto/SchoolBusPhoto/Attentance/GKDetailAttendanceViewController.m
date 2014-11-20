//
//  GKDetailAttendanceViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-18.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKDetailAttendanceViewController.h"
#import "GKAttentance.h"
#import "UIImageView+WebCache.h"
#import "KKNavigationController.h"
#import "GKShowBigImageViewController.h"
@interface GKDetailAttendanceViewController ()

@end

@implementation GKDetailAttendanceViewController
@synthesize attendanceArr,attendanceTableView;

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height)];
    bgView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
    [self.view addSubview:bgView];
    [bgView release];
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];

    attendanceTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-20) style:UITableViewStylePlain];

    attendanceTableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    attendanceTableView.delegate=self;
    attendanceTableView.dataSource=self;
    [self.view addSubview:attendanceTableView];
    
    
    titlelabel.text=@"考勤详情";
}
-(void)leftClick:(UIButton *)btn
{

    [self.navigationController popViewControllerAnimated:YES];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attendanceArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        UIImageView *iamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        iamgeView.backgroundColor=[UIColor clearColor];
        iamgeView.tag=1000;
        [cell.contentView addSubview:iamgeView];
        [iamgeView release];
        
        
        UILabel *createtime=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 150, 20)];
        createtime.backgroundColor=[UIColor clearColor];
        createtime.tag=1001;
        [cell.contentView addSubview:createtime];
        [createtime release];
    }
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:1000];
    UILabel *createLabel=(UILabel *)[cell.contentView viewWithTag:1001];
    GKAttentance *att=[attendanceArr objectAtIndex:indexPath.row];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",att.imagepath]]];
    

    NSDate *date= [NSDate dateWithTimeIntervalSince1970:[att.createtime integerValue]];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
   // [dateformatter setDateFormat:@"hh:MM"];
    
    NSString *timestr=[dateformatter stringFromDate:date];
    
   // label.text=timestr;

    
    createLabel.text=timestr;
  //  cell.imageView.backgroundColor=[UIColor redColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKAttentance *att=[attendanceArr objectAtIndex:indexPath.row];

    
    GKShowBigImageViewController *show=[[GKShowBigImageViewController alloc]init];
    show.path=[NSString stringWithFormat:@"http://%@",att.imagepath];
    [self.navigationController presentViewController:show animated:YES completion:^{
        
    }];
    [show release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.attendanceTableView=nil;
    self.attendanceArr=nil;
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
