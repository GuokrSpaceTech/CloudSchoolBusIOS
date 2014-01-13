//
//  GKCameraManager.h
//  Camera
//
//  Created by caijingpeng on 13-12-11.
//  Copyright (c) 2013年 caijingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaPlayback.h>

#import "VideoEncoder.h"

@protocol GKCameraManagerDelegate <NSObject>

- (void)didFinishedRecord:(NSString *)path;

@end



@interface GKCameraManager : NSObject
{
    NSString* capfilename;
}

@property (atomic, readwrite) BOOL isCapturing;
@property (atomic, readwrite) BOOL isPaused;
@property (nonatomic) id<GKCameraManagerDelegate> delegate;

+ (id)manager;

- (void)setup;
//- (void)setupRecord;


//设置显示 预览.
- (void)embedPreviewInView:(UIView *)aView;

- (void)changeCamera; //改变摄像头.

// 拍照.
- (void)snapStillImage:(void (^)(UIImage *stillImage, NSError *error))mBlock;

// 设置焦点
- (void)setCameraFoucusWithPoint:(CGPoint)point;

// 设置闪光灯
- (void)setFlashMode:(AVCaptureFlashMode)flashMode;

- (void)startRuning;
- (void)stopRuning;


// 录像.

- (void)setProgressBar:(GKRecordProgressView *)progress;

- (void) startRecord;
- (void) stopCapture;
- (void) pauseCapture;
- (void) resumeCapture;

// 设置方向
- (void)setCameraOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation;

- (void)clearMovieCache;
- (AVCaptureDevicePosition)currentVideoPosition;
- (AVCaptureFlashMode)getFlashMode;

@end
