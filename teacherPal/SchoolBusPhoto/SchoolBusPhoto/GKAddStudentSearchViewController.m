//
//  GKAddStudentViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-4-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKAddStudentSearchViewController.h"
#import "GKSearchListViewController.h"
#import "GKStudentAdd.h"
#import "GKAddStudentViewController.h"
@interface GKAddStudentSearchViewController ()

@end

@implementation GKAddStudentSearchViewController
@synthesize nameField,telField;
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
    UILabel *labeltip=[[UILabel alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y+75/2.0, self.view.frame.size.width, 30)];
    
//    "studentinput"="Please enter the student's name and phone";
//    "nameinput"="Enter the student's name";
//    "telinput"="Enter the parents' phone";
    labeltip.backgroundColor=[UIColor clearColor];
    labeltip.text=NSLocalizedString(@"studentinput", @"");
    labeltip.font=[UIFont systemFontOfSize:15];
    if(IOSVERSION>=6.0)
    {
        labeltip.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        labeltip.textAlignment=UITextAlignmentCenter;
    }
    labeltip.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:labeltip];
    [labeltip release];
   
    UIView* contentView=[[UIView alloc] initWithFrame:CGRectMake(10, labeltip.frame.size.height+labeltip.frame.origin.y+25, 300, 90)];
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.tag=999;
    contentView.layer.borderColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1].CGColor;
    contentView.layer.borderWidth=1;
    contentView.layer.cornerRadius=10;
    [self.view addSubview:contentView];
    [contentView release];

    UIImageView *imageLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, 300, 1)];
    imageLine.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [contentView addSubview:imageLine];
    [imageLine release];
    
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(10,7, 280, 30)];
    nameField.borderStyle=UITextBorderStyleNone;
    nameField.placeholder=NSLocalizedString(@"nameinput", @"");
    nameField.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
    if(IOSVERSION>=6.0)
    {
        nameField.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        nameField.textAlignment=UITextAlignmentCenter;
    }
    
    [contentView addSubview:nameField];
    
    telField=[[UITextField alloc]initWithFrame:CGRectMake(10, 45+7, 280, 30)];
    telField.borderStyle=UITextBorderStyleNone;
    telField.placeholder=NSLocalizedString(@"telinput", @"");
    telField.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];;
    if(IOSVERSION>=6.0)
    {
        telField.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        telField.textAlignment=UITextAlignmentCenter;
    }
    
    [contentView addSubview:telField];
    
    
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *nextstr=NSLocalizedString(@"next", @"");
    nextBtn.frame=CGRectMake(40, self.view.frame.size.height+self.view.frame.origin.y-70, 240, 40);
    [nextBtn setTitle:nextstr forState:UIControlStateNormal];
    [nextBtn setTintColor:[UIColor whiteColor]];
    UIImage *iamge=[UIImage imageNamed:@"loginBtn.png"];
    
    
    [nextBtn setBackgroundImage:[iamge resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 15, 25)] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
  
}
-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)checkTel:(NSString *)str
{
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];

    if (!isMatch) {
        

        
        return NO;
        
    }
    
    
    
    return YES;
    
}
-(void)next:(UIButton *)btn
{
    [nameField resignFirstResponder];
    [telField resignFirstResponder];
    if([nameField.text isEqualToString:@""] || [telField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(![self checkTel:telField.text])
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"telformat", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
       
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:nameField.text,@"studentname",telField.text,@"tel", nil];

    [[EKRequest Instance]EKHTTPRequest:searchStudent parameters:dic requestMethod:GET forDelegate:self];
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [HUD show:YES];
        [self.view addSubview:HUD];
        [HUD release];
    }
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
//    NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",aa);
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(code==1&&method==searchStudent)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        
        NSString *result=[dic objectForKey:@"result"];// 1代表手机号收到的孩子 2代表姓名收到的孩子 3代表手机号和姓名收到的孩子 4代表手机号或姓名收到的孩子 5代表没有收到孩子
        
        NSArray *arr=[dic objectForKey:@"student"];
        
    
        NSMutableArray *list=[[NSMutableArray alloc]init];
        
        for (int i=0; i<[arr count]; i++) {
            GKStudentAdd *student=[[GKStudentAdd alloc]init];
            student.className=[[arr objectAtIndex:i] objectForKey:@"classname"];
            student.classID=[[arr objectAtIndex:i] objectForKey:@"classid"];
            student.classUID=[[arr objectAtIndex:i] objectForKey:@"uid_class"];
            student.studentID=[[arr objectAtIndex:i] objectForKey:@"studentid"];
            student.studentUID=[[arr objectAtIndex:i] objectForKey:@"student_uid"];
            student.parentTel=[[arr objectAtIndex:i] objectForKey:@"mobile"];
            student.birthday=[[arr objectAtIndex:i] objectForKey:@"birthday"];
            student.sex= [[[arr objectAtIndex:i] objectForKey:@"sex"] intValue];
            student.age=[[[arr objectAtIndex:i] objectForKey:@"age"] intValue];//[self getAge:student.birthday];
            student.studentName=[[arr objectAtIndex:i] objectForKey:@"cnname"];
            
            [list addObject:student];
            [student release];
        }
        NSDictionary *disPass=[NSDictionary dictionaryWithObjectsAndKeys:result,@"result",list,@"list", nil];
         [list release];
        
        if([list count]>0)
        {
            GKSearchListViewController *searchListVC=[[GKSearchListViewController alloc]init];
            searchListVC.name=nameField.text;
            searchListVC.tel=telField.text;
            searchListVC.listdic=disPass;
            [self.navigationController pushViewController:searchListVC animated:YES];
            [searchListVC release];
           
        }
        if([list count]==0)
        {
            GKAddStudentViewController *addStudentVC=[[GKAddStudentViewController alloc]init];
            addStudentVC.name=nameField.text;
            addStudentVC.tel=telField.text;
            [self.navigationController pushViewController:addStudentVC animated:YES];
            [addStudentVC release];
        }
        
    }
    else
    {
        if(code==-3)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        if(code==-2)
        {

            //手机号格式不正确
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"telformat", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
  
}
-(int)getAge:(NSString *)birthday
{
    NSDate *date=[NSDate date];
    
 
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    format.dateFormat = @"yyy-MM-dd";
    NSString * dateStr = [format stringFromDate:date];
    
    NSArray *arr=[dateStr componentsSeparatedByString:@"-"];
    
    int year=[[arr objectAtIndex:0] intValue];
    int month=[[arr objectAtIndex:1] intValue];
    
    NSArray *arr1=[dateStr componentsSeparatedByString:@"-"];
    
    int year1=[[arr1 objectAtIndex:0] intValue];
    int month1=[[arr1 objectAtIndex:1] intValue];
    
    int age=year-year1;
    if(month>month1)
    {
        
    }
    else
    {
        age+=1;
    }
    
    return age;

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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.nameField=nil;
    self.telField=nil;
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
