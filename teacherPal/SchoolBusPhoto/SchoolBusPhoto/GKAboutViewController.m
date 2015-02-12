//
//  GKAboutViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-25.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKAboutViewController.h"
#import "GKWebViewController.h"
#import "KKNavigationController.h"
@interface GKAboutViewController ()

@end

@implementation GKAboutViewController

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
    //self.view.backgroundColor=[UIColor colorWithRed:103/255.0 green:183/255.0 blue:204/255.0 alpha:1];
   // self.view.backgroundColor=[UIColor clearColor];
    
//    UIView *BGView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
//    BGView.backgroundColor=[UIColor colorWithRed:237/255.0 green:234/255.0 blue:225/255.0 alpha:1];
//    [self.view addSubview:BGView];
//    [BGView release];
    
    
    
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame=CGRectMake(10, 5, 34, 35);
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    [navigationView addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *_versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(196-50, 5, 40, 20)];
    _versionLabel.textColor=[UIColor whiteColor];
    _versionLabel.font=[UIFont systemFontOfSize:12];
    _versionLabel.backgroundColor=[UIColor clearColor];
    _versionLabel.textAlignment=NSTextAlignmentCenter;

    _versionLabel.text=[NSString stringWithFormat:@"V%@",CURRENTVERSION];
    [_iconImageView addSubview:_versionLabel];
    [_versionLabel release];
    
    
    _BGView.frame=CGRectMake(0, (iOS7?(20+46):46), 320, self.view.frame.size.height-(iOS7?(20+46):46));
    [_privaty setTitle:NSLocalizedString(@"privacyC", @"") forState:UIControlStateNormal];
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];
//    
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"backH" ofType:@"png"];
//    [buttom setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
//    [buttom setBackgroundImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateHighlighted];
//    buttom.tag=0;
//    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navigationView addSubview:buttom];
    titlelabel.text=NSLocalizedString(@"aboutus", @"");
    
//    NSString *logostr= [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"aboutLogo", @"") ofType:@"png"];
//    [_aboutLogo setImage:[UIImage imageWithContentsOfFile:logostr]];
    
//    
//    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320,self.view.frame.size.height)];
//    bgView.backgroundColor=[UIColor colorWithRed:238/255.0 green:235/255.0 blue:226/255.0 alpha:1];
//    
//    [self.view addSubview:bgView];
//    [bgView release];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
-(void)secretClick:(UIButton *)btn
{
    
}


-(void)back:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoClick:(id)sender {
   
    //NSLog(@"%@",[UIDevice currentDevice].model);
    // 如果ipod touch 不支持打电话
    if([[UIDevice currentDevice].model isEqualToString:@"iPod touch"] || [[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"]  ||[[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        UIAlertView *alertsupport=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"nosupport", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alertsupport show];
        [alertsupport release];
        return;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"call", @"") message:@"400-606-3996" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006063996"]];
}
- (IBAction)webClick:(id)sender {
    
   // GKWebViewController *webVC=[[GKWebViewController alloc]init];
    
   // webVC.urlstr=@"http://www.yunxiaoche.com";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.yunxiaoche.com"]];
    
//    if(IOSVERSION>=6.0)
//    {
//        [self.navigationController presentViewController:webVC animated:NO completion:^{
//            
//            
//        }];
//    }
//    else
//    {
//        [self presentModalViewController:webVC animated:NO];
//    }
//    
//    CATransition *animation = [CATransition animation];
//    //动画时间
//    animation.duration = 0.3f;
//    //先慢后快
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    
//    [webVC.view.layer addAnimation:animation forKey:@"animation"];

}

- (IBAction)screctClick:(id)sender {
    GKWebViewController *webVC=[[GKWebViewController alloc]init];
    
    webVC.urlstr=@"http://cloud.yunxiaoche.com/html/privacy.html";
    
    webVC.titlestr=NSLocalizedString(@"privacy", @"");
    [self.navigationController pushViewController:webVC animated:YES];
    

    [webVC release];
    
//    CATransition *animation = [CATransition animation];
//    //动画时间
//    animation.duration = 0.3f;
//    //先慢后快
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    
//    [webVC.view.layer addAnimation:animation forKey:@"animation"];

}

- (IBAction)emailClick:(id)sender {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            //[self launchMailAppOnDevice];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"emailno", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }
    }
    else
    {
        //[self launchMailAppOnDevice];
    }
    
    
    
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"反馈"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"service@yunxiaoche.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];

    
    NSString *emailBody = @"";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    //[self presentModalViewController: mailPicker animated:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
    
    [mailPicker release];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
//    "msgcancel" = "Cancel";
//    "msgsavesucess" = "Save successfully";
//    "msgsucess" = "succeed"
//    "msgfail" = "Send failed";
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = NSLocalizedString(@"msgcancel", @"");
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSaved:
            msg =NSLocalizedString(@"msgsavesucess", @"");
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg =NSLocalizedString(@"msgsucess", @"");
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = NSLocalizedString(@"msgfail", @"");
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
   // [self dismissModalViewControllerAnimated:YES];
}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc {
    [_privaty release];
   // [_aboutLogo release];
    [_BGView release];
    [_iconImageView release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPrivaty:nil];
    //[self setAboutLogo:nil];
    [self setBGView:nil];
    [self setIconImageView:nil];
 
    [super viewDidUnload];
}
@end
