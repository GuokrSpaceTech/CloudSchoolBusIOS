//
//  CBHobbyViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBHobbyViewController.h"
#import "CBDateBase.h"
#import "CB.h"

@interface CBHobbyViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
    UIProgressView * processView ;
    UIButton *reloadButton;
    UIButton *gobackButton;
}
@end

@implementation CBHobbyViewController
-(void)dealloc
{
    if(iOS8)
    {
        [_wkWebview removeObserver:self forKeyPath:@"estimatedProgress"];
        [_wkWebview removeObserver:self forKeyPath:@"title"];
        [_wkWebview removeObserver:self forKeyPath:@"loading"];
        [_wkWebview removeObserver:self forKeyPath:@"canGoBack"];
        [_wkWebview removeObserver:self forKeyPath:@"canGoForward"];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        processView.progress = self.wkWebview.estimatedProgress * 100.0f;
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.wkWebview.title;
    } else if ([keyPath isEqualToString:@"loading"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = self.wkWebview.loading;
        reloadButton.enabled = !self.wkWebview.loading;
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        gobackButton.enabled = self.wkWebview.canGoBack;
    } else if ([keyPath isEqualToString:@"canGoForward"]) {
    }
}

#pragma mark - navigation actions
-(void)backButtonAction:(id)sender
{
    if(iOS8)
    {
        [_wkWebview goBack];
    } else {
        [_webview goBack];
    }
}

-(void)itemClick:(id)sender
{
    if(iOS8)
    {
        [_wkWebview reload];
    } else {
        [_webview reload];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兴趣爱好";

    //Left Button in Navigation Bar
    reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"ic_refresh_white"] forState:UIControlStateNormal];
    reloadButton.frame = CGRectMake(0, 0, 50, 50);
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemReload = [[UIBarButtonItem alloc]initWithCustomView:reloadButton];
    self.navigationItem.rightBarButtonItem = itemReload;
    
    //Right Button in Navigation Bar
    gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gobackButton setImage:[UIImage imageNamed:@"ic_arrow_back_white"] forState:UIControlStateNormal];
    gobackButton.frame = CGRectMake(0, 0, 50, 50);
    [gobackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gobackButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [gobackButton setEnabled:false];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc]initWithCustomView:gobackButton];
    self.navigationItem.leftBarButtonItem = itemBack;
    
    //Load the page
    NSString *sid = [[CBLoginInfo shareInstance] sid];
    NSString *urlStr = [[NSString alloc] initWithFormat: @"http://api36.yunxiaoche.com/page/intrest/index?sid=%@", sid];
    NSURLRequest * quest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    if(iOS8)
    {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.mediaPlaybackRequiresUserAction = NO;
        _wkWebview  = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) configuration:configuration];
        _wkWebview.allowsBackForwardNavigationGestures = YES;
        _wkWebview.navigationDelegate = self;
        _wkWebview.UIDelegate = self;
        [self.view addSubview:_wkWebview];
        [_wkWebview loadRequest:quest];
        
        [_wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebview addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebview addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebview addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    }
    else
    {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _webview.delegate =self;
        [self.view addSubview:_webview];
        _webview.allowsInlineMediaPlayback = YES;
        _webview.mediaPlaybackRequiresUserAction = NO;
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL * url = navigationAction.request.URL;
    NSString * urlstring = [url absoluteString];
    NSLog(@">>>>>>>>>>>>>>%@<<<<<<<<<<<<<<<<<<<<<",urlstring);
    
    //NSRange range = [urlstring rangeOfString:@"wv.17mf.com"];
   decisionHandler(WKNavigationActionPolicyAllow);
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    [_wkWebview removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
    _wkWebview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64 - 49) configuration:configuration];
    _wkWebview.UIDelegate =self;
    _wkWebview.navigationDelegate = self;
    NSURL *url = navigationAction.request.URL;
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_wkWebview loadRequest:request];
    [self.view addSubview:_wkWebview];
    _wkWebview.allowsBackForwardNavigationGestures = YES;
    [_wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    return _wkWebview;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    gobackButton.enabled = webView.canGoBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
