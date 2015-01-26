
#import "ETShareViewController.h"
#import "ETKids.h"
@interface ETShareViewController ()

@end

@implementation ETShareViewController
@synthesize pic,content;
@synthesize shareType;
@synthesize imageData;
@synthesize wbEngine;

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
    

    UIImageView *navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, ios7 ? 20 : 0, 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13 + (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=NSTextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"share", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setCenter:CGPointMake(320 - 10 - 34/2 , navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton addTarget:self action:@selector(clickSend:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"OKBtn_sel.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightButton];
    
    
    
    
    _shareImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_shareImageView setImage:[UIImage imageWithData:self.imageData]];
    
//    NSString *path=self.pic;
//    if(path != nil)
//        [self performSelectorInBackground:@selector(loadImage:) withObject:path];
//    if (self.content != nil)
//        self.shareContent.text = self.content;
    
    
    if([content length]<100)
        _shareContent.text=content;
    else
        _shareContent.text=[content substringToIndex:100];
    
    
}
-(void)loadImage:(NSString *)_path
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    NSData *_imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_path] options:nil error:nil];
    
    [self performSelectorOnMainThread:@selector(LoadImageToView:) withObject:_imageData waitUntilDone:YES];
    [pool drain];
}
-(void)LoadImageToView:(NSData *)_data
{
    self.imageData=_data;
    [_shareImageView setImage:[UIImage imageWithData:_data]];
}


#pragma mark ---------- sina ----------------

- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to post: %@", error);
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    [request release];
    
//    self.send.userInteractionEnabled = YES;
//    self.send.alpha = 1.0f;
   
}

- (void)request:(WeiboRequest *)request didLoad:(id)result {
 
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"success", @"发送成功") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    [request release];
    [self clickCancel:nil];
    
    
 
}

- (void)sinaPostImage
{
    WeiboRequest *request = [[WeiboRequest alloc] initWithDelegate:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *postPath = self.imageData ? @"statuses/upload.json" : @"statuses/update.json";
    [params setObject:_shareContent.text forKey:@"status"];
    if (imageData) {
        [params setObject:imageData forKey:@"pic"];
    }
    
    [request postToPath:postPath params:params];
}
- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error
{
    //新浪
    [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    [self sinaPostImage];
}



#pragma mark ---------- tencent ----------------

- (void)successCallBack:(id)result{
    NSDictionary *dic=(NSDictionary *)result;
    
    
    NSLog(@"~~~~~~~~~~~%@",dic);
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"success", @"发送成功") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    

    [self clickCancel:nil];
}

- (void)failureCallBack:(NSError *)error{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"fail",  @"发送失败") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"error: %@", error);
    
//    self.send.userInteractionEnabled = YES;
//    self.send.alpha = 1.0f;
}

- (void)onSuccessLogin
{
    if(self.imageData)
    {
        //发表带图微博
        
        [wbEngine postPictureTweetWithFormat:@"json"
                                     content:_shareContent.text
                                    clientIP:@"10.10.1.38"
                                         pic:self.imageData
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
        [wbEngine postTextTweetWithFormat:@"json"
                                  content:_shareContent.text
                                 clientIP:@"10.10.1.31"
                                longitude:nil
                              andLatitude:nil
                              parReserved:nil
                                 delegate:self
                                onSuccess:@selector(successCallBack:)
                                onFailure:@selector(failureCallBack:)];
    }
}
- (void)onFailureLogin:(NSError *)error
{
    [self failureCallBack:error];
}


-(IBAction)clickSend:(UIButton *)sender
{
    //新浪
    
//    self.send.userInteractionEnabled = NO;
//    self.send.alpha = 0.5f;
    
    if(shareType==1)
    {
        
        WeiboAccount *account=[[WeiboAccounts shared] currentAccount];
        if(!account || account.accessToken==nil)
        {
            _weiboSignIn = [[WeiboSignIn alloc] init];
            _weiboSignIn.delegate = self;
            [_weiboSignIn signInOnViewController:self];
        }
        else
        {
            //新浪
            [self sinaPostImage];
            
        }

        
        
    }
    //腾讯
    if(shareType==2)
    {
        TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.yunxiaoche.com"];
        [engine setRootViewController:self];
        self.wbEngine = engine;
        [engine release];
        
        if([[self.wbEngine openId] length]>0)
        {
            if(![self.wbEngine isAuthorizeExpired])
            {
                [self.wbEngine logInWithDelegate:self
                                onSuccess:@selector(onSuccessLogin)
                                onFailure:@selector(onFailureLogin:)];
            }else
            {
                if(self.imageData)
                {
                    //发表带图微博
                    
                    [wbEngine postPictureTweetWithFormat:@"json"
                                                 content:_shareContent.text
                                                clientIP:@"10.10.1.38"
                                                     pic:self.imageData
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
                    [wbEngine postTextTweetWithFormat:@"json"
                                              content:_shareContent.text
                                             clientIP:@"10.10.1.31"
                                            longitude:nil
                                          andLatitude:nil
                                          parReserved:nil
                                             delegate:self
                                            onSuccess:@selector(successCallBack:)
                                            onFailure:@selector(failureCallBack:)];
                }
            }
        }
        else
        {
            [self.wbEngine logInWithDelegate:self
                                 onSuccess:@selector(onSuccessLogin)
                                 onFailure:@selector(onFailureLogin:)];
        }
        
        
        
        
        
         
    }
    //微信
    if(shareType==3)
    {
        if(self.imageData)
        {
            WXMediaMessage *message = [WXMediaMessage message];
            NSData *data=UIImageJPEGRepresentation([UIImage imageWithData:self.imageData], 0.1);
           // message.title=
            UIImage *imageTemp=[UIImage imageWithData:data];
            
            
            CGFloat width=imageTemp.size.width;
            CGFloat height=imageTemp.size.height;
            
            float scale=(float)(width/height);
            
            CGFloat scaleH=100/scale;
            
            UIImage *image=[self imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(100, scaleH)];
            
            NSData *dataScale=UIImageJPEGRepresentation(image, 1);
            //NSLog(@"%d  K",[dataScale length]/1024);
            
            UIImage *imageThum=[UIImage imageWithData:dataScale];
            [message setThumbImage:imageThum];
            
            WXImageObject *ext = [WXImageObject object];
            
            ext.imageData=self.imageData;
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
            req.bText = NO;
            req.message = message;
            if (shareType == 4) {
                req.scene = WXSceneTimeline;
            }
            [WXApi sendReq:req];

        }
        else
        {
//            SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
//            req.bText = YES;
//            req.text=_shareContent.text;
//            [WXApi sendReq:req];
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = _shareContent.text;
            message.description = @"";
            //        [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.content;
            
            message.mediaObject = ext;
            
            GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
            resp.message = message;
            resp.bText = NO;
            
            [WXApi sendResp:resp];
            
        } 
    }
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

-(IBAction)clickCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    [_shareContent release];
    [_shareImageView release];

    self.pic = nil;
    self.content = nil;
    self.imageData=nil;
    self.wbEngine=nil;

    [_textBackGround release];

    [super dealloc];
}
- (void)viewDidUnload {
    [self setShareContent:nil];
    [self setShareImageView:nil];
    [self setTextBackGround:nil];
    
    [super viewDidUnload];
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return NO;
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationPortrait;
//}

@end
