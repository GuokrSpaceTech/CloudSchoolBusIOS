//
//  GKMovieDownloader.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-14.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRadialProgressView.h"

@protocol GKMovieDownloaderDelegate <NSObject>

- (void)didFinishedDownloadMovieWithPath:(NSString *)path;

@end

@interface GKMovieDownloader : NSObject
{
    int s;   // 已经接收的字节数
}
@property (nonatomic, retain)NSString *diskCachePath;
@property (nonatomic, retain) NSString *movieURL;
@property (nonatomic, assign) id<GKMovieDownloaderDelegate> delegate;
@property (nonatomic, retain) MDRadialProgressView *radiaProgress;


- (id)initWithMovieURL:(NSString *)url;
- (void)startDownload;

@end
