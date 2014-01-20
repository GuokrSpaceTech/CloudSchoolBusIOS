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

@end
