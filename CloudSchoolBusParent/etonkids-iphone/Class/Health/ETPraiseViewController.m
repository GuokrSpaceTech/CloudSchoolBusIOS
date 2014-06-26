//
//  ETPraiseViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-26.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "ETPraiseViewController.h"
#import "ETKids.h"
@interface ETPraiseViewController ()

@end

@implementation ETPraiseViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statusbar];
        [statusbar release];
        
    }
    
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
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-100, 13 + (ios7 ? 20 : 0), 200, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = @"评价";
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    UIButton * rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"评价" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];


    
    UIScrollView *scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), self.view.frame.size.width, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    [self.view addSubview:scroller];
    scroller.backgroundColor=[UIColor clearColor];
    [scroller release];
    
    
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(6, 5, self.view.frame.size.width-12, 140)];
    topView.backgroundColor=[UIColor whiteColor];
    [scroller addSubview:topView];
    [topView release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-12)/2.0-30, 8, 60, 20)];
    label.text=@"总体评价";
    label.font=[UIFont systemFontOfSize:15];
    label.backgroundColor=[UIColor clearColor];
    [topView addSubview:label];
    [label release];
    
    
    for (int i=0; i<5; i++) {
        
        
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(70, 0, 30, 20);
    }
    

    UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(6, topView.frame.size.height+topView.frame.origin.y+10, 308, 220)];
    middleView.backgroundColor=[UIColor whiteColor];
    [scroller addSubview:middleView];
    [middleView release];
    
    
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(6, middleView.frame.size.height+middleView.frame.origin.y+20, 308, 78)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [scroller addSubview:bottomView];
    [bottomView release];
    // Do any additional setup after loading the view.
}
-(void)rightButtonClick:(UIButton *)btn
{
    
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

@end
