//
//  Calculate.m
//  CloudBusParent
//
//  Created by wenpeifang on 15/11/13.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "Calculate.h"
#import "SDImageCache.h"
@implementation Calculate
+(NSString *)dateFromTimeStamp:(int)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *datestr = [formatter stringFromDate:date];
    
    return datestr;
    
}

+ (float)checkTmpSize {
    float totalSize = 0;
    NSString *fullNamespace = [@"com.hackemist.SDWebImageCache." stringByAppendingString:@"default"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *  diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];

    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    } // NSLog(@"tmp size is %.2f",totalSize); return totalSize;
    
    return totalSize;
}
+ (void)clearTmpPics:(void(^)(void))complect
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullNamespace = [@"com.hackemist.SDWebImageCache." stringByAppendingString:@"default"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *  diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
        NSFileManager * manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:diskCachePath error:nil];
        [manager createDirectoryAtPath:diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        if(complect)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                complect();
            });
        }

    });
//    dispatch_async(self.ioQueue, ^{
//        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
//        [_fileManager createDirectoryAtPath:self.diskCachePath
//                withIntermediateDirectories:YES
//                                 attributes:nil
//                                      error:NULL];
//        
//        if (completion) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion();
//            });
//        }
//    });

}
@end
