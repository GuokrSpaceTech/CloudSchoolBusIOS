//
//  ETPrivateViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-24.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETPrivateViewController.h"
#import "ETKids.h"
#import "ETCustomAlertView.h"

@interface ETPrivateViewController ()

@end

@implementation ETPrivateViewController
@synthesize myWebView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
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
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-80, 13 + (ios7 ? 20 : 0), 160, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"private_title", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT + (ios7 ? 20 : 0), 320, (iphone5 ? 548 : 460) - NAVIHEIGHT)];
    [webView setUserInteractionEnabled:YES];
    webView.backgroundColor = [UIColor clearColor];
    [webView  setDelegate:self];
    [webView setOpaque:NO];
    [webView setScalesPageToFit:NO]; //自动缩放以适应屏幕
    [self.view addSubview:webView];
    [webView release];
//    self.webView.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0.97 alpha:1.0];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cloud.yunxiaoche.com/html/privacy.html"]]];
    
    
    
    self.myWebView = webView;
    
}
- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
//}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.myWebView stopLoading];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.myWebView = nil;
    [super dealloc];
}

@end
