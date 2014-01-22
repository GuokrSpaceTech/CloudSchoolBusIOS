//
//  GKMovieDownloader.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-14.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieDownloader.h"




@implementation GKMovieDownloader

@synthesize diskCachePath,movieURL,delegate,progress,completion;

- (id)initWithMovieURL:(NSString *)url
{
    if (self = [super init]) {
        
        self = [[GKMovieDownloader alloc] init];
        self.movieURL = url;
        
        
    }
    return self;
    
}

- (void)startDownload
{
    if (self.movieURL != nil)
    {
        [self downloadMovieByURL:self.movieURL];
    }
    else
    {
        NSLog(@"movie url is null");
    }
}


- (void)downloadMovieByURL:(NSString *)url
{
    NSString *mURL = [NSString stringWithFormat:@"%@",url];
    
    NSString *filename = [[mURL componentsSeparatedByString:@"/"] lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:diskPath])
    {
        //直接读取
        if (self.completion != nil) {
            self.completion(diskPath,nil);
        }
        
        
        if (delegate && [delegate respondsToSelector:@selector(downloader:didFinishedDownloadMovieWithPath:)]) {
            [delegate downloader:self didFinishedDownloadMovieWithPath:diskPath];
        }
    }
    else
    {
        //xiazai
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mURL]];
        [request setDownloadDestinationPath:diskPath];
//        [request setDownloadProgressDelegate:];
        [request setDelegate:self];
        [request setAllowResumeForFileDownloads:YES];
        [request setCompletionBlock:^{
            
            if (self.completion != nil) {
                self.completion(diskPath,nil);
            }
            if (delegate && [delegate respondsToSelector:@selector(downloader:didFinishedDownloadMovieWithPath:)]) {
                [delegate downloader:self didFinishedDownloadMovieWithPath:diskPath];
            }
        }];
        
        [request setFailedBlock:^{
            [[NSFileManager defaultManager] removeItemAtPath:diskPath error:nil];
            NSLog(@"ASIHttpRequest %@ error ",mURL);
        }];
        
        s = 0;
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total)
        {
            s += size;
            if (self.progress) {
                self.progress(s,total,self.movieURL);
            }
        }];
        
        [request startAsynchronous];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",[error description]);
}

- (void)dealloc
{
    self.movieURL = nil;


    [super dealloc];
}


- (void)failWithError:(NSError *)theError
{
    NSLog(@"ASIHttpRequest error : %@",theError);
}

- (void)cancelRequest
{
    if (request != nil) {
        [request clearDelegatesAndCancel];
    }
    
}

@end
