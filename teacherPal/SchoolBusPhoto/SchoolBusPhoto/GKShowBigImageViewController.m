//
//  GKShowBigImageViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-30.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKShowBigImageViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface GKShowBigImageViewController ()

@end

@implementation GKShowBigImageViewController
@synthesize path;
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
    [super dealloc];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
         UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, NULL);
        
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"savesuccess", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)rightClick:(UIButton *)btn
{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"savepic", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"savephoto", @""), nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttom setBackgroundImage:[UIImage imageNamed:@"backH.png"] forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];
    
    
    
    UIButton *right=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    right.frame=CGRectMake(265, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [right setBackgroundImage:[UIImage imageNamed:@"shareBtn3.0.png"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"shareBtnSel3.0.png"] forState:UIControlStateHighlighted];
    
    [right addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:right];

    

    
    scroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, 320, self.view.frame.size.height - navigationView.frame.size.height-navigationView.frame.origin.y)];
    scroller.backgroundColor=[UIColor blackColor];
    scroller.delegate=self;
    scroller.maximumZoomScale=5;
    scroller.minimumZoomScale=1;
    
    [self.view addSubview:scroller];
    [scroller release];
    
 
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height)];
    imageView.backgroundColor=[UIColor clearColor];
    [scroller addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    tap.numberOfTapsRequired=1;
//    [imageView addGestureRecognizer:tap];
//    [tap release];
    
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
    
    [imageView release];
    
	// Do any additional setup after loading the view.
}
//-(void)tapClick:(UITapGestureRecognizer *)tap
//{
//    scroller.zoomScale=1;
//}
-(void)leftClick:(UIButton *)btn
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
