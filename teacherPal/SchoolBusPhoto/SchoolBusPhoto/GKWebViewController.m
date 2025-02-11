//
//  GKWebViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-26.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKWebViewController.h"
#import "KKNavigationController.h"
@interface GKWebViewController ()

@end

@implementation GKWebViewController
@synthesize webController;
@synthesize urlstr;
@synthesize titlestr;
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
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
    titlelabel.text=titlestr;
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttom setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
  
    
    webController=[[UIWebView alloc]initWithFrame:CGRectMake(0, navigationView.frame.origin.y+navigationView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.origin.y-navigationView.frame.size.height)];
    webController.scalesPageToFit=YES;
    webController.delegate=self;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    
    [webController loadRequest:request];
    [self.view addSubview:webController];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
-(void)leftClick:(UIButton *)btn
{
  
    [self.navigationController popViewControllerAnimated:YES
     ];

    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)dealloc
{
    self.webController=nil;
    self.urlstr=nil;
    self.titlestr=nil;
    [super dealloc];
}
@end
