//
//  GKMovieCache.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieCache.h"

@implementation GKMovieCache

+ (id)shareMovieCache
{
    @synchronized(self)
    {
        static GKMovieCache *mc;
        if (mc == nil) {
            mc = [[GKMovieCache alloc] init];
        }
        return mc;
    }
}

+ (unsigned long long)getSize
{
    unsigned long long size = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [paths objectAtIndex:0];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskPath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskPath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

@end
