//
//  ETDetailInfoViewController.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETDetailInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "ETKids.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "AppDelegate.h"
@interface ETDetailInfoViewController ()

@end

@implementation ETDetailInfoViewController
@synthesize info,ScrollView,webView,downview;
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

    
    rightButton.frame = CGRectMake(245, rightButton.frame.origin.y, 65, rightButton.frame.size.height);
    
    [self setNavigationleftImage:[UIImage imageNamed:@"leftNavigation.png"] rightImage:[UIImage imageNamed:@"rightNavigation.png"]];
    [self setGaoliamngleftImage:[UIImage imageNamed:@"clickrightNavigation.png"] right:[UIImage imageNamed:nil]];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:30];
    [self setLeftTitle:LOCAL(@"back",@"返回") RightTitle:@"···"];

    
    [self setMiddleText:LOCAL(@"content11", @"资讯内容")];

    
    UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
    
    if(user.loginStatus==LOGIN_SERVER)
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:info.infoId,@"id", nil];
        [[EKRequest Instance] EKHTTPRequest:advertorial parameters:dic requestMethod:GET forDelegate:self];
        
        if(HUD==nil)
        {
            [self  showHUD:YES];
        }

    }
    else
    {
        
        NSString *key=[NSString stringWithFormat:@"%@INFOMATION",info.infoId];
        id obj = [keyedArchiver getArchiver:key forKey:key];
        if (obj != nil)
        {
            NSDictionary *_info=(NSDictionary *)obj;
       
            [self parser:_info];
        }

    }
  
    
    
	// Do any a`dditional setup after loading the view.
}
-(void)showHUD:(BOOL) animation
{
    if(animation)
    {
        if(HUD==nil)
        {
            
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
            [delegate.window addSubview:HUD];
            [HUD show:YES];
            [HUD release];
        }
        
    }
    else
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
    }
}
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/// 右侧按钮点击事件 弹出收藏及分享按钮.

-(void)rightButtonClick:(id)sender
{
    
    
    
    
    NSArray *imgArr=nil;
    NSArray *nameArr=nil;
    
    int tag;
    
    if(info.isCollect==1)
    {
        
        imgArr = [NSArray arrayWithObjects:@"取消收藏.png",@"logo_sinaweibo.png",@"腾讯微博.png",@"logo_wechat.png",@"logo_wechatmoments(1).png", nil];
        nameArr = [NSArray arrayWithObjects:LOCAL(@"CancleCollect", @"取消收藏"),LOCAL(@"sina", @""),LOCAL(@"tencent", @""),LOCAL(@"wechat", @""),LOCAL(@"friend", @"分享到微信朋友圈"), nil];
        
        tag = 100001;
        
        
    }
    else
    {
        
        imgArr = [NSArray arrayWithObjects:@"收藏.png",@"logo_sinaweibo.png",@"腾讯微博.png",@"logo_wechat.png",@"logo_wechatmoments(1).png", nil];
        nameArr = [NSArray arrayWithObjects:LOCAL(@"Favor", @"收藏"),LOCAL(@"sina", @""),LOCAL(@"tencent", @""),LOCAL(@"wechat", @""),LOCAL(@"friend", @"分享到微信朋友圈"), nil];
        
        tag = 100002;
        
    }
    
    MTCustomActionSheet *actionSheet = [[MTCustomActionSheet alloc] initWithFrame:CGRectZero andImageArr:imgArr nameArray:nameArr orientation:UIDeviceOrientationPortrait];
    actionSheet.delegate = self;
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    
}
- (void)actionSheet:(MTCustomActionSheet *)actionSheet didClickButtonByIndex:(int)index
{
    if (index == 0) {
        
        if(HUD==nil)
        {
            [self showHUD:YES];
        }
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:info.infoId,@"id",[NSNumber numberWithInt:1],@"haveCollect", nil];
        [[EKRequest Instance] EKHTTPRequest:advertorial parameters:dic requestMethod:POST forDelegate:self];
        
    }
    else if (index == 4) {
        //        WXMediaMessage *message = [WXMediaMessage message];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData= UIImageJPEGRepresentation([UIImage imageNamed:@"icon.png"], 0.5f);
        //
        //        message.mediaObject = ext;
        
        //        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        //        req.bText = YES;
        //
        //        req.text = self.etevent.htmlurl;
        //
        //        req.scene = WXSceneTimeline;
        ////        }
        //        [WXApi sendReq:req];
        
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.info.htmlurl;
        message.description = @"";
        //        [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
        
        //        WXWebpageObject *ext = [WXWebpageObject object];
        //        ext.webpageUrl = self.etevent.htmlurl;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.message = message;
        
        req.text = self.info.htmlurl;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
        //        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        //        req.bText = YES;
        //        req.text = self.etevent.htmlurl;
        //        req.scene = WXSceneTimeline;
        //
        //        [WXApi sendReq:req];
        
        
    }
    else
    {
        ETShareViewController *shareController=[[ETShareViewController alloc]initWithNibName:@"ETShareViewController" bundle:nil];
        
        shareController.shareType=index;
        shareController.shareContent.text=info.htmlurl;
        
        [self presentModalViewController:shareController animated:YES];
        
    }
}



/**
 *	根据参数加载资讯
 *
 *	@param 	_info 	资讯数据信息
 */
-(void)loadUI:(Infomation *)_info

{
    if(_info.isCollected)
    {
        [self setRightButton:[UIImage imageNamed:@"greeNavigationbar.png"] isEn:YES];
        rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:30];
        [self setLeftTitle:nil RightTitle:@"···"];

    }
    

    NSLog(@"%@",_info.publishTime);
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[_info.publishTime integerValue]];
    NSLog(@"%@",date.description);
    
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44)];
    [self.webView setUserInteractionEnabled:YES];
    [self.webView  setDelegate:self]; 
    [self.webView setOpaque:NO]; 
    [self.webView setScalesPageToFit:NO]; //自动缩放以适应屏幕
    [self.view addSubview:self.webView];
    self.webView.backgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0.97 alpha:1.0];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_info.htmlurl]]];

    
    downview=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-53, 320, 53)];
    [self.view insertSubview:downview atIndex:6];
    UIImageView  *downimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 53)];
    [downview addSubview:downimageview];
    downimageview.image=[UIImage  imageNamed:@"down.png"];
    [downimageview release];
    [downview release];
     downview.hidden=YES;
    //悬浮
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, self.view.frame.size.height-38-44-20, 44, 38);
    [button setBackgroundImage:[UIImage  imageNamed:@"悬浮.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    button.alpha=0.5;
    [self.view insertSubview:button atIndex:6];
    //16号
    button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(30,8, 44, 38);
    [button1 setBackgroundImage:[UIImage  imageNamed:@"onedown.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    [downview addSubview:button1];
    [button1 setBackgroundImage:[UIImage imageNamed:@"onedownH.png"] forState:UIControlStateHighlighted];
    //18号
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(94,8, 44, 38);
    [button2 setBackgroundImage:[UIImage  imageNamed:@"twodown.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"twodownH.png"] forState:UIControlStateHighlighted];
    [button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
    [downview addSubview:button2];
    //24号
    button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(162,8, 44, 38);
    [button3 setBackgroundImage:[UIImage  imageNamed:@"threedown.png"] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"threedownH.png"] forState:UIControlStateHighlighted];
    [button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
    [downview addSubview:button3];
    //28号
    button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(226,8, 44, 38);
    [button4 setBackgroundImage:[UIImage  imageNamed:@"fourdown.png"] forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"fourdownH.png"] forState:UIControlStateHighlighted];
    [button4 addTarget:self action:@selector(button4:) forControlEvents:UIControlEventTouchUpInside];
    [downview addSubview:button4];
    
    
    
    
}
#pragma mark--buttonclick
-(void)button:(UIButton*)sender
{
    downview.hidden=NO;
    
}
-(void)button1:(UIButton*)sender
{
    downview.hidden=YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'"];
}
-(void)button2:(UIButton*)sender
{
    downview.hidden=YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];  

}
-(void)button3:(UIButton*)sender
{
    downview.hidden=YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];

}
-(void)button4:(UIButton*)sender
{
     downview.hidden=YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'"];

}




/**
 *	封装资讯信息 并加载数据
 *
 *	@param 	dic 	初始数据
 */
-(void)parser:(NSDictionary *)dic
{
    Infomation *_info=[[[Infomation alloc]init] autorelease];
    _info.content=[dic objectForKey:@"content"];
    _info.infoId=[dic objectForKey:@"id"];
    _info.linkage=[dic objectForKey:@"linkage"];
    _info.publishTime= [NSString stringWithFormat:@"%@", [dic objectForKey:@"publishtime"]];
    _info.thumbnail=[dic objectForKey:@"thumbnail"];
    _info.title=[dic objectForKey:@"title"];
    _info.isCollected=[[dic objectForKey:@"iscollected"] integerValue];
    _info.htmlurl=[dic objectForKey:@"htmlurl"];
    [self loadUI:_info];

}
-(void)alertShowText:(NSString *) text
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:text delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    
    NSLog(@"%@",response);
    if(HUD)
    {
        [self showHUD:NO];
        HUD=nil;
    }
    if (code == -1113)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"mutilDevice", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        UserLogin * user = (UserLogin *)[keyedArchiver getArchiver:@"LOGIN" forKey:@"LOGIN"];
        if(user.loginStatus==LOGIN_OFF)
        {
            [[EKRequest Instance] clearSid];
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
            return;
        }
        
        [[EKRequest Instance] EKHTTPRequest:signin parameters:nil requestMethod:DELETE forDelegate:self];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (method == advertorial) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
        if(dic!=NULL)
        {
            
            NSString *key=[NSString stringWithFormat:@"%@INFOMATION",info.infoId];
            //  NSDictionary *dic=(NSDictionary *)response;
            
            
            [self parser:dic];
            
            [keyedArchiver setArchiver:key withData:dic forKey:key];
            
            return;
            
        }
        
        if(code==1)
        {
            [self alertShowText:LOCAL(@"success",  @"收藏成功")];
            
            if(info.isCollect==1)//取消收藏成功
            {
                [self setRightButton:[UIImage imageNamed:@"rightNavigation.png"] isEn:YES];
                info.isCollect = 0;
            }
            else
            {
                [self setRightButton:[UIImage imageNamed:@"greebutton.png"] isEn:YES];
                info.isCollect = 1;
            }
            
            //[self  setLeftTitle:nil RightTitle:@"· · ·"];
        }
        else if(code==-5)
        {
            [self alertShowText:LOCAL(@"CollectFailedResult", @"不能重复收藏") ];
        }
        else
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"收藏失败")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
    }
    
    else if (method == signin && code == 1)
    {
        [[EKRequest Instance] clearSid];
        UserLogin *user=[UserLogin currentLogin];
        user.loginStatus=LOGIN_OFF;
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
    }
    
    
}
-(void) getErrorInfo:(NSError *) error
{
    if(HUD)
    {
        [self showHUD:NO];
        HUD=nil;
    }
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}
#pragma mark
#pragma mark---webview
/// web网页加载的时候执行下面方法.
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHUD:YES];
 

}
/// web网页加载完毕的时候执行下面方法.
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
        [self showHUD:NO];

}
/// web网页加载失败.
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"busy", @"网络故障，请稍后重试") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    [self showHUD:NO];
}
-(void)dealloc
{
    self.info=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
