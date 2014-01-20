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

@synthesize diskCachePath,movieURL,delegate,radiaProgress,progressShowView,shareID;

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
- (void)progressShowInView:(UIView *)view
{
    self.progressShowView = view;
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
        if (delegate && [delegate respondsToSelector:@selector(sharecontent:didFinishedDownloadMovieWithPath:)]) {
            [delegate sharecontent:self.shareID didFinishedDownloadMovieWithPath:diskPath];
        }
    }
    else
    {
        //xiazai
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mURL]];
        [request setDownloadDestinationPath:diskPath];
//        [request setDownloadProgressDelegate:];
        [request setDelegate:self];
        [request setAllowResumeForFileDownloads:YES];
        [request setCompletionBlock:^{
            
            self.radiaProgress.hidden = YES;
            
            if (delegate && [delegate respondsToSelector:@selector(sharecontent:didFinishedDownloadMovieWithPath:)]) {
                [delegate sharecontent:self.shareID didFinishedDownloadMovieWithPath:diskPath];
            }
        }];
        [request setFailedBlock:^{
            [[NSFileManager defaultManager] removeItemAtPath:diskPath error:nil];
            NSLog(@"ASIHttpRequest %@ error ",mURL);
        }];
        
        s = 0;
        
        self.radiaProgress.hidden = NO;
        request.downloadProgressDelegate = self.radiaProgress;
//        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
//            
//            s += size;
//            self.radiaProgress.progressCounter = s;
//            self.radiaProgress.progressTotal = total;
//            
////            NSLog(@"%lld %lld",size,total);
//        }];
        
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
    self.radiaProgress = nil;
    self.progressShowView = nil;
    [super dealloc];
}


- (void)failWithError:(NSError *)theError
{
    NSLog(@"ASIHttpRequest error : %@",theError);
}

@end
