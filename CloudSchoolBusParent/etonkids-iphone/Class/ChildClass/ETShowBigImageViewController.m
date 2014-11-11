
//  ETShowBigImageViewController.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-8-5.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETShowBigImageViewController.h"



@interface ETShowBigImageViewController ()

@end

@implementation ETShowBigImageViewController
@synthesize picArr,showNum,tcEngine;
@synthesize content;
@synthesize targetImage;
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
    
    CGRect frame= [[UIScreen mainScreen]applicationFrame];
    
    bigImgV = [[ETShowBigImageView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), frame.size.width, frame.size.height ) AndShowImageNum:self.showNum dataArr:self.picArr content:content];
    
    //bigImgV.smallImgArr = self.shareContent.sharePicArr;
    bigImgV.delegate = self;
    bigImgV.alpha = 0.0f;
    [self.view addSubview:bigImgV];
    [bigImgV release];
    
    [UIView animateWithDuration:0.5f animations:^{
        bigImgV.alpha = 1.0f;
    }];
    
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
    
    
}

-(void)dealloc
{
    self.picArr=nil;
    self.tcEngine=nil;
    self.content=nil;
    self.targetImage=nil;
    [super dealloc];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark -------------- sina --------------
- (void)didSelectedShareImage:(UIImage *)image shareType:(int)shareType content:(NSString *)shareCOn
{
  
    
    if (shareType == 4) {
        WXMediaMessage *message = [WXMediaMessage message];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData= UIImageJPEGRepresentation(image, 0.5f);
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//        req.bText = NO;
        req.message = message;
        
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    }
    else if (shareType == 3)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        
        NSData *data=UIImageJPEGRepresentation(image, 0.1);
        // message.title=
        UIImage *imageTemp=[UIImage imageWithData:data];
        
        
        CGFloat width=imageTemp.size.width;
        CGFloat height=imageTemp.size.height;
        
        float scale=(float)(width/height);
        
        CGFloat scaleH=100/scale;
        
        UIImage *smallImage=[self imageWithImage:image scaledToSize:CGSizeMake(100, scaleH)];
        
        NSData *dataScale=UIImageJPEGRepresentation(smallImage, 1);
        NSLog(@"%d  K",[dataScale length]/1024);
        
        UIImage *imageThum=[UIImage imageWithData:dataScale];
        [message setThumbImage:imageThum];
        
        
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData=UIImageJPEGRepresentation(image, 0.5f);;
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        [WXApi sendReq:req];
    }
    else if (shareType == 5)
    {
        
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            if ([mailClass canSendMail]) {
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:self.title];
                [mc setMessageBody:self.content isHTML:NO];
                
                NSData *data = UIImagePNGRepresentation(image);
                [mc addAttachmentData:data mimeType:@"image/png" fileName:@"SharePicture.png"];
                [self presentModalViewController:mc animated:YES];
                [mc release];
            }else
            {
                [self launchMailAppOnDevice];

            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }

        
        
    }
    
    else
    {
        ETShareViewController *shareController=[[ETShareViewController alloc]initWithNibName:@"ETShareViewController" bundle:nil];
        
        shareController.shareType=shareType;
        shareController.content=shareCOn;
        shareController.imageData = UIImageJPEGRepresentation(image, 0.5f);
        [self presentModalViewController:shareController animated:YES];
    }
    
    
    
//    self.targetImage = image;
//    
//    //新浪
//    WeiboAccount *account=[[WeiboAccounts shared] currentAccount];
//    if(!account || account.accessToken==nil)
//    {
//        _weiboSignIn = [[WeiboSignIn alloc] init];
//        _weiboSignIn.delegate = self;
//        [_weiboSignIn signInOnViewController:self];
//    }
//    else
//    {
//        //新浪
//        [self sinaPostImage];
//        
//    }
}

- (void)launchMailAppOnDevice
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosetmail",  @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
}



- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail send canceled...");
            break;
        }
        case MFMailComposeResultSaved:
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            NSLog(@"Mail saved...");
            break;
        }
        case MFMailComposeResultSent:
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            NSLog(@"Mail sent...");
            break;
        }
        case MFMailComposeResultFailed:
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        }
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)sinaPostImage
{
    WeiboRequest *request = [[WeiboRequest alloc] initWithDelegate:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //        NSDictionary * dic = [self.imgUrlArr objectAtIndex:originShowNum];
    //        NSString * path = [dic objectForKey:@"source"];
    NSData *date= UIImageJPEGRepresentation(self.targetImage, 0.5);
    NSString *postPath = date ? @"statuses/upload.json" : @"statuses/update.json";
    [params setObject:date forKey:@"pic"];
    [params setObject:@"s" forKey:@"status"];
    [request postToPath:postPath params:params];
}

- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error
{
    //新浪
    [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    [self sinaPostImage];
}

- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"error: %@", error);
}
- (void)request:(WeiboRequest *)request didLoad:(id)result
{
    
    NSLog(@"load result : %@",result);
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"发送成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}


#pragma mark ----------------- tencent -------------------


- (void)didSelectedTencentShareImage:(UIImage *)image
{
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.ying7wang7.com"];
    [engine setRootViewController:self];
    //[engine setRedirectURI:@"http://www.ying7wang7.com"];
    self.tcEngine = engine;
    [engine release];
    
    
    
    //        NSDictionary * dic = [self.imgUrlArr objectAtIndex:originShowNum];
    //        NSString * path = [dic objectForKey:@"source"];
    //        NSLog(@"lkjghfdsa=%@",path);
    //        NSData *date=[NSData dataWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
//    NSData *data = UIImagePNGRepresentation(image);
    if(data)
    {
        //发表带图微博
        [self.tcEngine postPictureTweetWithFormat:@"json"
                                     content:nil
                                    clientIP:@"10.10.1.38"
                                         pic:data
                              compatibleFlag:@"0"
                                   longitude:nil
                                 andLatitude:nil
                                 parReserved:nil
                                    delegate:self
                                   onSuccess:@selector(successCallBack:)
                                   onFailure:@selector(failureCallBack:)];
        
    }
    else
    {

        //新浪
        WeiboRequest *request = [[WeiboRequest alloc] initWithDelegate:self];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSData *date= UIImageJPEGRepresentation(image, 0.5);
        NSString *postPath = date ? @"statuses/upload.json" : @"statuses/update.json";
        [params setObject:date forKey:@"pic"];
        [request postToPath:postPath params:params];

        [self.tcEngine postTextTweetWithFormat:@"json"
                                  content:nil
                                 clientIP:@"10.10.1.31"
                                longitude:nil
                              andLatitude:nil
                              parReserved:nil
                                 delegate:self
                                onSuccess:@selector(successCallBack:)
                                onFailure:@selector(failureCallBack:)];

    }
}
- (void)successCallBack:(id)result{
    NSDictionary *dic=(NSDictionary *)result;
    NSLog(@"~~~~~~~~~~~%@",dic);
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"发送成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    
}

- (void)failureCallBack:(NSError *)error{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
   
    NSLog(@"error: %@", error);
}


- (void)didClickBackButton
{
    
    
    
//    [UIView animateWithDuration:0.5f animations:^{
//        self.view.alpha = 0.0f;
//    } completion:^(BOOL finished) {
        [self dismissModalViewControllerAnimated:YES];
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}




@end
