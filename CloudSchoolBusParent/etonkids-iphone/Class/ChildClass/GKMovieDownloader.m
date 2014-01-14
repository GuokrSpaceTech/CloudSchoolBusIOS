//
//  GKMovieDownloader.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-14.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieDownloader.h"
#import "ASIHTTPRequest.h"

@implementation GKMovieDownloader

@synthesize diskCachePath;

static GKMovieDownloader *downloader;

+ (GKMovieDownloader *)shareMovieDownloader
{
    @synchronized(self)
    {
        if (downloader == nil) {
            downloader = [[GKMovieDownloader alloc] init];
            
            
        }
        return downloader;
    }

}
- (void)downloadMovieByURL:(NSString *)url completion:(void (^)())complete
{
    NSArray *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:url];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url])
    {
        //直接读取
    }
    else
    {
        //xiazai
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDownloadDestinationPath:path];
//        [request setDownloadProgressDelegate:];
        [request setCompletionBlock:^{
            
        }];
        [request setFailedBlock:^{
            NSLog(@"ASIHttpRequest %@ error ",url);
        }];
        
        [request startAsynchronous];
    }
    
}





- (void)failWithError:(NSError *)theError
{
    NSLog(@"ASIHttpRequest error : %@",theError);
}

@end
