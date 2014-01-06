//
//  ImageCache.m
//  etonkids-iphone
//
//  Created by WenPeiFang on 1/31/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ImageCache.h"
static NSMutableDictionary *imageDic=nil;
@implementation ImageCache

+(void) addImageToDictionary:(UIImage *)value Key:(NSString *)_key
{
    if(imageDic==nil)
    {
        imageDic=[[NSMutableDictionary alloc]init];
    }
    [imageDic setObject:value forKey:_key];
}

+(UIImage *)getImageForKey:(NSString *)key;
{
    BOOL found=NO;
    NSArray *arr=[imageDic allKeys];
    
    for (int i=0; i<[arr count]; i++) {
        
        NSString *_key=[arr objectAtIndex:i];
        
        if([_key isEqualToString:key])
        {
            found=YES;
            break;
        }
        else
            found=NO;
        
        
    }
    
    if(found==YES)
    {
        return [imageDic objectForKey:key];
    }


    return nil;
}
@end
