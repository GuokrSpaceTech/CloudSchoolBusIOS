//
//  VideoEncoder.m
//  Encoder Demo
//
//  Created by Geraint Davies on 14/01/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import "VideoEncoder.h"

#define MAX_RECORD_TIMING 8

@implementation VideoEncoder

@synthesize path = _path;

+ (VideoEncoder*) encoderForPath:(NSString*) path Height:(int) cy width:(int) cx channels: (int) ch samples:(Float64) rate;
{
    VideoEncoder* enc = [VideoEncoder alloc];
    [enc initPath:path Height:cy width:cx channels:ch samples:rate];
    return enc;
}


- (void) initPath:(NSString*)path Height:(int) cy width:(int) cx channels: (int) ch samples:(Float64) rate;
{
    self.path = path;
    
    [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
    NSURL* url = [NSURL fileURLWithPath:self.path];
    NSLog(@"##########################       new writer");
    _writer = [AVAssetWriter assetWriterWithURL:url fileType:AVFileTypeQuickTimeMovie error:nil];
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              AVVideoCodecH264, AVVideoCodecKey,
                              [NSNumber numberWithInt: cx], AVVideoWidthKey,
                              [NSNumber numberWithInt: cy], AVVideoHeightKey,
                              nil];
    _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    _videoInput.expectsMediaDataInRealTime = YES;
    [_writer addInput:_videoInput];
    
    settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                          [ NSNumber numberWithInt: ch], AVNumberOfChannelsKey,
                                          [ NSNumber numberWithFloat: rate], AVSampleRateKey,
                                          [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
                nil];
    _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    _audioInput.expectsMediaDataInRealTime = YES;
    [_writer addInput:_audioInput];
}

- (void) finishWithCompletionHandler:(void (^)(void))handler
{
    [_writer finishWritingWithCompletionHandler: handler];
}

- (void)cancelWrite:(void (^)(void))handler
{
    [_writer finishWritingWithCompletionHandler:handler];
}

- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)bVideo
{
    @synchronized(self)
    {
        if (CMSampleBufferDataIsReady(sampleBuffer))
        {
            if (_writer.status == AVAssetWriterStatusUnknown)
            {
                CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                [_writer startWriting];
                [_writer startSessionAtSourceTime:startTime];
                time = ((double)startTime.value)/startTime.timescale;
                NSLog(@"~~~~~~~~~  start : %f,write status : %d    path : %@",time,_writer.status,self.path);
                
            }
            if (_writer.status == AVAssetWriterStatusFailed)
            {
                NSLog(@"writer error %@", _writer.error.localizedDescription);
                return NO;
            }
            if (bVideo)
            {
                if (_videoInput.readyForMoreMediaData == YES)
                {
                    [_videoInput appendSampleBuffer:sampleBuffer];
                    
                    CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    
                    float s = ((double)startTime.value)/startTime.timescale;
                    
                    float value = (s - time) / MAX_RECORD_TIMING;
                    //                NSLog(@"progress : %f",value);
                    if (self.slider) {
                        [self performSelectorOnMainThread:@selector(setProgress:) withObject:[NSString stringWithFormat:@"%f",value] waitUntilDone:NO];
                        if (self.slider.progress >= 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecord" object:nil];
                        }
                    }
                    
                    return YES;
                }
            }
            else
            {
                if (_audioInput.readyForMoreMediaData)
                {
                    [_audioInput appendSampleBuffer:sampleBuffer];
                    return YES;
                }
            }
            
            
            
        }
    }
    
    return NO;
}
- (void)setProgress:(NSString *)sender
{
    self.slider.progress = sender.floatValue;
}

@end
