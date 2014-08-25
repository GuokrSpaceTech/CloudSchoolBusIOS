//
//  AudioPlayer.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioStreamer.h"

static AudioPlayer *audio=nil;
@implementation AudioPlayer
@synthesize audioPath;
+(AudioPlayer *)instance
{
    if(audio==nil)
    {
        audio=[[AudioPlayer alloc]init];
        
        
    }
    return audio;
}
-(void)dealloc
{
    self.audioPath=nil;
    [super dealloc];
}
-(BOOL)isPlaying
{
    return streamer.isPlaying;
}
- (void)startPlay
{
    [streamer start];
}
-(NSString *)getAudioPath
{
    return self.audioPath;
}
-(void)stopPlay
{
    [streamer stop];
}
- (void)destroyStreamer
{
	if (streamer)
	{
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		//[self setButtonImageNamed:@"loadingbutton.png"];
	}
	else if ([streamer isPlaying])
	{
		//[self setButtonImageNamed:@"stopbutton.png"];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PLAYINGSTOP" object:nil];
        
		//[self setButtonImageNamed:@"playbutton.png"];
	}
}
- (void)createStreamer:(NSString *)_audioPath
{
	if (streamer)
	{
		return;
	}
    self.audioPath=_audioPath;
	//[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)_audioPath,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    //NSLog(downloadSourceField.text);
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	[streamer start];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}
@end
