//
//  MessageState.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/18.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYMessage.h"
@interface MessageState : NSObject
+(void)addObjectToArr:(RYMessage *)message;
-(NSMutableArray *)getMessage;
@end
