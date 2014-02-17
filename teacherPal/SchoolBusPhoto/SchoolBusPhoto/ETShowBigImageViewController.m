
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
@synthesize targetImage;
@synthesize page;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didSelectedTencentShareImage:(UIImage *) image
{}


/**
 *	@brief  点击分享回调方法.
 *
 *	@param 	image 	分享的图片.
 *	@param 	shareType 	分享的类型.
 *	@param 	shareCOn 	分享的内容.
 */
- (void)didSelectedShareImage:(UIImage *)image shareType:(int)shareType content:(NSString *)shareCOn
{}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = CELLCOLOR;
    
    CGRect frame= [[UIScreen mainScreen]applicationFrame];
    
    bigImgV = [[ETShowBigImageView alloc] initWithFrame:CGRectMake(0, (ios7 ? 20 : 0), frame.size.width, frame.size.height - (ios7 ? 20 : 0)) image:self.targetImage];
    
    //bigImgV.smallImgArr = self.shareContent.sharePicArr;
    bigImgV.delegate = self;
    bigImgV.alpha = 0.0f;
    [self.view addSubview:bigImgV];
    [bigImgV release];
    
    [UIView animateWithDuration:0.5f animations:^{
        bigImgV.alpha = 1.0f;
    }];
    
    
}

-(void)dealloc
{
    self.targetImage=nil;
    [super dealloc];
}


- (void)didClickBackButton
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (NSUInteger)supportedInterfaceOrientations
{
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        bigImgV.frame = CGRectMake(0, (ios7 ? 20 : 0), (iphone5 ? 568 : 480), 300);
    }
    else
    {
        CGRect frame=[[UIScreen mainScreen]applicationFrame];
        NSLog(@"%f,%f",frame.size.width,frame.size.height);
        bigImgV.frame = CGRectMake(0, (ios7 ? 20 : 0), frame.size.width, frame.size.height - (ios7 ? 20 : 0));
    }
    [bigImgV reloadFrame:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
    return UIInterfaceOrientationMaskAll;
}




@end
