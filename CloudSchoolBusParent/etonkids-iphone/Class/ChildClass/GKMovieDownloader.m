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

@synthesize diskCachePath,movieURL;


- (id)initWithMovieURL:(NSString *)url
{
    if (self = [super init]) {
        
        self = [[GKMovieDownloader alloc] init];
        self.movieURL = url;
        NSArray *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:url];
        
    }
    return self;
    
}

- (void)startDownload
{
    [self downloadMovieByURL:self.movieURL];
}

- (void)downloadMovieByURL:(NSString *)url
{
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.diskCachePath])
    {
        //直接读取
    }
    else
    {
        //xiazai
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDownloadDestinationPath:self.diskCachePath];
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
