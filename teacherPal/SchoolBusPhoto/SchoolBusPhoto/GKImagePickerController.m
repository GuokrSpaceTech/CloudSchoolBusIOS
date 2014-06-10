//
//  GKImagePickerController.m
//  Camera
//
//  Created by caijingpeng on 13-12-11.
//  Copyright (c) 2013年 caijingpeng. All rights reserved.
//

#import "GKImagePickerController.h"
#import "GKFilterViewController.h"
//#define ios7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
//#define iphone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size):NO)

#define RECORD_PROGRESS_TAG 123

#define CENTERLAYOUT (self.view.frame.size.height - 60 - 90)/2 + 40


@interface GKImagePickerController ()

@end

@implementation GKImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyStopRecord:) name:@"stopRecord" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exportError:) name:@"MOVIEDATA_EXPORT_ERROR" object:nil];
        
    }
    return self;
}
- (void)exportError:(NSNotification *)notification
{
    // 提示 导出错误.
    [self initialRecordModel];
    [self openCameraAnimate];
}
- (void)enterBackground:(NSNotification *)notification
{
    [self closeCameraAnimateCompletion:YES];
}
- (void)becomeActive:(NSNotification *)notification
{
    [self performSelector:@selector(openCameraAnimate) withObject:nil afterDelay:1.0f];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    
	// Do any additional setup after loading the view.
    if (ios7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    camManager = [GKCameraManager manager];
    camManager.delegate = self;
    [camManager setup];
//    [camManager startRuning];
    
    UIView *cameraPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + (iphone5 ? 20 : 0), 320, 320)];
    cameraPreview.backgroundColor = [UIColor blackColor];
    [camManager embedPreviewInView:cameraPreview];
    [self.view addSubview:cameraPreview];
    [cameraPreview release];
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusPoint:)];
    [cameraPreview addGestureRecognizer:focusTap];
    [focusTap release];
    
    upOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, CENTERLAYOUT - 280 + 40, 320, 280)];
    upOverlay.image = [[UIImage imageNamed:@"camera-blind-top-simple"] stretchableImageWithLeftCapWidth:0 topCapHeight:1];
    [self.view addSubview:upOverlay];
    [upOverlay release];
    
    downOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, CENTERLAYOUT, 320, 250)];
    downOverlay.image = [[UIImage imageNamed:@"camera-blind-bottom-simple"] stretchableImageWithLeftCapWidth:0 topCapHeight:43];
    [self.view addSubview:downOverlay];
    [downOverlay release];
    
    
    // ----------- 顶部导航条 ----------------
    topToolsbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    topToolsbar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topToolsbar];
    [topToolsbar release];
    
    UIImageView *tBack = [[UIImageView alloc] initWithFrame:topToolsbar.bounds];
    tBack.image = [UIImage imageNamed:@"edit-tray-background.png"];
    [topToolsbar addSubview:tBack];
    [tBack release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back-black-alt"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back-black-alt-active"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted];
    [backBtn setFrame:CGRectMake(0, 0, 45, 30)];
    [backBtn setCenter:CGPointMake(30, topToolsbar.frame.size.height/2.0f)];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [topToolsbar addSubview:backBtn];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 43, 43)];
        
        if (i == 0) {
            positionBtn = button;
//            [button setTitle:@"change" forState:UIControlStateNormal];
            button.hidden = YES; // 取消切换摄像头.
            [button setImage:[UIImage imageNamed:@"camera-glyph-cameratoggle.png"] forState:UIControlStateNormal];
            button.showsTouchWhenHighlighted = YES;
            button.center = CGPointMake(190, topToolsbar.frame.size.height/2.0f);
            [button addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 1)
        {
            flashBtn = button;
            [button setImage:[UIImage imageNamed:@"camera-glyph-flash-off.png"] forState:UIControlStateNormal];
            button.showsTouchWhenHighlighted = YES;
            button.center = CGPointMake(270, topToolsbar.frame.size.height/2.0f);
            [button addTarget:self action:@selector(toggleFlashMode:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 2)
        {
            nextBtn = button;
            
            [button setFrame:CGRectMake(0, 0, 60, 30)];
            [button setTitle:NSLocalizedString(@"next", @"下一步") forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [button setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-disabled"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
            button.center = CGPointMake(280, topToolsbar.frame.size.height/2.0f);
            [button addTarget:self action:@selector(recordNext:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [topToolsbar addSubview:button];
    }
    
    
    // ---------------- 底部工具条 -------------------
    
    int height = iphone5 ? 145 : 105;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + (ios7 ? 0 : 20) - height, 320, height)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    [bottomView release];
    
    UIImageView *bBack = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    bBack.image = [UIImage imageNamed:@"camera-tray-cover.png"];
    [bottomView addSubview:bBack];
    [bBack release];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (i == 1) {
            photoBtn = button;
//            [button setTitle:@"拍照" forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, 80, 80)];
            [button setImage:[UIImage imageNamed:@"camera-handle-photo.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"camera-handle-photo.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 0)
        {
            // 删除按钮
            albumBtn = button;
            albumBtn.hidden = YES;
//            [button setTitle:@"相册" forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, 88, 88)];
            [button setImage:[UIImage imageNamed:@"camera-backspace-default-default@2x.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"camera-backspace-default-default@2x.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 2)
        {
            recordBtn = button;
//            [button setTitle:@"录像" forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, 80, 80)];
            
            [button setImage:[UIImage imageNamed:@"camera-shutter-video-default.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"camera-shutter-video-default-active.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(takeRecord:) forControlEvents:UIControlEventTouchUpInside];
        }
        [button setCenter:CGPointMake(60 + 100 * i, bottomView.frame.size.height/2)];
        [bottomView addSubview:button];
    }
    
    [self changeRecordUI];
    
    [self disableButton];
    
    // orientation
    
    motionManager = [[CMMotionManager alloc] init];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        double ax = accelerometerData.acceleration.x;
        AVCaptureVideoOrientation orientation;
        
        if (ax < -0.7)
        {
            orientation = AVCaptureVideoOrientationLandscapeRight;
//            NSLog(@"right");
            
            if (currentModel == photoModel && !CGAffineTransformEqualToTransform(photoBtn.transform, CGAffineTransformMakeRotation(M_PI_2))) {
                
                [UIView animateWithDuration:0.2f animations:^{
                    photoBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
                    recordBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
                    flashBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
                }];
                
                
                
            }
            
        }
        else if (ax > 0.7)
        {
//            NSLog(@"left");
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            if (currentModel == photoModel && !CGAffineTransformEqualToTransform(photoBtn.transform, CGAffineTransformMakeRotation(-M_PI_2))) {
                [UIView animateWithDuration:0.2f animations:^{
                    photoBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    recordBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    flashBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
                }];
            }
        }
        else
        {
            
            orientation = AVCaptureVideoOrientationPortrait;
            if (currentModel == photoModel && !CGAffineTransformEqualToTransform(photoBtn.transform, CGAffineTransformIdentity)) {
                [UIView animateWithDuration:0.2f animations:^{
                    photoBtn.transform = CGAffineTransformIdentity;
                    recordBtn.transform = CGAffineTransformIdentity;
                    flashBtn.transform = CGAffineTransformIdentity;
                }];
            }
        }
        
        [camManager setCameraOrientation:orientation];
        
    }];
    
    
    [self performSelector:@selector(openCameraAnimate) withObject:nil afterDelay:1.0f];
//    [self openCameraAnimate];
    
    if (currentModel == recordModel) {
        [self initialRecordModel];
    }
    
}

- (void)doBack:(id)sender
{
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self closeCameraAnimateCompletion:YES];
}

// 重置 录像模式.
- (void)initialRecordModel
{
    [camManager clearMovieCache];
    [self removeRecordProgressBar];
    [self createRecordProgressBar];
    [self resetDeleteButton];
    albumBtn.hidden = YES;
    isStartRecording = YES;
    
    photoBtn.userInteractionEnabled = YES;
    photoBtn.alpha = 1.0f;
    
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-disabled"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    nextBtn.userInteractionEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [motionManager stopAccelerometerUpdates];
    [camManager clearMovieCache];
    [self closeCameraAnimateCompletion:YES];
}

#pragma mark UI

- (void)openCameraAnimate
{
    [camManager startRuning];
    [UIView animateWithDuration:0.3f animations:^{
        upOverlay.frame = CGRectMake(upOverlay.frame.origin.x,
                                     CENTERLAYOUT - 2*upOverlay.frame.size.height,
                                     upOverlay.frame.size.width,
                                     upOverlay.frame.size.height);
        downOverlay.frame = CGRectMake(downOverlay.frame.origin.x,
                                       CENTERLAYOUT + downOverlay.frame.size.height,
                                       downOverlay.frame.size.width,
                                       downOverlay.frame.size.height);
    }completion:^(BOOL finished) {
        
        [self enableButton];
    }];
}

- (void)closeCameraAnimateCompletion:(BOOL)stopSession
{
    
    [self disableButton];
    [UIView animateWithDuration:0.3f animations:^{
        upOverlay.frame = CGRectMake(upOverlay.frame.origin.x,
                                     CENTERLAYOUT - upOverlay.frame.size.height + 40,
                                     upOverlay.frame.size.width,
                                     upOverlay.frame.size.height);
        downOverlay.frame = CGRectMake(downOverlay.frame.origin.x,
                                       CENTERLAYOUT,
                                       downOverlay.frame.size.width,
                                       downOverlay.frame.size.height);
    }completion:^(BOOL finished) {
        if (stopSession) {
            [camManager stopRuning];
        }
    }];
}

- (void)changePhotoUI
{

    currentModel = photoModel;
    [self removeRecordProgressBar];
    
    recordBtn.transform = CGAffineTransformIdentity;
    photoBtn.transform = CGAffineTransformIdentity;
    flashBtn.transform = CGAffineTransformIdentity;
    
//    posBtn.center = CGPointMake(160, posBtn.center.y);
    flashBtn.hidden = NO;
    nextBtn.hidden = YES;
    
//    albumBtn.center = CGPointMake(60, albumBtn.center.y);
    photoBtn.center = CGPointMake(160, photoBtn.center.y);
    recordBtn.center = CGPointMake(260, recordBtn.center.y);
    
    [photoBtn setImage:[UIImage imageNamed:@"camera-shutter-default.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"camera-shutter-active.png"] forState:UIControlStateHighlighted];
    
    [recordBtn setImage:[UIImage imageNamed:@"camera-handle-video.png"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"camera-handle-video.png"] forState:UIControlStateHighlighted];
    
    
    [recordBtn removeTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
    [recordBtn removeTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn removeTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpOutside];
    
    [recordBtn addTarget:self action:@selector(takeRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-disabled"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    nextBtn.userInteractionEnabled = NO;
    
    [self resetDeleteButton];
    albumBtn.hidden = YES;
    if ([camManager currentVideoPosition] == AVCaptureDevicePositionFront)
    {
        [self toggleCamera:nil];
    }
    
    photoBtn.userInteractionEnabled = YES;
    photoBtn.alpha = 1.0f;
    
}

- (void)changeRecordUI
{
    
    currentModel = recordModel;
    
    recordBtn.transform = CGAffineTransformIdentity;
    photoBtn.transform = CGAffineTransformIdentity;
    flashBtn.transform = CGAffineTransformIdentity;
    
//    posBtn.center = CGPointMake(160, posBtn.center.y);
    flashBtn.hidden = YES;
    nextBtn.hidden = NO;
    
//    albumBtn.center = CGPointMake(260, albumBtn.center.y);
    photoBtn.center = CGPointMake(260, photoBtn.center.y);
    recordBtn.center = CGPointMake(160, recordBtn.center.y);
    
    [photoBtn setImage:[UIImage imageNamed:@"camera-handle-photo.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"camera-handle-photo.png"] forState:UIControlStateHighlighted];
    
    [recordBtn setImage:[UIImage imageNamed:@"camera-shutter-video-default.png"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"camera-shutter-video-default-active.png"] forState:UIControlStateHighlighted];
    
    
    [recordBtn removeTarget:self action:@selector(takeRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    [recordBtn addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self createRecordProgressBar];
    
    isStartRecording = YES;
    
    if ([camManager currentVideoPosition] == AVCaptureDevicePositionFront)
    {
        [self toggleCamera:nil];
    }
    
}

- (void)disableButton
{
    photoBtn.userInteractionEnabled = NO;
    recordBtn.userInteractionEnabled = NO;
    albumBtn.userInteractionEnabled = NO;
    positionBtn.userInteractionEnabled = NO;
    
    photoBtn.alpha = 0.5;
    recordBtn.alpha = 0.5;
    albumBtn.alpha = 0.5;
    positionBtn.alpha = 0.5;
    
    if (!flashBtn.hidden) {
        flashBtn.userInteractionEnabled = NO;
        flashBtn.alpha = 0.5f;
    }
//    if (!nextBtn.hidden) {
//        nextBtn.userInteractionEnabled = NO;
//        nextBtn.alpha = 0.5f;
//    }
}

- (void)enableButton
{
    photoBtn.userInteractionEnabled = YES;
    recordBtn.userInteractionEnabled = YES;
    albumBtn.userInteractionEnabled = YES;
    positionBtn.userInteractionEnabled = YES;
    
    photoBtn.alpha = 1;
    recordBtn.alpha = 1;
    albumBtn.alpha = 1;
    positionBtn.alpha = 1;
    
    if (!flashBtn.hidden) {
        flashBtn.userInteractionEnabled = YES;
        flashBtn.alpha = 1;
    }
//    if (!nextBtn.hidden) {
//        nextBtn.userInteractionEnabled = YES;
//        nextBtn.alpha = 1;
//    }
}

- (void)deleteRecord:(id)sender
{
    [albumBtn setImage:[UIImage imageNamed:@"camera-backspace-confirm-default@2x.png"] forState:UIControlStateNormal];
    [albumBtn setImage:[UIImage imageNamed:@"camera-backspace-confirm-active@2x.png"] forState:UIControlStateHighlighted];
    [albumBtn removeTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn addTarget:self action:@selector(cofirmDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cofirmDeleteRecord:(id)sender
{
    
    // 删除 之前录制的视频.
    
    [self initialRecordModel];
}

- (void)resetDeleteButton
{
    [albumBtn setImage:[UIImage imageNamed:@"camera-backspace-default-default@2x.png"] forState:UIControlStateNormal];
    [albumBtn setImage:[UIImage imageNamed:@"camera-backspace-default-default@2x.png"] forState:UIControlStateHighlighted];
    [albumBtn removeTarget:self action:@selector(cofirmDeleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn addTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggleCamera:(id)sender
{
    [camManager changeCamera];
    
    if ([camManager currentVideoPosition] == AVCaptureDevicePositionFront)
    {
        flashBtn.userInteractionEnabled = NO;
        flashBtn.alpha = 0.5f;
    }
    else
    {
        flashBtn.userInteractionEnabled = YES;
        flashBtn.alpha = 1.0f;
    }
    
    NSLog(@"change camera device position");
}
- (void)toggleFlashMode:(id)sender
{
//    [camManager setFlashMode:AVCaptureFlashModeAuto];
//    [camManager setFlashMode:AVCaptureFlashModeOff];
    
    switch ([camManager getFlashMode]) {
        case AVCaptureFlashModeOn:
        {
            [camManager setFlashMode:AVCaptureFlashModeAuto];
            [flashBtn setImage:[UIImage imageNamed:@"camera-glyph-flash-auto.png"] forState:UIControlStateNormal];
            break;
        }
        case AVCaptureFlashModeAuto:
        {
            [camManager setFlashMode:AVCaptureFlashModeOff];
            [flashBtn setImage:[UIImage imageNamed:@"camera-glyph-flash-off.png"] forState:UIControlStateNormal];
            break;
        }
        case AVCaptureFlashModeOff:
        {
            [camManager setFlashMode:AVCaptureFlashModeOn];
            [flashBtn setImage:[UIImage imageNamed:@"camera-glyph-flash-on.png"] forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
    
    
    NSLog(@"change camera flash mode");
    
}
- (void)takePhoto:(id)sender
{
    NSLog(@"take photo");
    
    if (currentModel != photoModel)
    {
        // 切换 拍照模式
        // 动画  2 秒
        [self closeCameraAnimateCompletion:YES];
        [self performSelector:@selector(openCameraAnimate) withObject:nil afterDelay:1.0f];
        
        
        [camManager clearMovieCache];
        
        [self changePhotoUI];
        
        [self disableButton];
        
        
    }
    else
    {
        [self closeCameraAnimateCompletion:NO];
        [camManager snapStillImage:^(UIImage *stillImage, NSError *error) {
           // UIImageWriteToSavedPhotosAlbum(stillImage, nil, NULL, nil);
           // NSLog(@"save image");
            [self push:stillImage];
        }];
        
        
        
    }
}

- (void)push:(UIImage *)stillImage
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    GKFilterViewController *filterVC = [[GKFilterViewController alloc] init];
    filterVC.sourceImage = stillImage;
    filterVC.isPreview = YES; // 预览页面.
//    filterVC.isEnableFilter = YES;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)focusPoint:(UITapGestureRecognizer *)sender
{
    [camManager setCameraFoucusWithPoint:[sender locationInView:sender.view]];
}


- (void)chooseAlbum:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)takeRecord:(UIButton *)sender
{
    
    if (currentModel != recordModel)
    {
        // 切换 录像模式
        // 动画  2 秒   动画期间 禁用所有按钮.
        
        [self closeCameraAnimateCompletion:YES];
        [self performSelector:@selector(openCameraAnimate) withObject:nil afterDelay:1.0f];
//        [self disableButton];
        
        [self changeRecordUI];
        
        
        
    }
    
}

- (void)startRecord:(id)sender
{
//    [self resetDeleteButton];
    
    if (isStartRecording) {
        NSLog(@"start Record");
        [camManager startRecord];
        isStartRecording = NO;
    }
    else {
        NSLog(@"resume Record");
        [camManager resumeCapture];
    }
}



- (void)stopRecord:(id)sender
{
    
    NSLog(@"pause Record");
    
    albumBtn.hidden = NO;
    [camManager pauseCapture];
    
    photoBtn.userInteractionEnabled = NO;
    photoBtn.alpha = 0.5f;
}


- (void)recordNext:(id)sender
{
    
    [camManager stopCapture];
    [self closeCameraAnimateCompletion:YES];
    
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-disabled"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    nextBtn.userInteractionEnabled = NO;
}

- (void)didFinishedRecord:(NSString *)path
{
    [self performSelectorOnMainThread:@selector(pushRecordViewController:) withObject:path waitUntilDone:YES];
}
- (void)pushRecordViewController:(NSString *)sender
{
    
    GKFilterViewController *filterVC = [[GKFilterViewController alloc] init];
    filterVC.moviePath = sender;
    [self.navigationController pushViewController:filterVC animated:YES];
    [filterVC release];
    NSLog(@"push record ");
}



- (void)createRecordProgressBar
{
    GKRecordProgressView *s = (GKRecordProgressView *)[bottomView viewWithTag:RECORD_PROGRESS_TAG];
    if (!s) {
        GKRecordProgressView *slider = [[GKRecordProgressView alloc] initWithFrame:CGRectMake(0, -5, 320, 10)];
//        slider.progress = 0.5;
        slider.tag = RECORD_PROGRESS_TAG;
        slider.delegate = self;
        [bottomView addSubview:slider];
        
        [camManager setProgressBar:slider];
    }
}

- (void)removeRecordProgressBar
{
    GKRecordProgressView *s = (GKRecordProgressView *)[bottomView viewWithTag:RECORD_PROGRESS_TAG];
    
    if (nil != s) {
        [s removeFromSuperview];
    }
}

- (void)reachMinProgress
{
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-active"] stretchableImageWithLeftCapWidth:3 topCapHeight:15] forState:UIControlStateHighlighted];
    nextBtn.userInteractionEnabled = YES;
}

- (void)notifyStopRecord:(NSNotification *)notifi
{
    [self closeCameraAnimateCompletion:YES];
    [camManager stopCapture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

@end
