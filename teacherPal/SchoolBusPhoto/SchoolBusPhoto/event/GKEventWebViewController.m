//
//  GKEventWebViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-12-12.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKEventWebViewController.h"
#import "KKNavigationController.h"

@interface GKEventWebViewController ()

@end

@implementation GKEventWebViewController
@synthesize urlstr;
-(void)dealloc
{
    self.urlstr=nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    titlelabel.text=@"活动详情";

    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, navigationView.frame.origin.y+navigationView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(navigationView.frame.origin.y+navigationView.frame.size.height))];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    [webView release];
                                                                  
                                                                  
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
-(void)leftClick:(UIButton *)b
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
