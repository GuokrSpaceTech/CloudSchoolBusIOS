//
//  GKCameraManager.m
//  Camera
//
//  Created by caijingpeng on 13-12-11.
//  Copyright (c) 2013年 caijingpeng. All rights reserved.
//

#import "GKCameraManager.h"
#import "UIImage+GKImage.h"
#import <AssetsLibrary/AssetsLibrary.h>


static int frameNum = 0;
static GKCameraManager *cameraManager;

@interface GKCameraManager  () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession* _session;
    AVCaptureVideoPreviewLayer* _preview;
    dispatch_queue_t _captureQueue;
    AVCaptureDeviceInput *_videoDeviceInput;
    AVCaptureConnection* _audioConnection;
    AVCaptureConnection* _videoConnection;
    dispatch_queue_t _sessionQueue;
    AVCaptureStillImageOutput *_stillImageOutput;
    
    VideoEncoder* _encoder;
    BOOL _isCapturing;
    BOOL _isPaused;
    BOOL _discont;
    int _currentFile;
    CMTime _timeOffset;
    CMTime _lastVideo;
    CMTime _lastAudio;
    
    int _cx;
    int _cy;
    int _channels;
    Float64 _samplerate;
    
    GKRecordProgressView *_progress;
    
    
    AVCaptureVideoOrientation currentVideoOrientation;
}
@end

@implementation GKCameraManager
@synthesize delegate;

+ (id)manager
{
    if (nil == cameraManager) {
        cameraManager = [[GKCameraManager alloc] init];
    }
    return cameraManager;
}



- (void)setup
{
    if (nil == _session) {
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPreset640x480];
        
        [self checkDeviceAuthorizationStatus];
        
        _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
        
        //        dispatch_async(_sessionQueue, ^{
        //            [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [GKCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        
        
        //-------------- input -------------------
        
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@",error);
        }
        if ([_session canAddInput:videoDeviceInput])
        {
            [_session addInput:videoDeviceInput];
            _videoDeviceInput = videoDeviceInput;
        }
        
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([_session canAddInput:audioDeviceInput])
        {
            [_session addInput:audioDeviceInput];
        }
        
        //--------------- output ------------------
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        
        if ([_session canAddOutput:stillImageOutput])
        {
            NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      AVVideoCodecJPEG, AVVideoCodecKey,
//                                      [NSNumber numberWithInt: 480], AVVideoWidthKey,
//                                      [NSNumber numberWithInt: 480], AVVideoHeightKey,
                                      AVVideoScalingModeFit, AVVideoScalingModeKey,
                                      nil];
            [stillImageOutput setOutputSettings:settings];
            [_session addOutput:stillImageOutput];
            _stillImageOutput = stillImageOutput;
        }
        
        
        _captureQueue = dispatch_queue_create("uk.co.gdcl.cameraengine.capture", DISPATCH_QUEUE_SERIAL);
        AVCaptureVideoDataOutput* videoout = [[AVCaptureVideoDataOutput alloc] init];
        [videoout setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        videoout.videoSettings = setcapSettings;
        [_session addOutput:videoout];
        
        
        
        _videoConnection = [videoout connectionWithMediaType:AVMediaTypeVideo];
        // find the actual dimensions used so we can set up the encoder to the same.
      //  NSDictionary* actual = videoout.videoSettings;
//        _cy = (int)[[actual objectForKey:@"Height"] integerValue];
//        _cx = (int)[[actual objectForKey:@"Width"] integerValue];
        _cy = 480;
        _cx = 480;
        
        [_videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        AVCaptureAudioDataOutput* audioout = [[AVCaptureAudioDataOutput alloc] init];
        [audioout setSampleBufferDelegate:self queue:_captureQueue];
        [_session addOutput:audioout];
        _audioConnection = [audioout connectionWithMediaType:AVMediaTypeAudio];
        
        
        //        });
        
    }
}


- (void)startRuning
{
    if (nil != _session) {
        [_session startRunning];
    }
}

- (void)stopRuning
{
    if (nil != _session) {
        [_session stopRunning];
//        _session = nil;
    }
}


- (AVCaptureDevicePosition)currentVideoPosition
{
    return [[_videoDeviceInput device] position];
}

- (void)changeCamera
{
	
//	dispatch_async(_sessionQueue, ^{
		AVCaptureDevice *currentVideoDevice = [_videoDeviceInput device];
		AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
		AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
		
		switch (currentPosition)
		{
			case AVCaptureDevicePositionUnspecified:
				preferredPosition = AVCaptureDevicePositionBack;
				break;
			case AVCaptureDevicePositionBack:
				preferredPosition = AVCaptureDevicePositionFront;
				break;
			case AVCaptureDevicePositionFront:
				preferredPosition = AVCaptureDevicePositionBack;
				break;
		}
		
		AVCaptureDevice *videoDevice = [GKCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
		AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
		
		[_session beginConfiguration];
		
		[_session removeInput:_videoDeviceInput];
		if ([_session canAddInput:videoDeviceInput])
		{
//			[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
//			
//			[AVCamViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
//			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
			
			[_session addInput:videoDeviceInput];
            _videoDeviceInput = videoDeviceInput;
		}
		else
		{
			[_session addInput:_videoDeviceInput];
		}
		
		[_session commitConfiguration];
		
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[[self cameraButton] setEnabled:YES];
//			[[self recordButton] setEnabled:YES];
//			[[self stillButton] setEnabled:YES];
//		});
//	});
}



- (void)snapStillImage:(void (^)(UIImage *stillImage, NSError *error))mBlock
{
    
    [[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:currentVideoOrientation];
		// Capture a still image.
        
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSLog(@"%@",error.description);
        
        if (imageDataSampleBuffer)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
                
            UIImage *sImg = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0f)];
                
            UIImage *img = [sImg fixOrientation];
            CGImageRef imgRef;
            
            
            if (currentVideoOrientation == AVCaptureVideoOrientationPortrait)
            {
                imgRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 80, 480, 480));
            }
            else
            {
                imgRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(80, 0, 480, 480));
            }
            
            UIImage *a = [UIImage imageWithCGImage:imgRef];
            
            mBlock(a, error);

        }
    }];
    
}

- (void)embedPreviewInView:(UIView *)aView
{
    if (!_session) {
        return;
    }
    
//    if (_preview) {
//        [_preview removeFromSuperlayer];
//    }
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.frame = aView.bounds;
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer:_preview];
    
    
//    NSDictionary *outputSettings = @{AVVideoWidthKey : @(CGRectGetWidth(_preview.bounds)),
//                                     AVVideoHeightKey: @(CGRectGetWidth(_preview.bounds)),
//                                     AVVideoCodecKey : AVVideoCodecJPEG};
//    [_stillImageOutput setOutputSettings:outputSettings];
}

- (void)setCameraFoucusWithPoint:(CGPoint)point
{
    CGPoint devicePoint = [_preview captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

#pragma mark Device Configuration

- (void)setCameraOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation
{
    currentVideoOrientation = toInterfaceOrientation;
//    [[_preview connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
    
    
    
    
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
//	dispatch_async(_sessionQueue, ^{
		AVCaptureDevice *device = [_videoDeviceInput device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
		 	NSLog(@"%@", error);
		}
//	});
}

- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    
    AVCaptureDevice *device = [self backFacingCamera];
    
	if ([device hasFlash] && [device isFlashModeSupported:flashMode])
	{
		NSError *error = nil;
        
		if ([device lockForConfiguration:&error])
		{
			[device setFlashMode:flashMode];
			[device unlockForConfiguration];
		}
		else
		{
			NSLog(@"%@", error);
		}
	}
}

- (AVCaptureFlashMode)getFlashMode
{
    AVCaptureDevice *device = [_videoDeviceInput device];
    return device.flashMode;
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
	AVCaptureDevice *captureDevice = [devices firstObject];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == position)
		{
			captureDevice = device;
			break;
		}
	}
	
	return captureDevice;
}

#pragma mark UI

- (void)runStillImageCaptureAnimation
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[_preview setOpacity:0.0];
		[UIView animateWithDuration:.25 animations:^{
			[_preview setOpacity:1.0];
		}];
	});
}

#pragma mark check device

- (void)checkDeviceAuthorizationStatus
{
//	NSString *mediaType = AVMediaTypeVideo;
//    
//    if (ios7) {
//        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
//            if (granted)
//            {
//                //Granted access to mediaType
//                //			[self setDeviceAuthorized:YES];
//            }
//            else
//            {
//                //Not granted access to mediaType
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[[UIAlertView alloc] initWithTitle:@"AVCam!"
//                                                message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
//                                               delegate:self
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil] show];
//                    //				[self setDeviceAuthorized:NO];
//                });
//            }
//        }];
//	}
	
}


#pragma mark record 

- (void)setProgressBar:(GKRecordProgressView *)progress
{
    _progress = progress;
}

- (void) startRecord
{
    @synchronized(self)
    {
        NSLog(@"~~~~~~~ %d",self.isCapturing);
        if (!self.isCapturing)
        {
            NSLog(@"starting capture");
            
            // create the encoder once we have the audio params
            if (_encoder) {
                [_encoder release];
            }
            _encoder = nil;
            self.isPaused = NO;
            _discont = NO;
            _timeOffset = CMTimeMake(0, 0);
            self.isCapturing = YES;
        }
    }
}


//新建相册
- (void)saveToAlbumWithVideo:(NSURL *)videoURL
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:CUSTOMALBUMNAME]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL *assetURL, NSError *error) {
        
        [assetsLibrary addAssetsGroupAlbumWithName:CUSTOMALBUMNAME resultBlock:^(ALAssetsGroup *group) {
            if (group) {
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                } failureBlock:^(NSError *error) {
                    if (failureBlock) {
                        failureBlock(error);
                    }
                }];
            } else {
                AddAsset(assetsLibrary, assetURL);
            }
        } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
        }];
        
    }];
}

- (void) stopCapture
{
    @synchronized(self)
    {
        if (self.isCapturing)
        {
//            NSString* filename = [NSString stringWithFormat:@"capture%d.mp4", _currentFile];
            NSString* filename = [NSString stringWithFormat:@"capture1.mp4"];
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            NSURL* url = [NSURL fileURLWithPath:path];
            _currentFile++;
            
            
            // serialize with audio and video capture
            
            self.isCapturing = NO;
            dispatch_async(_captureQueue, ^{
                [_encoder finishWithCompletionHandler:^{
//                    [self performSelectorOnMainThread:@selector(resetRecordPara) withObject:nil waitUntilDone:NO];
                    [_encoder release];
                    _encoder = nil;
                    
                    NSString *oFilename = [NSString stringWithFormat:@"output%d.mp4",(int)[[NSDate date] timeIntervalSince1970]];
                    NSString *oPath = [NSTemporaryDirectory() stringByAppendingPathComponent:oFilename];
                    NSURL *outputURL = [NSURL fileURLWithPath:oPath];
                    
                    [self lowQuailtyWithInputURL:url outputURL:outputURL blockHandler:^(AVAssetExportSession *session) {
                        
                        if (session.status == AVAssetExportSessionStatusCompleted)
                        {
                            
                            [self saveToAlbumWithVideo:outputURL completionBlock:^{
                                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                                
                                if (delegate && [delegate respondsToSelector:@selector(didFinishedRecord:)]) {
                                    [delegate didFinishedRecord:oPath];
                                }
                            } failureBlock:^(NSError *error) {
                                NSLog(@"save completed %@",error);
                            }];
                            
                            
//                            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
//                                NSLog(@"save completed %@",error);
//                                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//                                
//                                if (delegate && [delegate respondsToSelector:@selector(didFinishedRecord:)]) {
//                                    [delegate didFinishedRecord:oPath];
//                                }
//                                
//                            }];
                            
                            
                        }
                        else
                        {
                            NSLog(@"export error and session.status = %d",session.status);
                            NSError *error;
                            [[NSFileManager defaultManager] removeItemAtPath:oPath error:&error];
                            NSLog(@" %@", error);
//                            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                            //导出 错误
                            
//                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"MOVIEDATA_EXPORT_ERROR" object:nil];
                            
                        }
                        
                    }];
                    
                    
                }];
            });
        }
    }
}

- (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    
    AVURLAsset *asset=[AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeMPEG4;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         
         switch (session.status) {
             case AVAssetExportSessionStatusUnknown:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 
                 
                 break;
             case AVAssetExportSessionStatusWaiting:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 
                 
                 break;
             case AVAssetExportSessionStatusExporting:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 
                 
                 break;
             case AVAssetExportSessionStatusCompleted:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 
                 
                 break;
             case AVAssetExportSessionStatusCancelled:
                 
                 
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 
                 
                 break;
             default:
                 break;
         }
         
         handler(session);
     }];
}





- (void) pauseCapture
{
    @synchronized(self)
    {
        if (self.isCapturing)
        {
            NSLog(@"Pausing capture");
            self.isPaused = YES;
            _discont = YES;
            
            [_progress markSegment];
        }
    }
}

- (void) resumeCapture
{
    @synchronized(self)
    {
        if (self.isPaused)
        {
            NSLog(@"Resuming capture");
            self.isPaused = NO;
        }
    }
}

- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset
{
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++)
    {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

- (void) setAudioFormat:(CMFormatDescriptionRef) fmt
{
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    _samplerate = asbd->mSampleRate;
    _channels = asbd->mChannelsPerFrame;
    
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    BOOL bVideo = YES;
    
    @synchronized(self)
    {
        if (!self.isCapturing  || self.isPaused)
        {
            return;
        }
        if (connection != _videoConnection)
        {
            bVideo = NO;
        }
        
        if ((_encoder == nil) && !bVideo)
        {
            frameNum = 0;
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            [self setAudioFormat:fmt];
//            NSString* filename = [NSString stringWithFormat:@"capture%d.mp4", _currentFile];
            NSString* filename = [NSString stringWithFormat:@"capture1.mp4"];
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            _encoder = [VideoEncoder encoderForPath:path Height:_cy width:_cx channels:_channels samples:_samplerate];
            
            if (_progress) {
                _encoder.slider = _progress;
            }
        }
        if (_discont)
        {
            if (bVideo)
            {
                return;
            }
            _discont = NO;
            // calc adjustment
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime last = bVideo ? _lastVideo : _lastAudio;
            if (last.flags & kCMTimeFlags_Valid)
            {
                
                NSLog(@"~~~~ %f",((double)pts.value/pts.timescale));
                if (_timeOffset.flags & kCMTimeFlags_Valid)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);
                NSLog(@"Setting offset from %s", bVideo ? "video" : "audio");
                NSLog(@"Adding %f to %f (pts %f),(last %f)", ((double)offset.value)/offset.timescale, ((double)_timeOffset.value)/_timeOffset.timescale, ((double)pts.value/pts.timescale), ((double)last.value/last.timescale));
                
                // this stops us having to set a scale for _timeOffset before we see the first video time
                if (_timeOffset.value == 0)
                {
                    _timeOffset = offset;
                }
                else
                {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideo.flags = 0;
            _lastAudio.flags = 0;
        }
        
        // retain so that we can release either this or modified one
        CFRetain(sampleBuffer);
        
        if (_timeOffset.value > 0)
        {
            CFRelease(sampleBuffer);
            //            NSLog(@"####  %f",((double)_timeOffset.value/_timeOffset.timescale));
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        
        // record most recent time so we know the length of the pause
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0)
        {
            pts = CMTimeAdd(pts, dur);
        }
        if (bVideo)
        {
            _lastVideo = pts;
        }
        else
        {
            _lastAudio = pts;
        }
        
        
        frameNum++;
        // pass frame to encoder
        
        if (frameNum >1) {  //删除前两帧
            [_encoder encodeFrame:sampleBuffer isVideo:bVideo];
            CFRelease(sampleBuffer);
        }
        
        CMSampleBufferGetImageBuffer(sampleBuffer);
    }
    
}



- (void)clearMovieCache
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* filename = [NSString stringWithFormat:@"capture1.mp4"];
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        self.isCapturing = NO;
    });
}


@end
