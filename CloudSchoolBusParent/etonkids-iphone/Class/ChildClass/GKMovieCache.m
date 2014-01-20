//
//  GKMovieCache.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieCache.h"

@implementation GKMovieCache

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

+ (void)clearDiskCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [paths objectAtIndex:0];
    [[NSFileManager defaultManager] removeItemAtPath:diskPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

@end
