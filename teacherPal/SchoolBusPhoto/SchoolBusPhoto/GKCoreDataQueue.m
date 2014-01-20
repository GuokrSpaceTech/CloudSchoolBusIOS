//
//  GKCoreDataQueue.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-20.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCoreDataQueue.h"

static GKCoreDataQueue *coreDataQueue=nil;
@implementation GKCoreDataQueue
@synthesize coreDataQueue;
+(GKCoreDataQueue *)queue
{
    if(coreDataQueue==nil)
    {
        coreDataQueue=[[GKCoreDataQueue alloc] init];
    }
    
    return coreDataQueue;
}
-(id)init
{
    if(self=[super init])
    {
        self.coreDataQueue = [NSOperationQueue new];
        [self.coreDataQueue addObserver:self forKeyPath:@"operationCount" options:0 context:NULL];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (object == self.parseQueue && [keyPath isEqualToString:@"operationCount"]) {
//        
//        if (self.parseQueue.operationCount == 0) {
//          
//        }
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

-(void)dealloc
{
    self.coreDataQueue=nil;
    [super dealloc];
}
@end
