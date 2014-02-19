//
//  GKUpQueue.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-24.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
//#import "UIImage+GKImage.h"

@interface GKUpQueue : NSObject

@property (nonatomic,retain)ASINetworkQueue *queue;
@property (nonatomic,assign)BOOL isLoading;

-(void)addRequestToQueue:(NSString *)path name:(NSString *)name nameid:(NSString *)nameId studentid:(NSString *)std time:(NSNumber *)time fize:(NSNumber *)fsize classID:(NSNumber *)classid intro:(NSString *)intro tag:(NSString *)tag;
+(id)creatQueue;
-(void)ChageCoreDataDeleteOrUoloadingAlter:(BOOL)an  picId:(NSString *)picId picPath:(NSString *)path;
-(void)removeQueueAqueuest:(NSString *)nameid;
@end
