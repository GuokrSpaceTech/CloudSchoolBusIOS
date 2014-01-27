//
//  GKFilterViewController.m
//  Camera
//
//  Created by CaiJingPeng on 13-12-16.
//  Copyright (c) 2013年 caijingpeng. All rights reserved.
//

#import "GKFilterViewController.h"
#import "GKSendMediaViewController.h"
#import "GKCoreDataManager.h"
#import "GKUserLogin.h"
#import "DBManager.h"
#import "GKAppDelegate.h"
#import "MovieDraft.h"

#define FILTER_BUTTON_TAG 999
#define SELECT_OVERLAY_TAG 888

@interface GKFilterViewController ()

@end

@implementation GKFilterViewController
@synthesize isEnableFilter,sourceImage,moviePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.isEnableFilter = NO;
        self.isPreview = YES;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (player != nil) {
        if (player.playbackState == MPMoviePlaybackStatePlaying) {
            [player stop];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    if(!ios7)
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    primaryView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
//    [self.view addSubview:primaryView];
    
     //------- image --------
     
     //    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"]; // The WID.jpg example is greater than 2048 pixels tall, so it fails on older devices
    if (self.sourceImage != nil) // 图片
    {
        /*
        sourcePicture = [[GPUImagePicture alloc] initWithImage:self.sourceImage smoothlyScaleOutput:YES];
        filter = [[GPUImageFilter alloc] init];
//        [(GPUImageSepiaFilter *)filter setIntensity:0.5f];
        
        
        [filter forceProcessingAtSizeRespectingAspectRatio:primaryView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
        [filter addTarget:primaryView];
        [sourcePicture addTarget:filter];
        [sourcePicture processImage];
         */
        
        primaryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
        primaryView.image = self.sourceImage;
        [self.view addSubview:primaryView];
        [primaryView release];
        
        
        
    }
    else    //视频
    {
        NSURL *sampleURL = [NSURL fileURLWithPath:self.moviePath];
////        NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"sample_iPod" withExtension:@"m4v"];
//        movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
//        movieFile.runBenchmark = YES;
//        movieFile.playAtActualSpeed = NO;
        
        player = [[MPMoviePlayerController alloc] initWithContentURL:sampleURL];
        player.controlStyle = MPMovieControlStyleNone;
        player.movieSourceType = MPMovieSourceTypeFile;
//        [player prepareToPlay];
        
        [player.view setFrame:CGRectMake(0, 100, 320, 320)];
        [player requestThumbnailImagesAtTimes:[NSArray arrayWithObject:[NSNumber numberWithDouble:1.0]] timeOption:MPMovieTimeOptionExact];
        [self.view addSubview:player.view];
        
//        [player play];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieViewFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFinishedThumbnailImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        
        
        
        controlImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        controlImgV.image = [UIImage imageNamed:@"movieplay.png"];
        controlImgV.center = player.view.center;
        controlImgV.hidden = YES;
        controlImgV.userInteractionEnabled = YES;
        [controlImgV addGestureRecognizer:tap];
        [self.view addSubview:controlImgV];
        [controlImgV release];
        
        [tap release];
        
    }

    
    
    /*
    
    if (self.sourceImage != nil) // 图片
    {
        
    }
    else
    {
        [movieFile addTarget:filter];
        
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 640.0)];
        [filter addTarget:movieWriter];
        
        movieWriter.shouldPassthroughAudio = YES;
        movieFile.audioEncodingTarget = movieWriter;
        [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
        
        [movieWriter startRecording];
        [movieFile startProcessing];
        
        [movieWriter setCompletionBlock:^{
            [filter removeTarget:movieWriter];
            [movieWriter finishRecording];
        }];
        
    }
    */
    
    if (self.isPreview) {
        
        // 预览页面
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        view.backgroundColor = [UIColor grayColor];
        [self.view addSubview:view];
        [view release];
        
        UIImageView *tBack = [[UIImageView alloc] initWithFrame:view.bounds];
        tBack.image = [UIImage imageNamed:@"edit-tray-background.png"];
        [view addSubview:tBack];
        [tBack release];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"  重拍" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [backBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back-black-alt"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back-black-alt-active"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted];
        [backBtn setFrame:CGRectMake(0, 0, 45, 30)];
        [backBtn setCenter:CGPointMake(30, 40)];
        [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
        [nextBtn setFrame:CGRectMake(0, 0, 60, 30)];
        [nextBtn setCenter:CGPointMake(280, 40)];
        [nextBtn addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextBtn];
    }
    else
    {
        // 显示大图
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];
        [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [backBtn setCenter:CGPointMake(45, 50)];
        [backBtn addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)];
        if (self.sourceImage != nil)
        {
            primaryView.userInteractionEnabled = YES;
            [primaryView addGestureRecognizer:tap];
        }
        [self.view addGestureRecognizer:tap];
        [tap release];
        
    }
    
    //保存草稿按钮.
    
    if (self.sourceImage == nil && self.isPreview) {
        // 判断 是 播放视频、预览页面
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setImage:[UIImage imageNamed:@"save_default.png"] forState:UIControlStateNormal];
        [saveBtn setImage:[UIImage imageNamed:@"save_active.png"] forState:UIControlStateHighlighted];
        [saveBtn addTarget:self action:@selector(saveDraft:) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.frame = CGRectMake(0, 0, 80, 80);
        saveBtn.center = CGPointMake(220, ((iphone5 ? 548 : 460) - 420)/2 + 420 + 8);
        [self.view addSubview:saveBtn];
    }
    
    
    /*
    if (self.sourceImage != nil && self.isEnableFilter) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 95, 320, 95)];
        [self.view addSubview:bottomView];
        
        UIImageView *bBack = [[UIImageView alloc] initWithFrame:bottomView.bounds];
        bBack.image = [UIImage imageNamed:@"edit-tray-background.png"];
        [bottomView addSubview:bBack];
        
        NSArray *filterImages = [NSArray arrayWithObjects:
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 @"edit-filters-normal.png",
                                 nil];
        
        NSArray *filterNames = [NSArray arrayWithObjects:@"Normal",@"Sobel",@"Invert",@"Gray",@"Sepia",@"Sketch",@"Toon",@"Emboss", nil];
        
        filterSV = [[UIScrollView alloc] initWithFrame:bottomView.bounds];
        filterSV.contentSize = CGSizeMake(MAX(320, filterNames.count * (60 + 10) + 10), bottomView.bounds.size.height);
        filterSV.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:filterSV];
        
        
        for (int i = 0 ; i < filterNames.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];
            btn.frame = CGRectMake(0, 0, 60, 60);
            [btn setBackgroundImage:[UIImage imageNamed:[filterImages objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[filterImages objectAtIndex:i]] forState:UIControlStateHighlighted];
//            [btn setImage:[UIImage imageNamed:@"edit-filters-overlay-default-short.png"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"edit-filters-overlay-selected-short.png"] forState:UIControlStateHighlighted];
//            [btn setImage:[UIImage imageNamed:@"edit-filters-overlay-selected-short.png"] forState:UIControlStateSelected];
//            btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//            [btn setTitle:[filterNames objectAtIndex:i] forState:UIControlStateNormal];
//            btn.titleLabel.textColor = [UIColor whiteColor];
            btn.tag = FILTER_BUTTON_TAG + i;
            btn.center = CGPointMake((i+1) * 70 - 25, filterSV.frame.size.height/2);
            [btn addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventTouchUpInside];
            [filterSV addSubview:btn];
            
            UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
            selectImgV.center = btn.center;
            selectImgV.tag = SELECT_OVERLAY_TAG + i;
            if (i == 0)
            {
                selectImgV.image = [UIImage imageNamed:@"edit-filters-overlay-selected-short.png"];
            }
            else
            {
                selectImgV.image = [UIImage imageNamed:@"edit-filters-overlay-default-short.png"];
            }
            
            [filterSV addSubview:selectImgV];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            title.font = [UIFont boldSystemFontOfSize:12];
            title.center = btn.center;
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor whiteColor];
            title.text = [filterNames objectAtIndex:i];
            [filterSV addSubview:title];
        }
        
        
    }
     
    
     */
     
}

/*
- (void)changeFilter:(UIButton *)sender
{
    
    for (int i = 0; i < 8; i++) {
        UIButton *b = (UIButton *)[filterSV viewWithTag:FILTER_BUTTON_TAG + i];
        b.selected = NO;
        b.userInteractionEnabled = YES;
        
        UIImageView *img = (UIImageView *)[filterSV viewWithTag:SELECT_OVERLAY_TAG + i];
        img.image = [UIImage imageNamed:@"edit-filters-overlay-default-short.png"];
    }
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    UIImageView *img = (UIImageView *)[filterSV viewWithTag:SELECT_OVERLAY_TAG + sender.tag%FILTER_BUTTON_TAG];
    img.image = [UIImage imageNamed:@"edit-filters-overlay-selected-short.png"];
    
    [movieFile removeTarget:filter];
    switch (sender.tag % FILTER_BUTTON_TAG)
    {
        case 0:
        {
            filter = [[GPUImageFilter alloc] init];
            break;
        }
        case 1:
        {
            filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
            break;
        }
        case 2:
        {
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        }
        case 3:
        {
            filter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        }
        case 4:
        {
            filter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageSepiaFilter *)filter setIntensity:1.0f];
            break;
        }
        case 5:
        {
            filter = [[GPUImageSketchFilter alloc] init];
            [(GPUImageSketchFilter *)filter setEdgeStrength:0.5f];
            break;
        }
        case 6:
        {
            filter = [[GPUImageSmoothToonFilter alloc] init];
            [(GPUImageSmoothToonFilter *)filter setBlurRadiusInPixels:0];
            break;
        }
        case 7:
        {
            filter = [[GPUImageEmbossFilter alloc] init];
            [(GPUImageEmbossFilter *)filter setIntensity:0.3f];
            break;
        }
        default:
            break;
    }
    
    
    [filter forceProcessingAtSizeRespectingAspectRatio:primaryView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    
    if (self.sourceImage != nil)
    {
        [sourcePicture addTarget:filter];
        [filter addTarget:primaryView];
        [sourcePicture processImage];
        
    }
    
    
}
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *stamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        
        GKUserLogin *user=[GKUserLogin currentLogin];
//        BOOL success = [GKCoreDataManager addMovieDraftWithUserid:[NSString stringWithFormat:@"%@", user.classInfo.classid] moviePath:self.moviePath dateStamp:stamp thumbnail:UIImageJPEGRepresentation(self.movieThumbnail, 0.1)];
        
//        GKAppDelegate* delegate = SHARED_APP_DELEGATE;
        
        [[DBManager shareInstance] insertObject:^(NSManagedObject *object) {
            
            MovieDraft *movie = (MovieDraft *)object;
            movie.createdate = stamp;
            movie.moviepath = self.moviePath;
            movie.userid = [NSString stringWithFormat:@"%@", user.classInfo.classid];
            movie.thumbnail = UIImageJPEGRepresentation(self.movieThumbnail, 0.1);
            
            
            
        } entityName:@"MovieDraft" success:^{
            
        } failed:^(NSError *err) {
            
        }];
        
        
        
//        NSLog(@"save draft : %d",success);
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)saveDraft:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", @"") message:@"是否保存到草稿箱 ？" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil] autorelease];
    [alert show];
    
}

- (void)doTap:(UIGestureRecognizer *)gesture
{
    
    switch (player.playbackState) {
        case MPMoviePlaybackStateStopped:
        {
            [player play];
            controlImgV.hidden = YES;
            break;
        }
        case MPMoviePlaybackStatePlaying:
        {
            [player pause];
            controlImgV.hidden = NO;
            break;
        }
        case MPMoviePlaybackStatePaused:
        {
            [player play];
            controlImgV.hidden = YES;
            break;
        }
            
        default:
            break;
    }
    
}




- (void)pushNext:(id)sender
{
    GKSendMediaViewController *sendMediaVC = [[GKSendMediaViewController alloc] init];
    if (self.sourceImage != nil)
    {
        sendMediaVC.sourcePicture = self.sourceImage;
    }
    else
    {
        sendMediaVC.moviePath = self.moviePath;
        sendMediaVC.thumbnail = self.movieThumbnail;
    }
    [self.navigationController pushViewController:sendMediaVC animated:YES];
    [sendMediaVC release];
}

- (void)requestFinishedThumbnailImage:(NSNotification *)notification
{
//    NSLog(@" MPMoviePlayerThumbnailImageRequestDidFinishNotification : %@",notification);
    
    UIImage *image =[notification.userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
    self.movieThumbnail = image;
    
    
}

- (void)myMovieViewFinishedCallback:(NSNotification *)notification
{
    NSLog(@"play finished");
    
    controlImgV.hidden = NO;
}

- (void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    self.sourceImage = nil;
    self.moviePath = nil;
    self.movieThumbnail = nil;
    
    [super dealloc];
    
}


@end
