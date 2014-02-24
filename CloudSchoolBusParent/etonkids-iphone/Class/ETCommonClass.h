//
//  ETCommonClass.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-16.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKRequest.h"
#import "ETKids.h"

typedef void (^CompleteBlock)(NSError *err);


@interface ETCommonClass : NSObject<EKProtocol>
{
    CompleteBlock cBlock;
    
    NSString *preSid;
}
@property (nonatomic, retain)NSString *preSid;;

- (void)requestLoginWithComplete:(CompleteBlock)block;
- (void)changeChildByClass:(NSString *)cid student:(NSString *)stuid WithComplete:(CompleteBlock)block;

+ (void)logoutAndClearUserMessage;

- (void)mutiDeviceLogin;
+ (void)clearUserMessage;

@end
