//
//  GKRelationViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-5-14.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKRelationViewController.h"
#import "Student.h"
#import "GKUserLogin.h"
#import "GKAddStudentSearchViewController.h"
@interface GKRelationViewController ()

@end

@implementation GKRelationViewController

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

    
    
    UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,navigationView.frame.size.height+navigationView.frame.origin.y+30, self.view.frame.size.width-20, 30)];
    tipLabel.backgroundColor=[UIColor clearColor];
    tipLabel.font=[UIFont systemFontOfSize:15];
    tipLabel.textColor=[UIColor grayColor];
    tipLabel.text=NSLocalizedString(@"confirmrelation", @"");
    [self.view addSubview:tipLabel];
    [tipLabel release];
    
    
    
    UIView * contentView=[[UIView alloc] initWithFrame:CGRectMake(10, tipLabel.frame.size.height+tipLabel.frame.origin.y+20, 300, 100)];
    contentView.backgroundColor=[UIColor whiteColor];
    
    contentView.layer.cornerRadius=10;
    [self.view addSubview:contentView];
    [contentView release];
    
    
    
    UIImageView *BGView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 50,290,1)];
    BGView.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    [contentView addSubview:BGView];
    [BGView release];
    
    NSArray *arr=[NSArray arrayWithObjects:NSLocalizedString(@"phone", @""),NSLocalizedString(@"theirkids", @""), nil];
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+50*i, 120, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[arr objectAtIndex:i];
        [contentView addSubview:label];
        if(i==1)
        {
            label.font=[UIFont systemFontOfSize:15];
            label.textColor=[UIColor grayColor];
        }
        else
        {
            label.font=[UIFont systemFontOfSize:17];
            label.textColor=[UIColor blackColor];
        }
            
        [label release];
    }
    
    UILabel *tel=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, 180, 30)];
    tel.backgroundColor=[UIColor clearColor];
    tel.text=self.tel;

    [contentView addSubview:tel];
    [tel release];
    
    UILabel *studentL=[[UILabel alloc]initWithFrame:CGRectMake(130, 10+50, 180, 30)];
    studentL.backgroundColor=[UIColor clearColor];
    studentL.text=self.student;
    studentL.textColor=[UIColor grayColor];
    studentL.font=[UIFont systemFontOfSize:15];
    [contentView addSubview:studentL];
    [studentL release];
    
    
    UIButton *addStudentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addStudentBtn.frame=CGRectMake(40,self.view.frame.size.height-90, 240, 40);
    [addStudentBtn setTitle:NSLocalizedString(@"LinkParent", @"") forState:UIControlStateNormal];
    [addStudentBtn setTintColor:[UIColor whiteColor]];
    UIImage *iamge=[UIImage imageNamed:@"loginBtn.png"];
    
    
    [addStudentBtn setBackgroundImage:[iamge resizableImageWithCapInsets:UIEdgeInsetsMake(20, 25, 15, 25)] forState:UIControlStateNormal];
    [addStudentBtn addTarget:self action:@selector(relationShip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addStudentBtn];
    
    
    UILabel *labeltip=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 30)];
    labeltip.userInteractionEnabled=YES;
    labeltip.backgroundColor=[UIColor clearColor];
    if(IOS7OFFSET>=6.0)
        labeltip.textAlignment=NSTextAlignmentCenter;
    else
        labeltip.textAlignment=UITextAlignmentCenter;
    labeltip.text=NSLocalizedString(@"telhelpdiffient", @"");
    labeltip.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:labeltip];
    [labeltip release];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
    tap.numberOfTapsRequired=1;
    [labeltip addGestureRecognizer:tap];
    [tap release];
    // Do any additional setup after loading the view.
}

- (IBAction)photoClick:(UITapGestureRecognizer *)tap {
    
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
-(void)relationShip:(UIButton *)btn
{
    
        if(HUD==nil)
        {
            HUD=[[MBProgressHUD alloc]initWithView:self.view];
            HUD.labelText=NSLocalizedString(@"load", @"");
            [HUD show:YES];
            [self.view addSubview:HUD];
            [HUD release];
        }
    
    if(self.photoString==nil)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.name,@"name",self.tel,@"tel",[NSNumber numberWithInt:self.sex],@"sex",self.birthday,@"birthday",self.parentid,@"parentid", nil]; //关联孩子
        [[EKRequest Instance]EKHTTPRequest:relationship parameters:dic requestMethod:POST forDelegate:self];

    }
    else
    {
          NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.name,@"name",self.tel,@"tel",[NSNumber numberWithInt:self.sex],@"sex",self.birthday,@"birthday",self.parentid,@"parentid",self.photoString,@"fbody", nil]; //关联孩子
        [[EKRequest Instance]EKHTTPRequest:relationship parameters:dic requestMethod:POST forDelegate:self];

    }
    
    
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{

    //NSString *aa=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if(method==relationship)
    {
        GKUserLogin *user=[GKUserLogin currentLogin];
        if(code==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"successjoinclass", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            Student *student=[[Student alloc]init];
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
//            st.studentid=[NSNumber numberWithInt:[[dic objectForKey:@"studentid"] intValue]];
//            st.studentno=[NSNumber numberWithInt:[[dic objectForKey:@"studentno"] intValue]];
//            st.stunumber=[NSNumber numberWithInt:[[dic objectForKey:@"studentno"] intValue]];
//            st.uid=[NSNumber numberWithInt:[[dic objectForKey:@"uid"] intValue]];
//            st.cnname=[dic objectForKey:@"cnname"];
//            st.enname=[dic objectForKey:@"enname"];
//            st.avatar=[dic objectForKey:@"avatar"];
//            st.filesize=[NSNumber numberWithInt:[[dic objectForKey:@"filesize"] intValue]];
//            st.birthday=[dic objectForKey:@"birthday"];
//            st.sex=[NSNumber numberWithInt:[[dic objectForKey:@"sex"] intValue]];
//            st.age=[NSNumber numberWithInt:[[dic objectForKey:@"age"] intValue]];
            
            
            NSDictionary *studentdic=[dic objectForKey:@"student"];
            student.age=[studentdic objectForKey:@"age"];
            student.avatar=[studentdic objectForKey:@"avatar"];
            student.birthday=[studentdic objectForKey:@"birthday"];
            student.cnname=[studentdic objectForKey:@"cnname"];
            student.enname=[studentdic objectForKey:@"enname"];
            student.filesize=[studentdic objectForKey:@"filesize"];
             student.orderendtime=[studentdic objectForKey:@"orderendtime"];
            
            student.mobile=[studentdic objectForKey:@"mobile"];
            student.sex=[studentdic objectForKey:@"sex"];
            student.studentid=[studentdic objectForKey:@"studentid"];
            student.studentno=[studentdic objectForKey:@"studentno"];
            student.sex=[NSNumber numberWithInt:[[studentdic objectForKey:@"sex"] integerValue]];
            
            student.uid=[studentdic objectForKey:@"uid_student"];
            
            student.username=[NSString stringWithFormat:@"%@",[studentdic objectForKey:@"username"]];
            student.parentid=[NSNumber numberWithInt:[[studentdic objectForKey:@"parentid"] integerValue]];
            [user.studentArr addObject:student];
            [student release];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
//            for (UIViewController *temp in self.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[GKAddStudentSearchViewController class]]) {
//                    [self.navigationController popToViewController:temp animated:YES];
//                }
//            }
            if(code==-4)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"allreadystudent", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                [alert show];
                [alert release];

            }
            

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)dealloc
{
    self.student=nil;
    self.parentid=nil;
    self.photoString=nil;
    self.tel=nil;
    self.name=nil;
    self.birthday=nil;
    [super dealloc];
}
@end
