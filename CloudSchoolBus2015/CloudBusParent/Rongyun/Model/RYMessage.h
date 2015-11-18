//
//  RYMessage.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/18.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYMessage : NSObject
@property (nonatomic,copy)NSString * senderid;
@property (nonatomic,copy)NSString * sendertime;
@property (nonatomic,copy)NSString * messagetype;
@property (nonatomic,copy)NSString * messagecontent;
@property (nonatomic,assign)BOOL isRead;
@end
