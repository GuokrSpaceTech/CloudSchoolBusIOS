/*
     File: AVCamViewController.m
 Abstract: A view controller that coordinates the transfer of information between the user interface and the capture manager.
  Version: 2.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "AVCamViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GKLoaderManager.h"

#import "GKShowViewController.h"
#import "KKNavigationController.h"
static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface AVCamViewController () <UIGestureRecognizerDelegate>
@end

@interface AVCamViewController (InternalMethods)
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)updateButtonStates;
@end

@interface AVCamViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>
@end

@implementation AVCamViewController

@synthesize captureManager;
//@synthesize cameraToggleButton;
//@synthesize recordButton;
//@synthesize stillButton;
@synthesize focusModeLabel;
@synthesize videoPreviewView;
@synthesize captureVideoPreviewLayer;
@synthesize imageData;
//- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode
//{
//	NSString *focusString = @"";
//	
//	switch (focusMode) {
//		case AVCaptureFocusModeLocked:
//			focusString = @"locked";
//			break;
//		case AVCaptureFocusModeAutoFocus:
//			focusString = @"auto";
//			break;
//		case AVCaptureFocusModeContinuousAutoFocus:
//			focusString = @"continuous";
//			break;
//	}
//	
//	return focusString;
//}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode"];
	[captureManager release];
    [videoPreviewView release];
	[captureVideoPreviewLayer release];
   // [cameraToggleButton release];
   // [recordButton release];
   // [stillButton release];
	[focusModeLabel release];
	self.imageData=nil;
    [super dealloc];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:YES];
}
- (void)viewDidLoad
{
    //[[self cameraToggleButton] setTitle:NSLocalizedString(@"Camera", @"Toggle camera button title")];
    //[[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
    //[[self stillButton] setTitle:NSLocalizedString(@"Photo", @"Capture still image button title")];
    self.navigationController.navigationBarHidden=YES;
	if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		[manager release];
		
		[[self captureManager] setDelegate:self];

		if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self videoPreviewView];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];

			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
            [self updateButtonStates];
			
            // Create the focus mode UI overlay
//			UILabel *newFocusModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewLayer.bounds.size.width - 20, 20)];
//			[newFocusModeLabel setBackgroundColor:[UIColor clearColor]];
//			[newFocusModeLabel setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.50]];
//			AVCaptureFocusMode initialFocusMode = [[[captureManager videoInput] device] focusMode];
//			//[newFocusModeLabel setText:[NSString stringWithFormat:@"focus: %@", [self stringForFocusMode:initialFocusMode]]];
//			[view addSubview:newFocusModeLabel];
			[self addObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
//			[self setFocusModeLabel:newFocusModeLabel];
//            [newFocusModeLabel release];
            
            // Add a single tap gesture to focus on the point tapped, then lock focus
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
			[singleTap setDelegate:self];
			[singleTap setNumberOfTapsRequired:1];
			[view addGestureRecognizer:singleTap];
			
            // Add a double tap gesture to reset the focus mode to continuous auto focus
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
			[doubleTap setDelegate:self];
			[doubleTap setNumberOfTapsRequired:2];
			[singleTap requireGestureRecognizerToFail:doubleTap];
			[view addGestureRecognizer:doubleTap];
			
			[doubleTap release];
			[singleTap release];
		}		
	}
		
    [super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
		//[focusModeLabel setText:[NSString stringWithFormat:@"focus: %@", [self stringForFocusMode:(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue]]]];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Toolbar Actions
- (IBAction)toggleCamera:(id)sender
{
//    // Toggle between cameras when there is more than one
//    [[self captureManager] toggleCamera];
//    
//    // Do an initial focus
//    [[self captureManager] continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

- (IBAction)toggleRecording:(id)sender
{
    // Start recording if there isn't a recording running. Stop recording if there is.
   // [[self recordButton] setEnabled:NO];
//    if (![[[self captureManager] recorder] isRecording])
//        [[self captureManager] startRecording];
//    else
//        [[self captureManager] stopRecording];
}
-(void)reTake:(id)sender
{
    UIView *flashView=[self.view.window viewWithTag:1111];
    
    [flashView removeFromSuperview];
    flashView=nil;
}
-(IBAction)cancel:(UIButton *)btn;
{
 
//    [self dismissViewControllerAnimated:YES completion:^{
//            
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];

    
}
-(NSString *)fileName
{
 
    int a=arc4random()%1000;
    
    NSDate *date=[NSDate date];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    
    NSLog(@"%f",time);
   
    return [NSString stringWithFormat:@"%d%d",(int)time,a];

}
-(void)usePhoto:(id)sender
{

    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:self.imageData], self, nil, nil);
    UIView *flashView=[self.view.window viewWithTag:1111];
    
    [flashView removeFromSuperview];
    flashView=nil;
}
-(NSString *)fileName:(int)index
{
    
    int a=arc4random()%1000;
    
    NSDate *date=[NSDate date];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    
    NSLog(@"%f",time);
    
    return [NSString stringWithFormat:@"%d%d%d",(int)time,a,index];
    
    
}
- (IBAction)captureStillImage:(id)sender
{
    // Capture a still image
   // [[self stillButton] setEnabled:NO];
    
    [[self captureManager] captureStillImage:^(NSData * image) {
        
       // UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:image], self, nil, NULL);
      //  self.imageData=image;
        UIView *flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
       // flashView.contentMode=UIViewContentModeScaleAspectFill;
        [flashView setBackgroundColor:[UIColor whiteColor]];
        flashView.tag=1111;
        [[[self view] window] addSubview:flashView];
            [UIView animateWithDuration:.2f
                             animations:^{
                                 [flashView setAlpha:0.f];
                             }
                             completion:^(BOOL finished){
                                 [flashView removeFromSuperview];
                                 [flashView release];
                                
                                NSMutableArray *arr11=[NSMutableArray arrayWithObjects:image,nil];
                                GKShowViewController *showVC=[[GKShowViewController alloc]init];
                                showVC.assetArr=arr11;
                              //  showVC.type=2;
                                 
                                 
                                 [self.navigationController pushViewController:showVC animated:YES];

                                 [showVC release];
                             }
             ];

    }];
}

@end

@implementation AVCamViewController (InternalMethods)

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
		CGPoint convertedFocusPoint = [captureVideoPreviewLayer captureDevicePointOfInterestForPoint:tapPoint];
        [captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will focus as needed at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported])
        [captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Update button states based on the number of available cameras and mics
- (void)updateButtonStates
{

}

@end

@implementation AVCamViewController (AVCamCaptureManagerDelegate)

- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
       // [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Toggle recording button stop title")];
       // [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
       // [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
        //[[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        //
       // [[self stillButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
	[self updateButtonStates];
}

@end
