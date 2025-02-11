//
//  CBWebViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/23.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBWebViewController.h"
#import "CB.h"
#import "Masonry.h"
@interface CBWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
     UIProgressView * processView ;
}
@end

@implementation CBWebViewController
-(void)dealloc
{
    if(iOS8)
        [_wkWebview removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        NSString * process = [NSString stringWithFormat:@"%@",[object valueForKey:@"estimatedProgress"]];
        processView.progress = [process floatValue];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.titleStr;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    NSURLRequest * quest = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];

    if(iOS8)
    {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.mediaPlaybackRequiresUserAction = NO;
        _wkWebview  = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) configuration:configuration];
        _wkWebview.navigationDelegate = self;
        _wkWebview.UIDelegate = self;
        [self.view addSubview:_wkWebview];
         [_wkWebview loadRequest:quest];
        [_wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        //[_kwWebView loadRequest:request];
    }
    else
    {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _webview.delegate =self;
        [self.view addSubview:_webview];
        _webview.allowsInlineMediaPlayback = YES;
        _webview.mediaPlaybackRequiresUserAction = NO;
        // [_webView loadRequest:request];
        [_webview loadRequest:quest];
    }
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [commond ycShowProgressWithImage:_webView];
    //  [MBProgressHUD showHUDAddedTo:_webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   // [MBProgressHUD hideAllHUDsForView:_webView animated:YES];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    if(processView == nil)
    {
        processView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        processView.tintColor = [UIColor greenColor];
        [self.view addSubview:processView];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [processView removeFromSuperview];
    processView = nil;
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    // _kwWebView.configuration = configuration;
    [_wkWebview removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
    _wkWebview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64 - 49) configuration:configuration];
    _wkWebview.UIDelegate =self;
    _wkWebview.navigationDelegate = self;
    NSURL *url = navigationAction.request.URL;
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_wkWebview loadRequest:request];
    [self.view addSubview:_wkWebview];
    [_wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    return _wkWebview;
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
