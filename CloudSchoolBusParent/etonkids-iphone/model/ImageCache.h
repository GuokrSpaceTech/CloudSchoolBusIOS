//
//  ImageCache.h
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+(void) addImageToDictionary:(UIImage *)value Key:(NSString *)_key;
+(UIImage *)getImageForKey:(NSString *)key;

@end
