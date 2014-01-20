//
//  GKCoreDataQueue.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-20.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKCoreDataQueue : NSObject
{
    
}
@property (nonatomic) NSOperationQueue *coreDataQueue;
+(GKCoreDataQueue *)queue;

@end
