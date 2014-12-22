//
//  ETPraiseViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETPraiseViewController.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "MD5.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface ETPraiseViewController ()

@end

@implementation ETPraiseViewController
@synthesize contentView;
@synthesize problem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)leftButtonClick:(id)sender
{
    [contentView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)keyboarChange:(NSNotification *)noti
{
//    NSDictionary *userInfo=[noti userInfo];
//    
//    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGRect rect1=[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    
//    
//    NSLog(@"%f---%f",rect1.size.width,rect1.size.height);
    
//    [UIView animateWithDuration:0.2 animations:^{
//        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
//        //        if(ios7)
//        //            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y+20);
//        //        else
//        //            __tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y);
//        
//        
//    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        inputView.frame=CGRectMake(0, self.view.frame.size.height-57, 320, 57);
//        //        __tableView.frame=CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-58);
//    }];
    
}
-(void)keyboarShow:(NSNotification *)noti
{
   // NSDictionary *userInfo=[noti userInfo];
    
 //   CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
 
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor=[UIColor blackColor];
    

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
//    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
//    popGes.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:popGes];
//    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = NSLocalizedString(@"evaluation", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  //  [rightButton setTitle:@"评价" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];



    
//    UIScrollView *scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
//    [self.view addSubview:scroller];
//    scroller.backgroundColor=[UIColor clearColor];
//    [scroller release];
    
    
    topView=[[UIView alloc]initWithFrame:CGRectMake(6, NAVIHEIGHT + (ios7 ? 20 : 0)+5, self.view.frame.size.width-12, 120)];
    topView.backgroundColor=[UIColor whiteColor];
    topView.layer.cornerRadius=10;
    
    [self.view addSubview:topView];
    [topView release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(6, 11, self.view.frame.size.width-12, 20)];
    label.text=NSLocalizedString(@"Overall_evaluation", @"");
    label.font=[UIFont systemFontOfSize:15];
    
    if(IOSVERSION>=6.0)
    {
        label.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        label.textAlignment=UITextAlignmentCenter;
    }
    label.backgroundColor=[UIColor clearColor];
    [topView addSubview:label];
    [label release];
    
    for (int i=0; i<5; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((self.view.frame.size.width-12)/2.0-75+30*i, label.frame.size.height+label.frame.origin.y+20, 25, 24);
        [btn addTarget:self action:@selector(praiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [btn setBackgroundImage:[UIImage imageNamed:@"health_star_gray.png"] forState:UIControlStateNormal];
         [btn setBackgroundImage:[UIImage imageNamed:@"health_star_yellow.png"] forState:UIControlStateSelected];
        [topView addSubview:btn];
    }
    startlabl=[[UILabel alloc]initWithFrame:CGRectMake(0 ,label.frame.size.height+label.frame.origin.y+10 +20 + 30,320,20)];
    startlabl.text=NSLocalizedString(@"start_evaluation", @"");
    startlabl.font=[UIFont systemFontOfSize:14];
    if(IOSVERSION>=6.0)
    {
        startlabl.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        startlabl.textAlignment=UITextAlignmentCenter;
    }
    startlabl.backgroundColor=[UIColor clearColor];
    startlabl.textColor=[UIColor grayColor];
    [topView addSubview:startlabl];
    [startlabl release];


    
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(6, topView.frame.size.height+topView.frame.origin.y+20, 308, 100)];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.layer.cornerRadius=10;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    self.placeholder=NSLocalizedString(@"comments_input", @"");
    contentView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, 290, 90)];
    contentView.delegate=self;
    contentView.text=self.placeholder;
    contentView.textColor=[UIColor grayColor];
    contentView.font=[UIFont systemFontOfSize:15];
    [bottomView addSubview:contentView];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
          [self.view bringSubviewToFront:statusbar];
        
    }
  
    
    [self.view bringSubviewToFront:navigationBackView];

    
       [self.view bringSubviewToFront:leftButton];
              [self.view bringSubviewToFront:middleLabel];
        [self.view bringSubviewToFront:rightButton];
    // Do any additional setup after loading the view.
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        topView.frame=CGRectMake(topView.frame.origin.x, topView.frame.origin.y-100, topView.frame.size.width, topView.frame.size.height);
        bottomView.frame=CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y-100, bottomView.frame.size.width, bottomView.frame.size.height);
    }];
  
    if([textView.text isEqualToString:self.placeholder])
    {
        contentView.text=@"";
         contentView.textColor=[UIColor blackColor];
    }
    else
    {
         contentView.textColor=[UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        topView.frame=CGRectMake(topView.frame.origin.x, topView.frame.origin.y+100, topView.frame.size.width, topView.frame.size.height);
        bottomView.frame=CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y+100, bottomView.frame.size.width, bottomView.frame.size.height);
    }];

    if([textView.text isEqualToString:@""] || [textView.text isEqualToString:self.placeholder])
    {
        contentView.text=self.placeholder;
        contentView.textColor=[UIColor grayColor];
    }
    else
    {
        contentView.textColor=[UIColor blackColor];
    }
}
-(void)praiseBtn:(UIButton *)btn
{
    int tag=btn.tag;
    star=tag+1;

    
    if(star==0)
    {
        startlabl.text=NSLocalizedString(@"start_evaluation", @"");
    }
    else if(star==1)
    {
        startlabl.text=NSLocalizedString(@"start_bad", @"");
    }
    else if(star==2)
    {
        startlabl.text=NSLocalizedString(@"start_Unsatisfied", @"");
    }
    else if(star==3)
    {
        startlabl.text=NSLocalizedString(@"start_General", @"");
    }
    else if(star==4)
    {
        startlabl.text=NSLocalizedString(@"start_Satisfied", @"");
    }
    else if(star==5)
    {
        startlabl.text=NSLocalizedString(@"start_Perfect", @"");
    }
    
    for (UIView *view in topView.subviews) {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton *)view;
            
            if(btn.tag<=tag)
            {
                btn.selected=YES;
            }
            else
            {
                btn.selected=NO;
            }
            
        }
        
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)rightButtonClick:(UIButton *)btn
{
    if(star==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:@"请选择评分" delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    if(HUD==nil)
    {
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.labelText=NSLocalizedString(@"load", @"");
        [self.view addSubview:HUD];
        [HUD release];
        [HUD show:YES];
    }
    
    UserLogin *user=[UserLogin currentLogin];


    int time= [[NSDate date] timeIntervalSince1970];

    NSString *string=[NSString stringWithFormat:@"%d_%@_%@",time,self.problem.problemId,@"247c78y@328y2z89x948c"];

    NSString *sign=[MD5 md5:string];


    ASIFormDataRequest *resuest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://yzxc.summer2.chunyu.me/partner/yzxc/problem/assess"]];
    [resuest setPostValue:user.username forKey:@"user_id"];

    [resuest setPostValue:self.problem.problemId forKey:@"problem_id"];
     [resuest setPostValue:contentView.text forKey:@"content"];
      [resuest setPostValue:[NSNumber numberWithInt:star] forKey:@"star"];
    [resuest setPostValue:sign forKey:@"sign"];



    [resuest setPostValue:[NSString stringWithFormat:@"%d",time] forKey:@"atime"];
    [resuest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"nopic",@"pic", nil]];
    [resuest setDelegate:self];
    //配置代理为本类
    [resuest setTimeOutSeconds:10];
    //设置超时
    [resuest setDidFailSelector:@selector(urlRequestFailed:)];
    [resuest setDidFinishSelector:@selector(urlRequestSucceeded:)];
    
    [resuest startAsynchronous];
    
    
}
-(void)urlRequestSucceeded:(ASIFormDataRequest *)request
{
        NSLog(@"%@",request.responseString);
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    if(dic)
    {
        if([[dic objectForKey:@"error"] integerValue]==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:NSLocalizedString(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
         
            self.problem.status=@"d";
            [_delegate reloadDetailVC];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:NSLocalizedString(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}
-(void)urlRequestFailed:(ASIFormDataRequest *)request
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"提示") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.contentView=nil;
    self.problem=nil;
    self.placeholder=nil;
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
