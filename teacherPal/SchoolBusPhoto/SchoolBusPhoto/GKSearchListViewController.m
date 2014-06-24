//
//  GKSearchListViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-6.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKSearchListViewController.h"
#import "KKNavigationController.h"
#import "GKStudentAdd.h"
#import "GKAddStudentViewController.h"
#import "MBProgressHUD.h"
#import "Student.h"
#import "GKUserLogin.h"
@interface GKSearchListViewController ()

@end

@implementation GKSearchListViewController
@synthesize listdic;
@synthesize tableView=_tableView;
@synthesize tel,name;
@synthesize currentSt;
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
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    titlelabel.text=NSLocalizedString(@"addstudent", @"");

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height-( navigationView.frame.size.height+navigationView.frame.origin.y)-80-20) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor colorWithRed:232/255.0 green:229/255.0 blue:220/255.0 alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
    
    UIView *backViewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    backViewHeader.backgroundColor=[UIColor clearColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.text=NSLocalizedString(@"selectstudentcorrect", @"");
    [backViewHeader addSubview:label];
    label.font=[UIFont systemFontOfSize:15];
     label.textColor=[UIColor grayColor];
    [label release];

    _tableView.tableHeaderView=[backViewHeader autorelease];
    
    
    
    UIView *backViewHfotter=[[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    backViewHfotter.backgroundColor=[UIColor clearColor];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 20)];
    label1.backgroundColor=[UIColor clearColor];
    label1.userInteractionEnabled=YES;
    label1.text=NSLocalizedString(@"telhelp", @"");
    [backViewHfotter addSubview:label1];
    label1.font=[UIFont systemFontOfSize:15];
    label1.textColor=[UIColor grayColor];
    [label1 release];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
    tap.numberOfTapsRequired=1;
    [label1 addGestureRecognizer:tap];
    [tap release];

    
    _tableView.tableFooterView=[backViewHfotter autorelease];
    
    NSString *joinstr=NSLocalizedString(@"joinclass", @"");
    addStudentToClass=[UIButton buttonWithType:UIButtonTypeCustom];
    addStudentToClass.frame=CGRectMake(40, self.view.frame.size.height-10-40-50, 240, 40);
    [addStudentToClass setTitle:joinstr forState:UIControlStateNormal];
    [addStudentToClass setTintColor:[UIColor whiteColor]];
    UIImage *iamge=[UIImage imageNamed:@"loginBtn.png"];
    [addStudentToClass setBackgroundImage:[iamge resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 15, 25)] forState:UIControlStateNormal];
    [addStudentToClass addTarget:self action:@selector(addStudentToClass:) forControlEvents:UIControlEventTouchUpInside];
    addStudentToClass.enabled=NO;
    [self.view addSubview:addStudentToClass];

    
    NSString  *result=[listdic objectForKey:@"result"];
    
    if(![result isEqualToString:@"3"])
    {
        NSString *string=NSLocalizedString(@"studentnew", @"");
        UIButton *addStudentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        addStudentBtn.frame=CGRectMake(40, self.view.frame.size.height-10-40, 240, 40);
        [addStudentBtn setTitle:string forState:UIControlStateNormal];
        [addStudentBtn setTintColor:[UIColor whiteColor]];
        UIImage *iamge=[UIImage imageNamed:@"loginBtn.png"];
        
        [addStudentBtn setBackgroundImage:[iamge resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 15, 25)] forState:UIControlStateNormal];
        [addStudentBtn addTarget:self action:@selector(addStudent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addStudentBtn];
    }
    

    // Do any additional setup after loading the view.
}
- (void)photoClick:(UITapGestureRecognizer *)tap {
    
    //NSLog(@"%@",[UIDevice currentDevice].model);
    // 如果ipod touch 不支持打电话
    if(tap.state==UIGestureRecognizerStateEnded)
    {
        if([[UIDevice currentDevice].model isEqualToString:@"iPod touch"] || [[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"]  ||[[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            UIAlertView *alertsupport=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"nosupport", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alertsupport show];
            [alertsupport release];
            return;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"call", @"") message:@"400-606-3996" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
        [alert release];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006063996"]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
    [_tableView reloadData];
}
-(void)addStudent:(UIButton *)btn
{
    GKAddStudentViewController *addStudentVC=[[GKAddStudentViewController alloc]init];
    addStudentVC.tel=self.tel;
    addStudentVC.name=self.name;
    [self.navigationController pushViewController:addStudentVC animated:YES];
    [addStudentVC release];
}
-(void)addStudentToClass:(UIButton *)btn
{

    
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD release];
    }
    if(self.currentSt)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:currentSt.studentID,@"studentid",currentSt.studentUID,@"studentuid",@"0",@"type",nil];
        [[EKRequest Instance]EKHTTPRequest:inclass parameters:dic requestMethod:GET forDelegate:self];
    }

}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }

    
    GKUserLogin *user=[GKUserLogin currentLogin];
    if(method==inclass)
    {
        if(code==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"successjoinclass", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        //    Student *st=[[Student alloc]init];
            
            NSDictionary *studentdic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
           // NSDictionary *studentdic=[dic objectForKey:@"student"];
            Student *student=[[Student alloc]init];
            
            student.age=[studentdic objectForKey:@"age"];
            student.avatar=[studentdic objectForKey:@"avatar"];
            student.birthday=[studentdic objectForKey:@"birthday"];
            student.cnname=[studentdic objectForKey:@"cnname"];
            student.enname=[studentdic objectForKey:@"enname"];
            student.filesize=[studentdic objectForKey:@"filesize"];
            
            
            student.mobile=[studentdic objectForKey:@"mobile"];
            student.sex=[studentdic objectForKey:@"sex"];
            student.studentid=[studentdic objectForKey:@"studentid"];
            student.studentno=[studentdic objectForKey:@"studentno"];
            student.orderendtime=[studentdic objectForKey:@"orderendtime"];
            
            student.uid=[studentdic objectForKey:@"uid_student"];
            
            student.username=[NSString stringWithFormat:@"%@",[studentdic objectForKey:@"username"]];
            student.parentid=[NSNumber numberWithInt:[[studentdic objectForKey:@"parentid"] integerValue]];
            [user.studentArr addObject:student];
            [student release];

            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
//            {"studentid":"49407","studentno":"49407","uid":"49407","cnname":"\u8881\u7231","enname":"\u8881\u7231","avatar":"http:\/\/cloud.yunxiaoche.com\/images\/student.jpg","filesize":"0"}
 
        }
        if(code==-2)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"allreadystudent", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
    }
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
-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr=[listdic objectForKey:@"list"];
    return [arr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    GKSearchCell *cell=(GKSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[GKSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate=self;
       // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
        
    }
     NSMutableArray *arr=[listdic objectForKey:@"list"];
    GKStudentAdd *student=[arr objectAtIndex:indexPath.row];
    cell.student=student;
    cell.nameLabel.text=student.studentName;
    cell.classLabel.text=student.className;
    cell.telLabel.text=student.parentTel;
    cell.agelabel.text=[NSString stringWithFormat:@"%d岁",student.age];
    if(student.sex==1)
    {
            cell.sexLabel.text=@"男生";
    }
    else
    {
        cell.sexLabel.text=@"女生";
    }

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"sfsf sfs";//NSLocalizedString(@"selectstudentcorrect", @"");
//}
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return NSLocalizedString(@"telhelp", @"");
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//
//    
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    label.backgroundColor=[UIColor clearColor];
//    label.text=NSLocalizedString(@"telhelp", @"");
//
//    return [label autorelease];
//}
-(void)cell:(GKSearchCell *)_cell student:(GKStudentAdd *)st
{
    NSMutableArray *arr=[listdic objectForKey:@"list"];
    for (int i=0; i<[arr count]; i++) {
    
        GKStudentAdd *stu=[arr objectAtIndex:i];
        
        if([stu isEqual:st])
        {
            if(st.isSelect==YES)
            {
                stu.isSelect=YES;
            }
            else
            {
                stu.isSelect=NO;
            }
        }
        else
        {
            stu.isSelect=NO;
        }
    }
   
    if(st.isSelect)
    {
        self.currentSt=st;
         addStudentToClass.enabled=YES;
        //st.isSelect=YES;
    }
    else
    {
        self.currentSt=nil;
        addStudentToClass.enabled=NO;
    }
    
     [_tableView reloadData];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.listdic=nil;
    self.tableView=nil;
    self.tel=nil;
    self.name=nil;
    self.currentSt=nil;
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
