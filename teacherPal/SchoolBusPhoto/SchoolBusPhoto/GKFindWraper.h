//
//  GKFindWraper.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUpWraper.h"
@interface GKFindWraper : NSObject
+(void) addUpWrapper:(GKUpWraper *)_bookWrapper Key:(NSString *)_key;
+(void)RemoveBookWrapperForKey:(NSString *)_key;
+(GKUpWraper *)getBookWrapper:(NSString *)_key;
@end
