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
@property (nonatomic, retain) NSString *movieURL;


- (id)initWithMovieURL:(NSString *)url;


@end
