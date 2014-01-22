//
//  GKMovieCache.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 14-1-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKMovieCache : NSObject


+ (unsigned long long)getSize;
+ (void)clearDiskCache;


+ (BOOL)isContainMovieByURL:(NSString *)url;  // 判断本地是否包含此视频.

@end
