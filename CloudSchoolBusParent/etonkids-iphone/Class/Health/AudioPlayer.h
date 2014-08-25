//
//  AudioPlayer.h
//  ;
//
//  Created by wen peifang on 14-8-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AudioStreamer;

@interface AudioPlayer : NSObject
{
    AudioStreamer *streamer;
}
@property (nonatomic,retain)NSString *audioPath;
+(AudioPlayer *)instance;
- (void)startPlay;
-(BOOL)isPlaying;
-(void)stopPlay;
-(NSString *)getAudioPath;
- (void)destroyStreamer;
- (void)createStreamer:(NSString *)audioPath;
@end
