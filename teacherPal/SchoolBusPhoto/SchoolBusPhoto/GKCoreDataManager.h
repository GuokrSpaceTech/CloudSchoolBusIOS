//
//  GKCoreDataManager.h
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-9.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKCoreDataManager : NSObject

+ (NSArray *)searchMovieDraftByUserid:(NSString *)userid;
+ (BOOL)addMovieDraftWithUserid:(NSString *)userid moviePath:(NSString *)path dateStamp:(NSString *)date;
+ (BOOL)removeMovieDraftByUserid:(NSString *)userid moviePath:(NSString *)path;

@end
