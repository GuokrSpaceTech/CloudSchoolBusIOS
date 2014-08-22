//
//  GKMovieManager.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieManager.h"
#import "GKMovieCache.h"
#import "GKMovieDownloader.h"

@implementation GKMovieManager
@synthesize downloadList;

static GKMovieManager *mm ;
+ (id)shareManager
{
    if (mm == nil) {
        mm = [[GKMovieManager alloc] init];
        mm.downloadList = [NSMutableArray array];
    }
    return mm;
}

- (void)toggleMoviePlayingWithCell:(GKMovieCell *)cell
{
    
    //如果正在播放的cell
    
    
    
    if (self.playingCell && ![self.playingCell isEqual:cell]) {
        
        NSLog(@"暂停之前正在播放的cell %@",self.playingCell);
//        /[self.playingCell.mPlayer pause];
        [self.playingCell.mPlayer stop];
    }
    
//    [cell.mPlayer prepareToPlay];
    
    if (cell.mPlayer.contentURL != nil)
    {
        NSLog(@"player 不为空 %d",cell.mPlayer.playbackState); // 0 stop   1 playing   2 pause;
        if (cell.mPlayer.playbackState == MPMoviePlaybackStateStopped)
        {
            [cell.mPlayer prepareToPlay];
          
              // [cell.mPlayer setCurrentPlaybackTime:0.1];
        }
        else
        {
            [cell.mPlayer play];
        }
        
    }
    else
    {
        NSLog(@"player 为空");
    }
    
    self.playingCell = cell;
    
}

- (BOOL)downloadListContainsURL:(NSString *)url
{
    
    for (int i = 0; i < self.downloadList.count; i++) {
        GKMovieDownloader *d = (GKMovieDownloader *)[self.downloadList objectAtIndex:i];
        if ([url isEqualToString:d.movieURL]) {
            
            return YES;
        }
    }
    return NO;
}

- (void)downloadMovieWithURL:(NSString *)dUrl progress:(GKProgressBlock)progress complete:(GKMovieDownloadCompletedBlock)completion
{
    // 判断下载列表是否有此url下载，如果没有 判断是否本地有缓存（是否下载过）如果都没有 去下载并加入到下载列表 下载完成从下载列表中移除.
    if (self.downloadList != nil && [self downloadListContainsURL:dUrl])
    {
        NSLog(@"下载列表存在该视频");
        
        for (int i = 0; i < mm.downloadList.count; i++)
        {
            GKMovieDownloader *d = [mm.downloadList objectAtIndex:i];
            if ([d.movieURL isEqualToString:dUrl]) {
                d.completion = [completion copy];
                d.progress = [progress copy];
                break;
            }
        }
        
        return;
    }
    if ([GKMovieCache isContainMovieByURL:dUrl])
    {
        NSLog(@"本地存在该视频");
        
        NSString *filename = [[dUrl componentsSeparatedByString:@"/"] lastObject];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *diskPath = [[GKMovieCache videoCachePath] stringByAppendingPathComponent:filename];
        
        completion(diskPath,nil);
        
        return;
    }
    NSLog(@"下载该视频");
    
    GKMovieDownloader *d = [[GKMovieDownloader alloc] initWithMovieURL:dUrl];
    d.delegate = self;
    d.completion = [completion copy];
    d.progress = [progress copy];
    [d startDownload];
    
    [self.downloadList addObject:d];
    [d release];
}


- (void)downloader:(GKMovieDownloader *)dl didFinishedDownloadMovieWithPath:(NSString *)path
{
    NSLog(@"从下载列表中移除");
    [self.downloadList removeObject:dl];
}



@end
