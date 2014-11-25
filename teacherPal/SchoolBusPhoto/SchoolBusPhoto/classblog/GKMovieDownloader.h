//
//  GKMovieDownloader.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-14.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRadialProgressView.h"
#import "ASIHTTPRequest.h"

typedef void(^GKMovieDownloadCompletedBlock)(NSString *path, NSError *error);
typedef void (^GKProgressBlock)(unsigned long long size, unsigned long long total,NSString *downloadingPath);

@class GKMovieDownloader;

@protocol GKMovieDownloaderDelegate <NSObject>

@optional
- (void)downloader:(GKMovieDownloader *)dl didFinishedDownloadMovieWithPath:(NSString *)path;

@end

@interface GKMovieDownloader : NSObject
{
    int s;   // 已经接收的字节数
    ASIHTTPRequest *request;
}
@property (nonatomic, retain)NSString *diskCachePath;
@property (nonatomic, retain) NSString *movieURL;
@property (nonatomic, assign) id<GKMovieDownloaderDelegate> delegate;

@property (nonatomic, assign) GKMovieDownloadCompletedBlock completion;
@property (nonatomic, assign) GKProgressBlock progress;


- (id)initWithMovieURL:(NSString *)url;
- (void)startDownload;
- (void)cancelRequest;




@end
