//
//  GKShowBigImageViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-30.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKShowReceiveBigImageViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ETKids.h"
@interface GKShowReceiveBigImageViewController ()

@end

@implementation GKShowReceiveBigImageViewController
@synthesize path;
@synthesize Image;

@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.path=nil;
    self.Image=nil;
    [super dealloc];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        // UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, NULL);
            
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {


    if (!error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"savesuccess", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {

        // message = [error description];
        
        // message=@"没有相册访问权限，请在\"设置\"--\"隐私\"--\"照片\"--\"云中校车\"中设置";
       // message=NSLocalizedString(@"privacy", @"");
        if(error.code==-3310)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"privacyPhoto", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"savefailed", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }

    }

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {

    }
    else
    {
        NSLog(@"delete");
        
        if(delegate&&[delegate respondsToSelector:@selector(deletePhoto)])
        {
            [delegate deletePhoto];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
}
-(void)rightClick:(UIButton *)btn
{

        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"savepic", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"savephoto", @""), nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    
   
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0) + NAVIHEIGHT, 320, self.view.frame.size.height - NAVIHEIGHT - (ios7 ? 20 : 0))];
    backView.backgroundColor = CELLCOLOR;
    [self.view insertSubview:backView atIndex:0];
    [backView release];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    navigationBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 + (ios7 ? 20 : 0), 320, NAVIHEIGHT)];
    navigationBackView.image=[UIImage imageNamed:@"navigationNoText.png"];
    [self.view addSubview:navigationBackView];
    [navigationBackView release];
    
    
    UIButton * leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 35)];
    [leftButton setCenter:CGPointMake(10 + 34/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [leftButton setImage:[UIImage imageNamed:@"backBtnDefault_3.0.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backBtnSel_3.0.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];


   
    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setCenter:CGPointMake(320 - 10 - 50/2, navigationBackView.frame.size.height/2 + (ios7 ? 20 : 0))];
    [rightButton setImage:[UIImage imageNamed:@"shareBtn3.0.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"shareBtnSel3.0.png"] forState:UIControlStateHighlighted];
    [self.view addSubview :rightButton];

    

    
    scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationBackView.frame.size.height+navigationBackView.frame.origin.y, 320, self.view.frame.size.height - navigationBackView.frame.size.height-navigationBackView.frame.origin.y)];
    scroller.backgroundColor=[UIColor blackColor];
    scroller.delegate=self;
    scroller.maximumZoomScale=5;
    scroller.minimumZoomScale=1;
    
    [self.view addSubview:scroller];
    [scroller release];
    
 
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height)];
    imageView.backgroundColor=[UIColor clearColor];
    [scroller addSubview:imageView];
    [imageView release];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    

        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:scroller];
        hud.center = CGPointMake(scroller.frame.size.width/2, scroller.frame.size.height/2.0f);
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        //hud.tag = HUDTAG + i;
        [scroller addSubview:hud];
        [hud release];
        [hud show:YES];
        
        
        [imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
            imageView.userInteractionEnabled=YES;
            
            hud.progress = receivedSize/(float)expectedSize;
            
            // hud.progress=receivedSize/expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            
            [hud removeFromSuperview];
            
        }];

    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    tap.numberOfTapsRequired=1;
//    [imageView addGestureRecognizer:tap];
//    [tap release];
    
    
    
    
	// Do any additional setup after loading the view.
}
//-(void)tapClick:(UITapGestureRecognizer *)tap
//{
//    scroller.zoomScale=1;
//}
-(void)leftButtonClick:(UIButton *)btn
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
