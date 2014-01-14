//
//  GKMovieDownloader.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-14.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKMovieDownloader : NSObject
{
    
}
@property (nonatomic, retain)NSString *diskCachePath;


+ (GKMovieDownloader *)shareMovieDownloader;
- (void)downloadMovieByURL:(NSString *)url;


@end
