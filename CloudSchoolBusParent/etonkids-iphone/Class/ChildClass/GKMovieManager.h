//
//  GKMovieManager.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-17.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKMovieCell.h"


//typedef void(^GKMovieDownloadCompletedBlock)(NSString *path, NSError *error);

@interface GKMovieManager : NSObject<GKMovieDownloaderDelegate>

@property (nonatomic, retain)GKMovieCell *playingCell;
@property (nonatomic, retain)NSMutableArray *downloadList;


+ (id)shareManager;

- (void)toggleMoviePlayingWithCell:(GKMovieCell *)cell;
- (void)downloadMovieWithURL:(NSString *)dUrl progress:(GKProgressBlock)progress complete:(GKMovieDownloadCompletedBlock)completion;




@end
