//
//  ETViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETViewController.h"
#import "ETKids.h"
#define NAVIHEIGHT 44
@interface ETViewController ()

@end

@implementation ETViewController

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
  
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"InfoBackImage.png"]];
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"blackNavigationbar.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(5, 9, 65, 26);
    leftButton.hidden=YES;
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTintColor:[UIColor whiteColor]];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [self.view addSubview:leftButton];
    
//    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame=CGRectMake(225, 9,90, 26);
//    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setTintColor:[UIColor whiteColor]];
//    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:30];
//    [rightButton setTitle:@"···" forState:UIControlStateNormal];
//    [rightButton  setBackgroundImage:[UIImage imageNamed:@"rightNavigation"] forState:UIControlStateNormal];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"clickrightNavigation"] forState:UIControlStateHighlighted];
//    [self.view addSubview:rightButton];
    
    rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(225, 9,90, 26);
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTintColor:[UIColor whiteColor]];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [self.view addSubview:rightButton];
    rightButton.hidden=YES;
    
    middleView =[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:middleView];
    middleView.hidden=YES;
    [middleView release];
    
    middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 12, 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];

    [middleLabel release];
    
	// Do any additional setup after loading the view.
}




-(void)leftButtonClick:(id)sender
{
}

-(void)rightButtonClick:(id)sender
{
}
-(void)setMiddleText:(NSString *)str
{
    middleLabel.text=str;
}

-(void)setLeftTitle:(NSString *)left RightTitle:(NSString*)right
{
    if(left)
    {
        leftButton.hidden=NO;
        [leftButton setTitle:left forState:UIControlStateNormal];
    }
    
    if(right)
    {
        rightButton.hidden=NO;
        [rightButton setTitle:right forState:UIControlStateNormal];
    }

   
}

-(void)setNavigationleftImage:(UIImage *)left rightImage:(UIImage *)right 
{

    
    if(left)
    {
        leftButton.hidden=NO;
        [leftButton setBackgroundImage:left forState:UIControlStateNormal];
    }
    
    if(right)
    {
        rightButton.hidden=NO;
        [rightButton setBackgroundImage:right forState:UIControlStateNormal];
    }

  
}
-(void)setRightButton:(UIButton*)rihght
{
    rightButton.hidden=YES;
}
-(void)setRightButton:(UIImage *)right isEn:(BOOL)isEn;
{
    if(right)
    {
        rightButton.enabled=isEn;
        [rightButton setBackgroundImage:right forState:UIControlStateNormal];
    }
    

}
-(void)setGaoliamngleftImage:(UIImage *)left right:(UIImage *)right
{
    
    if(left)
    {
        leftButton.hidden=NO;
        [leftButton setBackgroundImage:left forState:UIControlStateHighlighted];
         [leftButton setBackgroundImage:left forState:UIControlStateSelected];
    }
    
    if(right)
    {
        rightButton.hidden=NO;
        [rightButton setBackgroundImage:right forState:UIControlStateHighlighted];
        [rightButton setBackgroundImage:right forState:UIControlStateSelected];
    }
    
    
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
    return NO;
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
