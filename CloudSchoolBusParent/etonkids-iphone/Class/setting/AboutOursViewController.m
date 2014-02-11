//
//  AboutOursViewController.m
//  etonkids-iphone
//
//  Created by Simon on 13-7-30.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "AboutOursViewController.h"
#import "ETAboutView.h"
#import "ETKids.h"
#import "ETPrivateViewController.h"
@interface AboutOursViewController ()

@end

@implementation AboutOursViewController
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
       // Do any additional setup after loading the view from its nib.
    
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
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2+ (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UILabel *middleLabel=[[UILabel alloc]initWithFrame:CGRectMake(160-50, 13+ (ios7 ? 20 : 0), 100, 20)];
    middleLabel.textAlignment=UITextAlignmentCenter;
    middleLabel.textColor=[UIColor whiteColor];
    middleLabel.text = LOCAL(@"About Us", @"");
    middleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:middleLabel];
    [middleLabel release];
    
    
    
    aboutBack.center = CGPointMake(aboutBack.center.x, aboutBack.center.y + (iphone5?30:0));
    copyrightLab.center = CGPointMake(copyrightLab.center.x, copyrightLab.center.y + (iphone5?30:0));
    engLab.center = CGPointMake(engLab.center.x, engLab.center.y + (iphone5?30:0));
    aboutLogo.center = CGPointMake(aboutLogo.center.x, aboutLogo.center.y + (iphone5?30:0));
    teleButton.center = CGPointMake(teleButton.center.x, teleButton.center.y + (iphone5?30:0));
    privateBtn.center = CGPointMake(privateBtn.center.x, privateBtn.center.y + (iphone5?30:0));
    webBtn.center = CGPointMake(webBtn.center.x, webBtn.center.y + (iphone5?30:0));
    emailBtn.center = CGPointMake(emailBtn.center.x, emailBtn.center.y + (iphone5?30:0));
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    int width;
    if ([currentLanguage isEqualToString:@"en"])
    {
        width = 72;
    }
    else
    {
        width = 53;
    }
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(212 - 9 - width + aboutLogo.frame.origin.x, 34 + aboutLogo.frame.origin.y, width, 13)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.font = [UIFont boldSystemFontOfSize:8];
    versionLabel.textAlignment = UITextAlignmentCenter;
    versionLabel.text = LOCAL(@"aboutversion", @"");
    [self.view addSubview:versionLabel];
    [versionLabel release];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    aboutLogo.image = [UIImage imageNamed:LOCAL(@"aboutlogo", @"")];
    
    [privateBtn setTitle:LOCAL(@"private", @"") forState:UIControlStateNormal];
    [privateBtn setTitle:LOCAL(@"private", @"") forState:UIControlStateHighlighted];
}

- (IBAction)doCall:(UIButton *)sender {
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:[sender titleForState:UIControlStateNormal] delegate:self cancelButtonTitle:LOCAL(@"cancel", @"") otherButtonTitles:LOCAL(@"call", @""), nil];
    [alert show];
    
}

- (IBAction)doClickURL:(id)sender {
    //    NSLog(@"url");
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://www.yunxiaoche.com"]];
}

- (IBAction)doClickGuoKr:(UIButton *)sender {
    //    NSLog(@"guokr url");
//    UIApplication *app = [UIApplication sharedApplication];
//    [app openURL:[NSURL URLWithString:@"http://www.guokrspace.com"]];
    
    
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail]) {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
//            [mc setSubject:[sender titleForState:UIControlStateNormal]];
            [mc setToRecipients:[NSArray arrayWithObjects:[sender titleForState:UIControlStateNormal], nil]];
//            [mc setMessageBody:self.content isHTML:NO];
            
//            NSData *data = UIImagePNGRepresentation(image);
//            [mc addAttachmentData:data mimeType:@"image/png" fileName:@"SharePicture.png"];
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

- (void)launchMailAppOnDevice
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosetmail",  @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
    
}

- (IBAction)doClickPrivate:(id)sender {
    //    cloud.yunxiaoche.com/html/privacy.html
    
    ETPrivateViewController *passViewController=[[ETPrivateViewController alloc]init];
//    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [self.navigationController pushViewController:passViewController animated:YES];
    [passViewController release];
}


- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 1) {
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"4006063996"];
        UIApplication *app = [UIApplication sharedApplication];
        [app openURL:[NSURL URLWithString:num]];
    }
}

- (void)leftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
  
    [aboutBack release];
    [copyrightLab release];
    [engLab release];
    [webBtn release];
    [emailBtn release];
  [super dealloc];
}
- (void)viewDidUnload {
    [aboutBack release];
    aboutBack = nil;
    [copyrightLab release];
    copyrightLab = nil;
    [engLab release];
    engLab = nil;
    [webBtn release];
    webBtn = nil;
    [emailBtn release];
    emailBtn = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}



@end
