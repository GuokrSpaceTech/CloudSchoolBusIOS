				//
//  ETActiveDetailViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-10.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETActiveDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "AppDelegate.h"
#import "ETCommonClass.h"
#import "ETCoreDataManager.h"

@interface ETActiveDetailViewController ()

@end

@implementation ETActiveDetailViewController
@synthesize etevent;
@synthesize webview,delegate,fontStr;
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
    
    self.view.backgroundColor=[UIColor blackColor];
    
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
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text=LOCAL(@"content12", @"活动内容");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    UIWebView *myWebview=[[[UIWebView alloc]initWithFrame:CGRectMake(0,NAVIHEIGHT + (ios7 ? 20 : 0), 320, self.view.frame.size.height-NAVIHEIGHT - 44 - (ios7 ? 20 : 0))] autorelease];
    [myWebview setUserInteractionEnabled:YES];
    [myWebview  setDelegate:self];
    myWebview.backgroundColor=CELLCOLOR;
    [myWebview setOpaque:NO];
    [myWebview setScalesPageToFit:NO]; //自动缩放以适应屏幕
    [self.view addSubview:myWebview];
    [myWebview release];
    
    
    self.webview = myWebview;
    
    
    if (etevent.htmlurl != nil)
    {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:etevent.htmlurl]]];
    }
    
    tabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 , 320, 44)];
    [self.view addSubview:tabView];
    [tabView release];
    
    
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, tabView.frame.size.height)];
    backImgV.image = [UIImage imageNamed:@"bottomBack.png"];
    [tabView addSubview:backImgV];
    [backImgV release];
    
    
    NSArray *btnImg = [NSArray arrayWithObjects:@"activeTab1.png",@"activeTab2.png",@"activeTab3.png", nil];
    
    for (int i = 0; i<3; i++) {
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
        {
            if (etevent.isSignup.intValue == 1)     //已报名
            {
                [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateNormal];
                [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateHighlighted];
            }
            else if (etevent.isSignup.intValue == 0)    //未报名 图片命名错误
            {
                [bottomBtn setImage:[UIImage imageNamed:@"已报名.png"] forState:UIControlStateNormal];
                [bottomBtn setImage:[UIImage imageNamed:@"已报名.png"] forState:UIControlStateHighlighted];
            }
            
        }
        else
        {
            [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateNormal];
            [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateHighlighted];
        }
        
        [bottomBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [bottomBtn setBackgroundImage:[UIImage imageNamed:@"tabbarSelected.png"] forState:UIControlStateHighlighted];
        
//        [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateNormal];
//        [bottomBtn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateHighlighted];
        
        [bottomBtn setFrame:CGRectMake(i * 320/3.0f, 0, 320/3.0f, tabView.frame.size.height)];
        bottomBtn.tag = 999 + i;
        [bottomBtn addTarget:self action:@selector(doClickTabBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:bottomBtn];
        
    }
    
    
    UISwipeGestureRecognizer *popGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick:)];
    popGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGes];
    [popGes release];
    
    
    NSArray *fontArr = [NSArray arrayWithObjects:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'",
                        @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'",
                        @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'",
                        @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'", nil];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if (![userdefault objectForKey:@"TEXTFONT"]) {
        [userdefault setObject:[fontArr objectAtIndex:1] forKey:@"TEXTFONT"];
    }
    
    self.fontStr = [userdefault objectForKey:@"TEXTFONT"];
    
    
  	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (self.webview.isLoading) {
        [self.webview stopLoading];
    }
    
    
//    if (delegate && [delegate respondsToSelector:@selector(reloadTableData:)]) {
//        [delegate reloadTableData:etevent];
//    }
}

- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 1) {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:etevent.events_id,@"id", nil];
        [[EKRequest Instance] EKHTTPRequest:events parameters:dic requestMethod:POST forDelegate:self];
    }
}


- (void)doClickTabBtn:(UIButton *)sender
{
    if (sender.tag == 999)
    {
        if (etevent.isSignup.intValue == 0)
        {
            ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"baomingCon", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"ok", @""), nil];
            alert.delegate=self;
            [alert show];
        }
        else
        {
            ETCustomAlertView * alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"registerQuit", @"") delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") otherButtonTitles:LOCAL(@"ok", @""), nil];
            alert.delegate=self;
            [alert show];
        }
        
        
        
    }
    else if (sender.tag == 1000)
    {
        [self shareActive];
    }
    else if (sender.tag == 1001)
    {
        
        if ([sender backgroundImageForState:UIControlStateNormal])
        {
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
            
            // 设置字体消失
            [self removeFontSetting];
            
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"tabbarSelected.png"] forState:UIControlStateNormal];
            
            // 设置字体出现
            [self createFontSetting];
            
        }
        
    }
}
- (void)removeFontSetting
{
    if ([self.view viewWithTag:777]) {
        [[self.view viewWithTag:777] removeFromSuperview];
    }
}
- (void)createFontSetting
{
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44*2, 320, 44)];
    mView.tag = 777;
    [self.view addSubview:mView];
    [mView release];
    
    
    UIImageView *bImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bImgV.image = [UIImage imageNamed:@"fontBack.png"];
    [mView addSubview:bImgV];
    [bImgV release];
    
    NSArray *btnImg = [NSArray arrayWithObjects:@"font1.png",@"font2.png",@"font3.png",@"font4.png", nil];
    NSArray *fontArr = [NSArray arrayWithObjects:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'",
                                                @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'",
                                                @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'",
                                                @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'", nil];
    
    
    
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[btnImg objectAtIndex:i]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        if ([fontStr isEqualToString:[fontArr objectAtIndex:i]]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"fontSelect.png"] forState:UIControlStateNormal];
        }
        
        [btn setFrame:CGRectMake(i * 72 + 32 , 2, 40, 40)];
        btn.tag = 888 + i;
        [btn addTarget:self action:@selector(doClickFontBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mView addSubview:btn];
        
    }
    
}

- (void)doClickFontBtn:(UIButton *)sender
{
    
    UIView *v = [self.view viewWithTag:777];
    if (v != nil) {
        for (id obj in v.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *b = (UIButton *)obj;
                [b setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
        [sender setBackgroundImage:[UIImage imageNamed:@"fontSelect.png"] forState:UIControlStateNormal];

    }
        
//    NSString *fontStr;
    
    switch (sender.tag % 888) {
        case 0:
        {
            fontStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
            
            
            break;
        }
        case 1:
        {
            fontStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
            break;
        }
        case 2:
        {
            fontStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'";
            break;
        }
        case 3:
        {
            fontStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'";
            break;
        }
        default:
        {
            fontStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
            break;
        }
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:fontStr forKey:@"TEXTFONT"];
    
    [self.webview stringByEvaluatingJavaScriptFromString:fontStr];
    
    
    
    
    
}

-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/// navigation右侧按钮点击事件 弹出分享及报名按钮.

-(void)shareActive
{
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"logo_sinaweibo.png",@"腾讯微博.png",@"logo_wechat.png",@"logo_wechatmoments(1).png", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:LOCAL(@"sina", @""),LOCAL(@"tencent", @""),LOCAL(@"wechat", @""),LOCAL(@"friend", @"分享到微信朋友圈"), nil];
        
    
    MTCustomActionSheet *actionSheet = [[MTCustomActionSheet alloc] initWithFrame:CGRectZero andImageArr:imgArr nameArray:nameArr orientation:UIDeviceOrientationPortrait];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    
    if (index == 3) {
        
//        WXImageObject *ext = [WXImageObject object];
//        ext.imageData= UIImageJPEGRepresentation([UIImage imageNamed:@"icon.png"], 0.5f);
        
        WXWebpageObject *web = [WXWebpageObject object];
        web.webpageUrl = self.etevent.htmlurl;
        
//
//        message.mediaObject = ext;
        
        
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.etevent.title;
        message.description = self.etevent.htmlurl;
        message.mediaObject = web;
        message.thumbData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon.png"], 0.5f);
        
        
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.message = message;
        
        req.text = self.etevent.htmlurl;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];

        
        
    }
    else if (index == 2)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = etevent.htmlurl;
        message.description = @"";
        //        [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = etevent.htmlurl;
        
        message.mediaObject = ext;
        
        GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
        resp.message = message;
        resp.bText = NO;
        
        [WXApi sendResp:resp];
    }
    else
    {
        ETShareViewController *shareController=[[ETShareViewController alloc]initWithNibName:@"ETShareViewController" bundle:nil];
        shareController.shareType=index+1;
        shareController.shareContent.text=etevent.htmlurl;
        shareController.content = etevent.htmlurl;
        [self presentModalViewController:shareController animated:YES];
        [shareController release];
        
    }
}




-(void)alertShowText:(NSString *) text
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:text delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}



/**
 *	解析数据 封装成ETEvent类 并加载信息.
 *
 *	@param 	dic 	初始信息.
 */

-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
  
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
      
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == events) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
//        if(dic!=NULL)
//        {
//            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
////            NSString *key=[NSString stringWithFormat:@"%@ACTIVE",etevent.events_id];
////            [keyedArchiver setArchiver:key withData:dic forKey:key];
//            
//            
//            
//            return;
//        }
        
        NSLog(@"%@",dic);
        
        
        if (code==0)
        {
            
        }
        else if(code==1)
        {
            
            [self alertShowText:LOCAL(@"success",  @"成功")];
            
            if (etevent.isSignup.intValue == 0)
            {
                //报名成功
                
//                [self alertShowText:LOCAL(@"registerSuccess",  @"成功")];
                
                etevent.isSignup = @"1";
//                etevent.SignupStatus =
                UIButton *btn = (UIButton *)[tabView viewWithTag:999];
                [btn setImage:[UIImage imageNamed:@"activeTab1.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"activeTab1.png"] forState:UIControlStateHighlighted];
                
                [ETCoreDataManager addMyActivityData:[NSArray arrayWithObject:etevent]];
                
                
            }
            else if (etevent.isSignup.intValue == 1)
            {
                etevent.isSignup = @"0";
//                etevent.SignupStatus = 
                UIButton *btn = (UIButton *)[tabView viewWithTag:999];
                [btn setImage:[UIImage imageNamed:@"已报名.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"已报名.png"] forState:UIControlStateHighlighted];
                
                [ETCoreDataManager removeMyActivity:etevent];
                
                
            }
            [ETCoreDataManager updateActivity:etevent];
            [ETCoreDataManager updateNoStartActivity:etevent];
            
            // ----
            
            
            
            
        }
        else if(code==-4)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult11",  @"已报名但是取消报名失败")];
            
        }
        else if(code==-1)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult", @"活动不存在")];
        }
        else if(code==-6)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult22", @"已结束")];
        }
        else if(code==-5)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult33", @"未开始")];
        }
        else if(code==-7)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult44", @"满员")];
        }
        else if (code==-3)
        {
            [self alertShowText:LOCAL(@"baomingFailedResult55",  @"没有活动或不是本小区的活动")];
        }
        else
        {
            [self alertShowText:LOCAL(@"fail", @"报名失败")];
        }
    }
    
    
    
    
}
-(void) getErrorInfo:(NSError *) error
{
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}



#pragma mark
#pragma mark---webview
//web网页加载的时候执行下面方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}
//web网页加载完毕的时候执行下面方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webview stringByEvaluatingJavaScriptFromString:fontStr];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//web网页加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
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
//    self.webview = nil;
    self.etevent=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    //    if([[self selectedViewController] isKindOfClass:[子类 class]])
//    return NO;
//    
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}

@end
