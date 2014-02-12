//
//  GKMovieCache.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKMovieCache.h"
#import "SDWebImageManager.h"

@implementation GKMovieCache

+ (unsigned long long)getSize
{
    unsigned long long size = 0;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [GKMovieCache videoCachePath];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskPath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskPath stringByAppendingPathComponent:fileName];

        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];

    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    size += [manager.imageCache getSize]; //加上sdwebimage的缓存
    
    return size;
}

+ (void)clearDiskCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[GKMovieCache videoCachePath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[GKMovieCache videoCachePath]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache clearDisk];
    
//    NSLog(@"%lld",[manager.imageCache getSize]);
    
    
}

+ (NSString *)videoCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cloudschoolbus.video"]; // 新建一个文件夹  保存视频
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:diskPath])
    {
        [fileManager createDirectoryAtPath:diskPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return diskPath;
}

+ (BOOL)isContainMovieByURL:(NSString *)url
{
    NSString *mURL = [NSString stringWithFormat:@"%@",url];
    
    NSString *filename = [[mURL componentsSeparatedByString:@"/"] lastObject];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskPath = [[GKMovieCache videoCachePath] stringByAppendingPathComponent:filename];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:diskPath])
        return YES;
    return NO;
}

@end
